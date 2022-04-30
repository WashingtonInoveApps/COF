import 'dart:typed_data';

import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireRepository implements IAppRepository {
  final _instance = FirebaseFirestore.instance;

  @override
  Future<bool> saveCar({required CarModel car, required String unidade, String? id}) async {
    try {
      var doc = _instance.collection("cars").doc(id);
      car.id = doc.id;

      for (var change in car.changes) {
        if (change.fileImage != null) change.image = await _saveImage(image: change.fileImage!, unidade: unidade, id: car.id!);
      }

      (id == null) ? await doc.set(car.toMap()) : await doc.update(car.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveCheckList({required CheckListModel checkList, required String unidade, String? id}) async {
    try {
      var doc = _instance.collection("checklist").doc(id);
      var docCar = _instance.collection("cars").doc(checkList.checkCar.car.id);

      checkList.id = doc.id;
      await _instance.runTransaction((trans) async {
        for (var change in checkList.checkCar.car.changes) {
          if (change.fileImage != null) {
            change.image = await _saveImage(image: change.fileImage!, unidade: unidade, id: checkList.checkCar.car.id!);
            change.checklistId = checkList.id;
          }
        }

        // if (checkList.supply.isNotEmpty) {
        //   for (var item in checkList.supply) {
        //     final docSupply = docCar.collection('supplies').doc(item.id);
        //     if (item.id == null) {
        //       item.idCheckList = checkList.id;
        //       item.id = docSupply.id;
        //       trans.set(docSupply, item.toMap());
        //     }
        //   }
        // }

        (id == null) ? trans.set(doc, checkList.toMap()) : trans.update(doc, checkList.toMap());
        trans.update(docCar, {"changes": List<dynamic>.from(checkList.checkCar.car.changes.map((e) => e.toMap())), "km": checkList.checkCar.car.km});
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveSupplies({required SupplyModel supply, required CheckListModel checklist}) async {
    try {
      final docChecklist = _instance.collection("checklist").doc(checklist.id);
      final docSupplies = _instance.collection("supplies").doc(supply.id);

      supply.checklistId = checklist.id;
      supply.id = docSupplies.id;
      supply.carId = checklist.checkCar.car.id;

      await _instance.runTransaction((trans) async {
        trans.set(docSupplies, supply.toMap());

        var supplies = List<SupplyModel>.from(checklist.supply);
        supplies.add(supply);

        final data = supplies.map((e) => e.toMap()).toList();
        trans.update(docChecklist, {'supply': data});
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> _saveImage({required Uint8List image, required String unidade, required String id}) async {
    String _arq = "${DateTime.now().millisecondsSinceEpoch.toString()}.png";
    TaskSnapshot upload =
        await FirebaseStorage.instance.ref().child('imagens').child(unidade.replaceAll(' ', "")).child(id).child(_arq).putData(image);

    return await upload.ref.getDownloadURL();
  }

  @override
  Stream<List<CarModel>> listenCar() {
    return _instance.collection("cars").snapshots().map((e) => e.docs.map((doc) {
          var car = CarModel.fromMap(doc.data());
          car.id = doc.id;
          return car;
        }).toList());
  }

  @override
  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return _instance.collection("mapas").where("carId", isEqualTo: carId).snapshots().map((e) => e.docs.map((doc) {
          var mapa = CarMapaModel.fromMap(doc.data());
          mapa.id = doc.id;
          return mapa;
        }).toList());
  }

  @override
  Stream<List<CheckListModel>> listenCheckList({required String referenceDate}) {
    return _instance.collection("checklist").where("referenceDate", isEqualTo: referenceDate).snapshots().map((e) => e.docs.map((doc) {
          var checkList = CheckListModel.fromMap(doc.data());
          checkList.id = doc.id;
          return checkList;
        }).toList());
  }

  @override
  Stream<List<UserModel>> listenUsers() {
    return _instance.collection("users").snapshots().map((e) => e.docs.map((doc) {
          var user = UserModel.fromMap(doc.data());
          user.id = doc.id;
          return user;
        }).toList());
  }

  @override
  Stream<List<CarStatusModel>> listenStatusCar({required String carId}) {
    return _instance.collection("cars").doc(carId).collection("status").snapshots().map((e) => e.docs.map((doc) {
          var carStatu = CarStatusModel.fromMap(doc.data());
          carStatu.id = doc.id;
          return carStatu;
        }).toList());
  }

  @override
  Future<bool> updateStatusCar({required CarStatusModel status, required String id, required bool enable}) async {
    try {
      final docCar = _instance.collection('cars').doc(id);
      final docStatus = docCar.collection('status').doc();

      await _instance.runTransaction((trans) async {
        status.id = docStatus.id;
        trans.update(docCar, {'enable': enable});
        trans.set(docStatus, status.toMap());
      });
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
  Future<bool> insertMapaCar({required CarMapaModel mapa}) async {
    try {
      final docMapa = _instance.collection("mapas").doc();
      final docCar = _instance.collection("cars").doc(mapa.carId);

      mapa.id = docMapa.id;
      await _instance.runTransaction((trans) async {
        trans.update(docCar, {'km': int.parse(mapa.kmFinal)});
        trans.set(docMapa, mapa.toMap());
      });

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
        trans.update(docCar, {"km": int.parse(kmFinal)});
        trans.update(doc, {"enable": false, "kmFinal": kmFinal, "dateFinish": DateTime.now().millisecondsSinceEpoch});
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
      await _instance.collection("users").doc(user.id).set(user.toMap());

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
        UserModel user = UserModel.fromMap(result.data()!);
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

  @override
  Future<bool> deleteSupply({required SupplyModel supply, required CheckListModel checklist}) async {
    try {
      final docChecklist = _instance.collection("checklist").doc(checklist.id);
      final docSupplies = _instance.collection("supplies").doc(supply.id);

      await _instance.runTransaction((trans) async {
        trans.delete(docSupplies);

        var supplies = List<SupplyModel>.from(checklist.supply);
        supplies.remove(supply);

        final data = supplies.map((e) => e.toMap()).toList();
        trans.update(docChecklist, {'supply': data});
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> stateUser({required UserModel user}) async {
    try {
      await _instance.collection('users').doc(user.id).update({'enable': !user.enable});
      return true;
    } catch (e) {
      return false;
    }
  }
}
