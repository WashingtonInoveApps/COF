import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppRepository extends APIClient implements IAppRepository {
  AppRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> saveSupplies(
      {required SupplyModel supply, required CheckListModel checklist}) async {
    try {
      final docChecklist = colChecklist.doc(checklist.id);
      final docSupplies = colSupplies.doc(supply.id);

      supply.checklistId = checklist.id;
      supply.id = docSupplies.id;
      supply.carId = checklist.checkCar.car.id;

      await firebase!.runTransaction((trans) async {
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
    return colChecklist
        .where("referenceDate", isEqualTo: referenceDate)
        .snapshots()
        .map((e) => e.docs.map((doc) {
              var checkList =
                  CheckListModel.fromMap(doc.data() as Map<String, dynamic>);
              checkList.id = doc.id;
              return checkList;
            }).toList());
  }

  @override
  Stream<List<CarModel>> listenCar() {
    return colCars.snapshots().map((e) => e.docs.map((doc) {
          var car = CarModel.fromMap(doc.data() as Map<String, dynamic>);
          car.id = doc.id;
          return car;
        }).toList());
  }

  @override
  Stream<List<UserModel>> listenUsers() {
    return colUsers.snapshots().map((e) => e.docs.map((doc) {
          var user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
          user.id = doc.id;
          return user;
        }).toList());
  }

  @override
  Future<UserModel?> login(
      {required String email, required String senha}) async {
    try {
      var response = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      if (response.user != null) {
        String id = response.user!.uid;
        final result = await colUsers.doc(id).get();

        if (!result.exists || result.data() == null) {
          throw Exception("Usuário não encontrado.");
        }

        UserModel user =
            UserModel.fromMap(result.data() as Map<String, dynamic>);
        return user;
      }

      return null;
    } on FirebaseAuthException catch (e) {
      throw Exception("Erro Auth: ${e.code}");
    } on FirebaseException catch (e) {
      throw Exception("Erro Firestore: ${e.message}");
    } catch (e) {
      throw Exception("Erro inesperado: $e");
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
      var docCheckList = colChecklist.doc(checklist.id);
      var docCar = colCars.doc(car.id);

      await firebase!.runTransaction((trans) async {
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
      final docChecklist = colChecklist.doc(checklist.id);
      final docSupplies = colSupplies.doc(supply.id);

      await firebase!.runTransaction((trans) async {
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
