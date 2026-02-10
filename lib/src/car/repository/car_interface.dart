import 'package:bsu_control/model/check_list_model.dart';

import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';

abstract class ICarRepository {
  Future<bool> save({required CarModel car, required List<dynamic> images});
  Future<bool> copy({required CarModel car});

  Future<bool> saveStatusCar({required CarModel car, CarStatusModel? status});
  Future<bool> updateKMCar(
      {required String id, required Map<String, dynamic> data});
  Future<bool> deleteCar({required String id});

  Future<bool> deleteStatusCar(
      {required CarModel car, required CarStatusModel status});

  Stream<List<CarStatusModel>> listenStatusCar({required String carId});
  Stream<List<CarStatusModel>> listenStatusCarGeral();

  Stream<List<CarMapaModel>> listenMapas({required String carId});

  Future<bool> deleteCarMapa({required String id});
  Future<bool> insertMapaCar({required CarMapaModel mapa});

  Future<List<CheckListModel>> getChecklistByMonth(
      {required DateTime reference});
}
