import 'dart:typed_data';

import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';

import '../../../model/check_list_model.dart';

class CheckListRepository extends APIClient implements ICheckListRepository {
  CheckListRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save(
      {required CheckListModel checklist,
      required List<CarChangeModel> changes}) async {
    try {
      var doc = colChecklist.doc(checklist.id);
      var docCar = colCars.doc(checklist.checkCar.car.id);

      checklist.id = doc.id;

      await firebase!.runTransaction((trans) async {
        final carData = await docCar.get();
        final car = CarModel.fromMap(carData.data() as Map<String, dynamic>);

        for (var change in changes) {
          if (change.fileImage != null) {
            change.image = await saveFile(
                pathStorage: 'imagens/cars/${checklist.prefix}',
                data: change.fileImage!,
                filename:
                    '${checklist.prefix}_${DateTime.now().millisecondsSinceEpoch}.png');

            if (change.image == null) {
              return Exception(
                  'Falha ao salvar imagem da alteração do veículo.');
            }

            change.checklistID = checklist.id;
          }
        }

        trans.set(
            doc,
            checklist
                .copyWith(
                    changes: changes
                        .where((e) => e.checklistID == checklist.id)
                        .toList())
                .toMap());

        trans.update(
            docCar,
            car
                .copyWith(
                    changes: changes,
                    km: int.parse(checklist.startKM),
                    state: StatusCar.operando)
                .toMap());
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> finish(
      {required CheckListModel checklist, Uint8List? image}) async {
    try {
      var docChecklist = colChecklist.doc(checklist.id);
      var docCar = colCars.doc(checklist.checkCar.car.id);

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
        trans.update(docCar, {"km": int.parse(checklist.endKM)});

        trans.update(
            docChecklist, checklist.copyWith(signature: result).toMap());
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<CheckListModel> streamChecklistByID({required String checklistID}) {
    return colChecklist
        .doc(checklistID)
        .snapshots()
        .map((e) => CheckListModel.fromMap(e.data() as Map<String, dynamic>));
  }

  @override
  Stream<List<CheckListModel>> streamChecklistPeriod(
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
      return e.docs.map((doc) {
        var checkList =
            CheckListModel.fromMap(doc.data() as Map<String, dynamic>);
        checkList.id = doc.id;
        return checkList;
      }).toList();
    });
  }

  @override
  Stream<List<CheckListModel>> streamChecklistUser({required String userID}) {
    return colChecklist.where('userID', isEqualTo: userID).snapshots().map((e) {
      return e.docs.map((doc) {
        var checkList =
            CheckListModel.fromMap(doc.data() as Map<String, dynamic>);
        checkList.id = doc.id;
        return checkList;
      }).toList();
    });
  }
}
