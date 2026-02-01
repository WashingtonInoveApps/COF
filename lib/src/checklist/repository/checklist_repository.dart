import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/car_changes_model.dart';
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
      List<CarChangeModel> checklistChanges = [];

      await firebase!.runTransaction((trans) async {
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
            checklistChanges.add(change);
          }
        }

        trans.set(doc, checklist.copyWith(changes: checklistChanges).toMap());

        trans.update(docCar, {
          "changes": List<dynamic>.from(changes.map((e) => e.toMap())),
          "km": int.parse(checklist.startKM)
        });
      });

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> finish(
      {required String kmFinal, required CheckListModel checkList}) async {
    try {
      var doc = colChecklist.doc(checkList.id);
      var docCar = colCars.doc(checkList.checkCar.car.id);

      await firebase!.runTransaction((trans) async {
        trans.update(docCar, {"km": int.parse(kmFinal)});
        trans.update(doc, {
          "enable": false,
          "kmFinal": kmFinal,
          "dateFinish": DateTime.now().millisecondsSinceEpoch
        });
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<String> saveImage(
  //     {required Uint8List image,
  //     required String unidade,
  //     required String id}) async {
  //   String arq = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
  //   TaskSnapshot upload = await FirebaseStorage.instance
  //       .ref()
  //       .child('imagens')
  //       .child(unidade.replaceAll(' ', ""))
  //       .child(id)
  //       .child(arq)
  //       .putData(image);

  //   return await upload.ref.getDownloadURL();
  // }
}
