import 'dart:typed_data';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireRepository implements IAppRepository {
  final _instance = FirebaseFirestore.instance;

  @override
  Future<bool> saveCar({required CarModel car, String? id}) async {
    try {
      var doc = _instance.collection("cars").doc(id);
      car.id = doc.id;

      for (var change in car.changes) {
        if (change.fileImage != null) change.image = await _saveImage(image: change.fileImage!);
      }

      (id == null) ? await doc.set(car.toJson()) : await doc.update(car.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveCheckList({required CheckListModel checkList, required int updateCar, String? id}) async {
    try {
      var doc = _instance.collection("checklist").doc(id);
      var docCar = _instance.collection("cars").doc(checkList.checkCar.car.id);

      checkList.id = doc.id;
      await _instance.runTransaction((trans) async {
        if (updateCar == 1) {
          for (var change in checkList.checkCar.car.changes) {
            if (change.fileImage != null) change.image = await _saveImage(image: change.fileImage!);
          }
        }

        trans.update(docCar, {"changes": List<dynamic>.from(checkList.checkCar.car.changes.map((e) => e.toJson())), "km": checkList.checkCar.car.km});
        (id == null) ? trans.set(doc, checkList.toJson()) : trans.update(doc, checkList.toJson());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _saveImage({required Uint8List image}) async {
    String _arq = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    TaskSnapshot upload = await FirebaseStorage.instance.ref().child('imagens').child(_arq).putData(image);

    return await upload.ref.getDownloadURL();
  }

  @override
  Stream<List<CarModel>> listenCar() {
    return _instance.collection("cars").snapshots().map((e) => e.docs.map((doc) {
          var car = CarModel.from(doc.data());
          car.id = doc.id;
          return car;
        }).toList());
  }

  @override
  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return _instance.collection("mapas").where("carId", isEqualTo: carId).snapshots().map((e) => e.docs.map((doc) {
          var mapa = CarMapaModel.from(doc.data());
          mapa.id = doc.id;
          return mapa;
        }).toList());
  }

  @override
  Stream<List<CheckListModel>> listenCheckList({required String referenceDate}) {
    return _instance.collection("checklist").where("referenceDate", isEqualTo: referenceDate).snapshots().map((e) => e.docs.map((doc) {
          var checkList = CheckListModel.from(doc.data());
          checkList.id = doc.id;
          return checkList;
        }).toList());
  }

  @override
  Future<bool> updateStatusCar({required List<CarStatusModel> status, required String id, required bool enable}) async {
    try {
      await _instance.collection("cars").doc(id).update({"status": List<dynamic>.from(status.map((e) => e.toJson()).toList()), "enable": enable});
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateKMCar({required String id, required Map<String, dynamic> data}) async {
    try {
      await _instance.collection("cars").doc(id).update(data);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapas}) async {
    try {
      final doc = _instance.collection("mapas").doc();

      mapas.id = doc.id;
      await doc.set(mapas.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> finishCheckList({required String kmFinal, required CheckListModel checkList}) async {
    try {
      var doc = _instance.collection("checklist").doc(checkList.id);
      var docCar = _instance.collection("cars").doc(checkList.checkCar.car.id);

      await _instance.runTransaction((trans) async {
        trans.update(docCar, {"km": kmFinal});
        trans.update(doc, {"enable": false, "kmFinal": kmFinal, "dateFinish": DateTime.now()});
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createUser({required UserModel user, required String password}) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: user.email, password: password);

      if (result.user == null) return false;

      user.id = result.user!.uid;
      await _instance.collection("users").doc(user.id).set(user.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> login({required String email, required String senha}) async {
    try {
      var infor = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: senha);

      if (infor.user != null) {
        String id = infor.user!.uid;
        final result = await FirebaseFirestore.instance.collection("users").doc(id).get();
        UserModel user = UserModel.from(result.data()!);
        return user;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> recuperarPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteCarMapa({required String id}) async {
    try {
      await _instance.collection("mapas").doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
