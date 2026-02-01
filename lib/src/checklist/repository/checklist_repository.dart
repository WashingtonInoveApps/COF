import 'dart:typed_data';

import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../model/check_list_model.dart';

class CheckListRepository extends APIClient implements ICheckListRepository {
  CheckListRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save(
      {required CheckListModel checkList,
      required String unidade,
      String? id}) async {
    try {
      var doc = colChecklist.doc(id);
      var docCar = colCars.doc(checkList.checkCar.car.id);

      checkList.id = doc.id;
      await firebase!.runTransaction((trans) async {
        for (var change in checkList.checkCar.car.changes) {
          if (change.fileImage != null) {
            // change.image = await saveImage(
            //     image: change.fileImage!,
            //     unidade: unidade,
            //     id: checkList.checkCar.car.id!);
            // change.checklistId = checkList.id;
          }
        }

        (id == null)
            ? trans.set(doc, checkList.toMap())
            : trans.update(doc, checkList.toMap());
        trans.update(docCar, {
          "changes": List<dynamic>.from(
              checkList.checkCar.car.changes.map((e) => e.toMap())),
          "km": int.parse(checkList.startKM)
        });
      });

      return true;
    } catch (e) {
      return false;
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

  Future<String> saveImage(
      {required Uint8List image,
      required String unidade,
      required String id}) async {
    String arq = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    TaskSnapshot upload = await FirebaseStorage.instance
        .ref()
        .child('imagens')
        .child(unidade.replaceAll(' ', ""))
        .child(id)
        .child(arq)
        .putData(image);

    return await upload.ref.getDownloadURL();
  }
}
