import 'dart:typed_data';

import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/src/car/repository/car_interface.dart';

import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';

class CarRepository extends APIClient implements ICarRepository {
  CarRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Stream<List<CarStatusModel>> listenStatusCar({required String carId}) {
    try {
      return colStatusCars.where('carID', isEqualTo: carId).snapshots().map(
          (e) => e
              .docs
              .map((doc) =>
                  CarStatusModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Stream.value([]);
    }
  }

  @override
  Stream<List<CarStatusModel>> listenStatusCarGeral({required DateTime date}) {
    try {
      return colStatusCars
          .where('referenceYear', isEqualTo: date.year.toString())
          .snapshots()
          .map((e) => e.docs
              .map((doc) =>
                  CarStatusModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Stream.value([]);
    }
  }

  @override
  Future<bool> save(
      {required CarModel car, required List<dynamic> images}) async {
    try {
      var doc = colCars.doc(car.id);
      car.id = doc.id;

      final prefix = car.prefix.replaceAll(" ", "");

      for (final change in car.changes) {
        if (change.fileImage != null) {
          final image = await saveFile(
              pathStorage: 'imagens/changes/$prefix',
              data: change.fileImage!,
              filename: '${prefix}_changes.png');

          if (image == null) {
            throw Exception('Falha ao salvar imagem da alteração.');
          }

          change.image = image;
        }
      }

      List<FileModel?> imagesProcess =
          List.filled(4, FileModel(url: '', name: ''), growable: true);

      for (int i = 0; i < images.length; i++) {
        if (images[i] is Uint8List) {
          final image = await saveFile(
              pathStorage: 'imagens/cars/$prefix',
              data: images[i],
              filename: '${prefix}_${i.toString().padLeft(2, '0')}.png');

          if (image == null) {
            throw Exception('Falha ao salvar imagem da vista do carro.');
          }

          imagesProcess[i] = image;
        } else {
          imagesProcess[i] = images[i];
        }
      }

      car.images = imagesProcess;
      await doc.set(car.toMap());

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveStatusCar(
      {required CarModel car, CarStatusModel? status}) async {
    try {
      final docCar = colCars.doc(car.id);
      final docStatus = colStatusCars.doc();

      await firebase!.runTransaction((trans) async {
        if (status != null) {
          status.id = docStatus.id;
          trans.set(docStatus, status.toMap());
        }

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
  Future<bool> deleteCar({required String id}) async {
    try {
      await colCars.doc(id).delete();

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
      final docStatus = docCar.collection('status').doc(status.id);

      await firebase!.runTransaction((trans) async {
        trans.update(docCar, car.toMap());
        trans.delete(docStatus);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> copy({required CarModel car}) async {
    try {
      var doc = colCars.doc();
      car.id = doc.id;

      await doc.set(car.toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChecklistModel>> getChecklistByMonth(
      {required DateTime reference}) async {
    try {
      return await colChecklist
          .where('referenceMonth',
              isEqualTo:
                  "${reference.month.toString().padLeft(2, '0')}/${reference.year}")
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
