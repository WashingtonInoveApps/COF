import 'dart:typed_data';

import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../model/check_list_model.dart';

class CheckListRepository implements ICheckListRepository {
  final instance = FirebaseFirestore.instance;

  @override
  Future<bool> save(
      {required CheckListModel checkList,
      required String unidade,
      String? id}) async {
    try {
      var doc = instance.collection("checklist").doc(id);
      var docCar = instance.collection("cars").doc(checkList.checkCar.car.id);

      checkList.id = doc.id;
      await instance.runTransaction((trans) async {
        for (var change in checkList.checkCar.car.changes) {
          if (change.fileImage != null) {
            change.image = await saveImage(
                image: change.fileImage!,
                unidade: unidade,
                id: checkList.checkCar.car.id!);
            change.checklistId = checkList.id;
          }
        }

        (id == null)
            ? trans.set(doc, checkList.toMap())
            : trans.update(doc, checkList.toMap());
        trans.update(docCar, {
          "changes": List<dynamic>.from(
              checkList.checkCar.car.changes.map((e) => e.toMap())),
          "km": checkList.checkCar.car.km
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
      var doc = instance.collection("checklist").doc(checkList.id);
      var docCar = instance.collection("cars").doc(checkList.checkCar.car.id);

      await instance.runTransaction((trans) async {
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
