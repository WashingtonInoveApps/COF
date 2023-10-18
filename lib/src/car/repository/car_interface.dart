import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';

abstract class ICarRepository {
  Future<bool> save(
      {required CarModel car, required String unidade, String? id});
  Future<bool> updateStatusCar(
      {required CarStatusModel status,
      required String id,
      required bool enable});
  Future<bool> updateKMCar(
      {required String id, required Map<String, dynamic> data});
  Future<bool> deleteCar({required String id});

  Stream<List<CarStatusModel>> listenStatusCar({required String carId});
  Stream<List<CarMapaModel>> listenMapas({required String carId});

  Future<bool> deleteCarMapa({required String id});
  Future<bool> insertMapaCar({required CarMapaModel mapa});
}
