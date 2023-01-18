import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireRepository implements IAppRepository {
  final _instance = FirebaseFirestore.instance;

  @override
  Future<bool> saveSupplies(
      {required SupplyModel supply, required CheckListModel checklist}) async {
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

  @override
  Stream<List<CheckListModel>> listenChecklist(
      {required String referenceDate}) {
    return _instance
        .collection("checklist")
        .where("referenceDate", isEqualTo: referenceDate)
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var checkList = CheckListModel.fromMap(doc.data());
              checkList.id = doc.id;
              return checkList;
            }).toList());
  }

  @override
  Stream<List<CarModel>> listenCar() {
    return _instance
        .collection("cars")
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var car = CarModel.fromMap(doc.data());
              car.id = doc.id;
              return car;
            }).toList());
  }

  @override
  Stream<List<UserModel>> listenUsers() {
    return _instance
        .collection("users")
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var user = UserModel.fromMap(doc.data());
              user.id = doc.id;
              return user;
            }).toList());
  }

  @override
  Future<UserModel?> login(
      {required String email, required String senha}) async {
    try {
      var infor = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      if (infor.user != null) {
        String id = infor.user!.uid;
        final result =
            await FirebaseFirestore.instance.collection("users").doc(id).get();
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
  Future<bool> deleteChecklist(
      {required CheckListModel checklist, required CarModel car}) async {
    try {
      var docCheckList = _instance.collection("checklist").doc(checklist.id);
      var docCar = _instance.collection("cars").doc(car.id);

      await _instance.runTransaction((trans) async {
        trans.delete(docCheckList);
        trans.update(docCar, car.toMap());
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteSupply(
      {required SupplyModel supply, required CheckListModel checklist}) async {
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
}
