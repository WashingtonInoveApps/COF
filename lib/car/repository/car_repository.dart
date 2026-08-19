import 'dart:developer';

import 'package:bsu_control/car/repository/car_interface.dart';
import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/file_model.dart';

import '../../model/car_mapa_model.dart';
import '../../model/car_model.dart';
import '../../model/car_status_model.dart';
import '../../model/outher_changes_model.dart';

class CarRepository extends APIClient implements ICarRepository {
  CarRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<List<CarStatusModel>> getStatusCar({required String carID}) async {
    return colStatusCars.where('carID', isEqualTo: carID).get().then((e) => e
        .docs
        .map(
            (doc) => CarStatusModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  @override
  Stream<List<CarStatusModel>> listenStatusCarGeral({required DateTime date}) {
    return colStatusCars
        .where('referenceYear', isEqualTo: date.year.toString())
        .snapshots()
        .map((e) {
      return e.docs.map((doc) {
        return CarStatusModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<bool> save({
    required CarModel car,
    required List<FileModel?> images,
    required List<OtherChangeModel> others,
    required List<FileModel> deletedFiles,
  }) async {
    try {
      var doc = colCars.doc(car.id);
      car.id = doc.id;

      List<FileModel?> imagesProcess =
          List.filled(images.length, null, growable: true);

      final prefix = car.prefix.replaceAll(" ", "");

      for (final change in car.changes) {
        if (change.image?.data != null) {
          final image = await saveFile(
              pathStorage: '${Constants.pathCarChangeImages}/$prefix',
              data: change.image!.data!,
              filename: prefix);

          if (image == null) {
            throw Exception('Falha ao salvar imagem da alteração.');
          }

          change.image = change.image?.copyWith(
            name: image.name,
            url: image.url,
            path: image.path,
          );
        }
      }

      for (OtherChangeModel other in others) {
        if (other.image.data != null) {
          final image = await saveFile(
              pathStorage: '${Constants.pathCarOtherImages}/$prefix',
              data: other.image.data!,
              filename: prefix);

          if (image == null) {
            throw Exception('Falha ao salvar imagem da alteração do material.');
          }

          other.image = other.image.copyWith(
            name: image.name,
            url: image.url,
            path: image.path,
          );
        }
      }

      for (int i = 0; i < images.length; i++) {
        if (images[i]?.data != null) {
          final image = await saveFile(
              pathStorage: Constants.pathCarImages,
              data: images[i]!.data!,
              filename: i.toString().padLeft(2, '0'));

          if (image == null) {
            throw Exception('Falha ao salvar imagem da vista do carro.');
          }

          imagesProcess[i] = images[i]?.copyWith(
            name: image.name,
            url: image.url,
            path: image.path,
          );
        } else {
          imagesProcess[i] = images[i];
        }
      }

      if (deletedFiles.isNotEmpty) {
        for (final file in deletedFiles) {
          if (file.path.isNotEmpty) {
            await deleteFile(path: file.path, filename: file.name);
          }
        }
      }

      await doc.set(car
          .copyWith(
            others: others,
            images: imagesProcess,
          )
          .toMap());

      return true;
    } catch (e) {
      log('Error ao salvar carro:', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> saveStatusCar(
      {required CarModel car, required CarStatusModel status}) async {
    try {
      final docCar = colCars.doc(car.id);
      final docStatus = colStatusCars.doc();
      status.id = docStatus.id;

      await firebase!.runTransaction((trans) async {
        trans.set(docStatus, status.toMap());
        trans.update(docCar, car.toMap());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateKMCar(
      {required String id, required Map<String, dynamic> data}) async {
    try {
      await colCars.doc(id).update(data);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete({required CarModel car}) async {
    try {
      List<String> statusIDs = [];

      final query = await colStatusCars.where('carID', isEqualTo: car.id).get();

      for (final doc in query.docs) {
        if (doc.exists) {
          statusIDs.add(doc.id);
        }
      }

      await firebase!.runTransaction((trans) async {
        if (statusIDs.isNotEmpty) {
          for (final id in statusIDs) {
            trans.delete(colStatusCars.doc(id));
          }
        }

        trans.delete(colCars.doc(car.id));
      });

      //Erros de exclusão de imagens irrelevantes.
      //Não excluo as imagens dos veiculos pois podem está sendo usado por outros.
      // for (final image in car.images) {
      //   if (image?.name.isEmpty ?? true) continue;

      //   await deleteFile(
      //       path: Constants.pathCarImages, filename: image?.name ?? '');
      // }

      for (final CarChangeModel change in car.changes) {
        if (change.image?.name.isEmpty ?? true) continue;

        if (change.image?.path.isNotEmpty ?? false) {
          await deleteFile(
              path: change.image?.path ?? '',
              filename: change.image?.name ?? '');
        }
      }

      for (final OtherChangeModel other in car.others ?? []) {
        if (other.image.name.isEmpty) continue;

        if (other.image.path.isNotEmpty) {
          await deleteFile(path: other.image.path, filename: other.image.name);
        }
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapa}) async {
    try {
      final docMapa = firebase!.collection("mapas").doc();
      final docCar = colCars.doc(mapa.carId);

      mapa.id = docMapa.id;
      await firebase!.runTransaction((trans) async {
        trans.update(docCar, {'km': int.parse(mapa.kmFinal)});
        trans.set(docMapa, mapa.toMap());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCarMapa({required String id}) async {
    try {
      await firebase!.collection("mapas").doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return colMaps
        .where("carId", isEqualTo: carId)
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var mapa =
                  CarMapaModel.fromMap(doc.data() as Map<String, dynamic>);
              mapa.id = doc.id;
              return mapa;
            }).toList());
  }

  @override
  Future<bool> deleteStatusCar(
      {required CarModel car, required CarStatusModel status}) async {
    try {
      final docCar = colCars.doc(car.id);
      final docStatus = colStatusCars.doc(status.id);

      await firebase!.runTransaction((trans) async {
        trans.update(docCar, car.toMap());
        trans.delete(docStatus);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // @override
  // Future<bool> copy({required CarModel car}) async {
  //   try {
  //     var doc = colCars.doc();
  //     car.id = doc.id;

  //     await doc.set(car.toMap());
  //     return true;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<List<ChecklistModel>> getChecklistByMonth({
    required DateTime reference,
  }) async {
    try {
      return await colChecklist
          .where('referenceMonth',
              isEqualTo:
                  "${reference.month.toString().padLeft(2, '0')}/${reference.year}")
          .where('type', isEqualTo: 'vehicular')
          .get()
          .then((result) => result.docs
              .map((e) =>
                  ChecklistModel.fromMap(e.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return [];
    }
  }
}
