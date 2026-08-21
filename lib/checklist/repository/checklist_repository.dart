import 'dart:typed_data';

import 'package:bsu_control/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

import '../../core/constants.dart';
import '../../model/checklist_model.dart';
import '../../model/material_checklist_model.dart';

class CheckListRepository extends APIClient implements ICheckListRepository {
  CheckListRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save({
    required ChecklistModel checklist,
  }) async {
    try {
      var doc = colChecklist.doc(checklist.id);
      checklist.id = doc.id;

      final others = List<OtherChangeModel>.from(checklist.others ?? []);

      await firebase!.runTransaction((trans) async {
        if (checklist.vehicular?.changes?.isNotEmpty ?? false) {
          final prefix = checklist.prefix.replaceAll(' ', '');
          for (final change in checklist.vehicular!.changes!) {
            if (change.image?.data != null) {
              final image = await saveFile(
                pathStorage: '${Constants.pathCarChangeImages}/$prefix',
                data: change.image!.data!,
                filename: prefix,
              );

              if (image == null) {
                throw Exception(
                    'Falha ao salvar imagens das alterações do veículo.');
              }

              change.checklistID = checklist.id;
              change.image = change.image?.copyWith(
                name: image.name,
                url: image.url,
                path: image.path,
              );
            }
          }
        }

        if (others.isNotEmpty) {
          for (OtherChangeModel other in others) {
            if (other.image.data != null) {
              final image = await saveFile(
                pathStorage: Constants.pathOthersImages,
                data: other.image.data!,
                filename: other.id,
              );

              if (image == null) {
                throw Exception(
                    'Falha ao salvar imagem das outras alterações.');
              }

              other.checklistID = checklist.id ?? '';
              other.image = other.image.copyWith(
                name: image.name,
                url: image.url,
                path: image.path,
              );
            }
          }
        }

        if (checklist.type == ChecklistType.vehicular) {
          trans.update(
            colCars.doc(checklist.vehicular?.car.id),
            {
              'changes': checklist.vehicular?.changes
                      ?.map((e) => e.toMap())
                      .toList() ??
                  [],
              'km': checklist.startKM,
              'state': StatusCar.operating.name,
              'others': others.map((e) => e.toMap()).toList(),
            },
          );
        } else {
          trans.update(
            colMaterials.doc(checklist.material?.material.id),
            {
              'others': checklist.others?.map((e) => e.toMap()).toList() ?? [],
            },
          );
        }

        trans.set(
            doc,
            checklist
                .copyWith(
                  vehicular: checklist.vehicular?.copyWith(
                    changes: checklist.vehicular?.changes
                            ?.where((e) => e.checklistID == checklist.id)
                            .toList() ??
                        [],
                  ),
                  others: others
                      .where((e) => e.checklistID == checklist.id)
                      .toList(),
                )
                .toMap());
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> finish(
      {required ChecklistModel checklist, Uint8List? image}) async {
    try {
      var docChecklist = colChecklist.doc(checklist.id);
      var docCar = colCars.doc(checklist.vehicular?.car.id);

      if (image == null) {
        throw Exception(
            'Ops ! Assinatura ausente, tente novamente ou contate o suporte.');
      }

      final result = await saveFile(
          pathStorage: 'imagens/checklist/signatures',
          data: image,
          filename: '${checklist.id}.png');

      if (result == null) {
        throw Exception(
            'Ops ! Falha ao salvar assinatura, tente novamente ou contate o suporte.');
      }

      await firebase!.runTransaction((trans) async {
        trans.update(docCar, {"km": checklist.endKM});

        trans.update(
            docChecklist, checklist.copyWith(signature: result).toMap());
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<ChecklistModel> streamChecklistByID({required String checklistID}) {
    return colChecklist
        .doc(checklistID)
        .snapshots()
        .map((e) => ChecklistModel.fromMap(e.data() as Map<String, dynamic>));
  }

  @override
  Stream<List<ChecklistModel>> streamChecklistPeriod(
      {required DateTime referenceDateStart,
      required DateTime referenceDateFinish}) {
    final start = referenceDateStart
        .copyWith(hour: 0, second: 0, minute: 0, millisecond: 0, microsecond: 0)
        .millisecondsSinceEpoch;
    final finish = referenceDateFinish
        .copyWith(
          hour: 23,
          second: 59,
          minute: 59,
        )
        .millisecondsSinceEpoch;

    return colChecklist
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: finish)
        .orderBy('date')
        .snapshots()
        .map((e) {
      return e.docs
          .map((doc) =>
              ChecklistModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Stream<List<ChecklistModel>> streamChecklistUser({required String userID}) {
    return colChecklist.where('userID', isEqualTo: userID).snapshots().map((e) {
      return e.docs
          .map((doc) =>
              ChecklistModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<bool> delete(
      {required ChecklistModel checklist, required CarModel car}) async {
    try {
      var docChecklist = colChecklist.doc(checklist.id);
      var docCar = colCars.doc(car.id);

      await firebase!.runTransaction((trans) async {
        trans.update(docCar, car.toMap());
        trans.delete(docChecklist);
      });

      for (final change in (checklist.vehicular?.changes ?? [])) {
        if (change.image != null) {
          await deleteFile(
              path: 'imagens/changes/${car.prefix}',
              filename: change.image!.name);
        }
      }

      // for (final outher in (checklist.outhers ?? [])) {
      //   if (outher.image != null) {
      //     await deleteFile(
      //         path: 'imagens/changes/${car.prefix}',
      //         filename: outher.image!.name);
      //   }
      // }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MaterialChecklistModel?> getChecklistMaterial({
    required String teamID,
  }) async {
    try {
      return await colMaterials
          .where('teamID', isEqualTo: teamID)
          .limit(1)
          .get()
          .then((query) {
        final doc = query.docs.first;

        return MaterialChecklistModel.fromMap(
            doc.data() as Map<String, dynamic>);
      });
    } catch (e) {
      return null;
    }
  }
}
