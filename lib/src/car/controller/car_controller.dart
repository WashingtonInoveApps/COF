import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/car/repository/car_interface.dart';
import 'package:mobx/mobx.dart';

import '../../../model/car_mapa_model.dart';
import '../../../model/car_model.dart';
import '../../../model/car_status_model.dart';
import '../repository/car_repository.dart';

part 'car_controller.g.dart';

// ignore: library_private_types_in_public_api
class CarController = _CarControllerBase with _$CarController;

abstract class _CarControllerBase with Store {
  final AppController app;
  late ICarRepository repository;

  @observable
  bool loading = false;

  @observable
  String typeCar = '';

  @observable
  ObservableList<ItensChangesModel> sectionsItens =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  @computed
  bool get enable => app.user.admin;

  @computed
  bool get adm => typeCar == Core.carsType.first;

  _CarControllerBase({required this.app}) {
    repository =
        CarRepository(endpoint: app.endpoint, appID: app.appID, test: app.test);
  }

  Stream<List<CarStatusModel>> listenStatus({required String carId}) {
    return repository.listenStatusCar(carId: carId);
  }

  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return repository.listenMapas(carId: carId);
  }

  @action
  setTypeCar(String? value) {
    typeCar = value ?? typeCar;
  }

  @action
  onChangesCar(List<CarChangeModel> value) {
    carChanges
      ..clear()
      ..addAll(value);
  }

  @action
  removeChangesCar(int index) {
    carChanges.removeAt(index);
  }

  @action
  addSections(ItensChangesModel value) {
    sectionsItens.add(value);
  }

  @action
  editSections(int index, ItensChangesModel value) {
    final section =
        sectionsItens[index].copyWith(description: value.description);

    sectionsItens.removeAt(index);
    sectionsItens.insert(index, section);
  }

  @action
  removeSections(int index) {
    sectionsItens.removeAt(index);
  }

  @action
  cleanSections() {
    sectionsItens.clear();
  }

  @action
  expansionSections(int index) {
    final section =
        sectionsItens[index].copyWith(value: !sectionsItens[index].value);
    sectionsItens.removeAt(index);
    sectionsItens.insert(index, section);
  }

  @action
  addItensSection(int index, ItemModel value) {
    final section = ItensChangesModel.fromMap(sectionsItens[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.add(value);

    sectionsItens.removeAt(index);
    sectionsItens.insert(index, section.copyWith(itens: itens));
  }

  @action
  removeItensSection(int index, int itemIndex) {
    final section = ItensChangesModel.fromMap(sectionsItens[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(itemIndex);

    sectionsItens.removeAt(index);
    sectionsItens.insert(index, section.copyWith(itens: itens));
  }

  @action
  Future<bool> saveCar(
      {required CarModel car, required List<dynamic> images}) async {
    try {
      loading = true;
      final result = await repository.save(car: car, images: images);
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
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
      {required CarModel car, CarStatusModel? status}) async {
    loading = true;
    final result = await repository.updateStatusCar(car: car, status: status);
    loading = false;

    return result;
  }

  @action
  Future<bool> deleteStatusCar(
      {required CarModel car, required CarStatusModel status}) async {
    loading = true;
    final result = await repository.deleteStatusCar(car: car, status: status);
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

  @action
  Future<bool> deleteCar({required String id}) async {
    loading = true;
    final result = await repository.deleteCar(id: id);

    loading = false;
    return result;
  }
}
