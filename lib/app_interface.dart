import 'package:bsu_control/model/app_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';

import 'model/supply_model.dart';

abstract class IAppRepository {
  Future<bool> saveSupplies(
      {required SupplyModel supply, required ChecklistModel checklist});

  Stream<List<ChecklistModel>> listenChecklistToday(
      {required DateTime referenceDate});

  Stream<List<CarModel>> listenCar();

  Stream<List<UserModel>> listenUsers();

  Future<List<OBMModel>> getOBMs();

  Future<bool> deleteSupply(
      {required SupplyModel supply, required ChecklistModel checklist});

  Future<AppModel> getAppModel();
  Future<bool> updateAppModel({required AppModel appData});
}
