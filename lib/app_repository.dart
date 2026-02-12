import 'dart:developer';

import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/app_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';

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
  Stream<List<CheckListModel>> listenChecklistToday(
      {required DateTime referenceDate}) {
    try {
      log('Buscando checklist diário: ${Core.formatDate(referenceDate)}');
      return colChecklist
          .where('referenceDate', isEqualTo: Core.formatDate(referenceDate))
          .snapshots()
          .map((e) => e.docs
              .map((doc) =>
                  CheckListModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Stream.value([]);
    }
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

  @override
  Future<List<OBMModel>> getOBMs() async {
    try {
      return await colOBMs.get().then((result) => result.docs
          .map((e) => OBMModel.fromMap(e.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      return [];
    }
  }

  @override
  Future<AppModel> getAppModel() async {
    try {
      return await docApp.get().then(
          (result) => AppModel.fromMap(result.data() as Map<String, dynamic>));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateAppModel({required AppModel appData}) async {
    try {
      await docApp.update(appData.toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
