import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/user_model.dart';

import '../model/supply_model.dart';

abstract class IAppRepository {
  Future<bool> saveCar({required CarModel car, required String unidade, String? id});
  Future<bool> saveCheckList({required CheckListModel checkList, required int updateCar, required String unidade, String? id});

  Future<bool> updateStatusCar({required List<CarStatusModel> status, required String id, required bool enable});
  Future<bool> updateKMCar({required String id, required Map<String, dynamic> data});

  Future<bool> insertMapaCar({required CarMapaModel mapas});

  Stream<List<CarModel>> listenCar();
  Stream<List<CarMapaModel>> listenMapas({required String carId});
  Stream<List<CheckListModel>> listenCheckList({required String referenceDate});

  Future<bool> finishCheckList({required String kmFinal, required CheckListModel checkList});

  Future<bool> deleteCarMapa({required String id});
  
  Future<bool> createUser({required UserModel user, required String password});
  Future<UserModel?> login({required String email, required String senha});
  Future<bool> recuperarPassword({required String email});

  Future<bool> deleteSupply({required List<SupplyModel> supplies, required int index, required String carId});
}
