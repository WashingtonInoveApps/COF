import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/src/car/repository/car_interface.dart';
import 'package:mobx/mobx.dart';

import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';

part 'car_controller.g.dart';

// ignore: library_private_types_in_public_api
class CarController = _CarControllerBase with _$CarController;

abstract class _CarControllerBase with Store {
  final ICarRepository repository;
  final AppController app;

  @observable
  bool loading = false;

  @computed
  bool get enable => app.user.adm;

  _CarControllerBase({required this.app, required this.repository});

  Stream<List<CarStatusModel>> listenStatus({required String carId}) {
    return repository.listenStatusCar(carId: carId);
  }

  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return repository.listenMapas(carId: carId);
  }

  @action
  Future<bool> saveCar({required CarModel car, String? id}) async {
    loading = true;
    final result =
        await repository.save(car: car, unidade: app.unidade, id: id);
    loading = false;

    return result;
  }

  @action
  Future<bool> updateKMOil({required String id, required int value}) async {
    loading = true;
    final result = await repository.updateKMCar(id: id, data: {'oil': value});
    loading = false;

    return result;
  }

  @action
  Future<bool> updateKMArref({required String id, required int value}) async {
    loading = true;
    final result = await repository.updateKMCar(id: id, data: {'arref': value});
    loading = false;

    return result;
  }

  @action
  Future<bool> updateStatusCar(
      {required CarStatusModel status,
      required String id,
      required bool enable}) async {
    loading = true;
    final result = await repository.updateStatusCar(
        status: status, id: id, enable: enable);
    loading = false;

    return result;
  }

  @action
  Future<bool> insertMapaCar({required CarMapaModel mapa}) async {
    loading = true;
    final result = await repository.insertMapaCar(mapa: mapa);
    loading = false;

    return result;
  }

  @action
  Future<bool> deleteCarMapa({required String id}) async {
    loading = true;
    final result = await repository.deleteCarMapa(id: id);

    loading = false;
    return result;
  }
}
