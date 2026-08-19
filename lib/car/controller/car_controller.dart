import 'package:bsu_control/car/repository/car_interface.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../model/car_mapa_model.dart';
import '../../model/car_model.dart';
import '../../model/car_status_model.dart';
import '../../model/file_model.dart';
import '../repository/car_repository.dart';

part 'car_controller.g.dart';

// ignore: library_private_types_in_public_api
class CarController = _CarControllerBase with _$CarController;

abstract class _CarControllerBase with Store {
  final ConfigModel config;
  final UserModel user;

  late ICarRepository repository;

  _CarControllerBase({required this.config, required this.user}) {
    repository = CarRepository(
        endpoint: config.endpoint, appID: config.appID, test: config.test);
  }

  @observable
  bool loading = false;

  @observable
  int step = 0;

  @observable
  DateTime dateKmByMonth = DateTime.now();

  @observable
  bool fieldCarTypeVisible = false;

  @observable
  String filter = '';

  @observable
  DateTime referenceDateDashboard = DateTime.now();

  @observable
  ObservableList<CarModel> cars = <CarModel>[].asObservable();

  @observable
  ObservableList<ChecklistModel> checklistKMByMonth =
      <ChecklistModel>[].asObservable();

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  ObservableList<CarStatusModel> statusGeral =
      <CarStatusModel>[].asObservable();

  bool get enable => (user.managerFleet || user.admin);

  @computed
  List<CarModel> get carsSorts {
    if (filter.isNotEmpty) {
      final filtered = cars
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  ((e.cia?.name.toLowerCase() ?? '')
                      .contains(filter.toLowerCase())) ||
                  (e.type.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.state.label.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<CarModel>.from(list);
    } else {
      final list = Core.paginate(list: cars, page: page, limit: limit);
      return List<CarModel>.from(list);
    }
  }

  @computed
  int get start => carsSorts.isEmpty ? 0 : ((page - 1) * limit) + 1;

  @computed
  int get end => carsSorts.isEmpty ? 0 : start + carsSorts.length - 1;

  @computed
  int get lengthSortings {
    if (filter.isEmpty) return cars.length;

    return carsSorts.length;
  }

  @computed
  bool get btFinish => step == 2;

  Future<List<CarStatusModel>> getStatusCar({required String carID}) async {
    return repository.getStatusCar(carID: carID);
  }

  Stream<List<CarStatusModel>> listenStatusGeral({required DateTime date}) {
    return repository.listenStatusCarGeral(date: date);
  }

  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return repository.listenMapas(carId: carId);
  }

  Future<List<ChecklistModel>> getCheckListByMonth(
      {required DateTime date}) async {
    return await repository.getChecklistByMonth(reference: date);
  }

  @action
  void setLoading(bool value) => loading = value;

  @action
  void processStep(bool value) {
    if (value) {
      step++;
    } else {
      if (step > 0) step--;
    }
  }

  @action
  void setChecklistKMByMonth(List<ChecklistModel> value) {
    checklistKMByMonth
      ..clear()
      ..addAll(value);
  }

  @action
  void setStatusGeral(List<CarStatusModel> list) {
    list.sort((a, b) => b.date.compareTo(a.date));

    statusGeral
      ..clear()
      ..addAll(list);
  }

  @action
  void onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  void setCars(List<CarModel> values) {
    cars
      ..clear()
      ..addAll(values);
  }

  @action
  void setReferenceDateDashboard(DateTime? value) {
    if (value != null) {
      referenceDateDashboard = value;
    }
  }

  @action
  void setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  void setPage(int value) {
    page = value;
  }

  @action
  Future<void> setDateKmByMonth(DateTime value) async {
    if (value != dateKmByMonth) {
      dateKmByMonth = value;
    }
  }

  @action
  Future<bool> save({
    required CarModel car,
    required List<FileModel?> images,
    required List<OtherChangeModel> others,
    required List<FileModel> deletedFiles,
  }) async {
    try {
      loading = true;

      for (final image in images) {
        if (image == null) {
          throw Exception('Insira as imagens das vistas antes de continuar.');
        }
      }

      final result = await repository.save(
        car: car,
        images: images,
        others: others,
        deletedFiles: deletedFiles,
      );

      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> delete({required CarModel car}) async {
    try {
      loading = true;
      final result = await repository.delete(car: car);
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  // @action
  // Future<bool> copy({required CarModel car}) async {
  //   try {
  //     loading = true;
  //     final result = await repository.copy(
  //         car: car.copyWith(
  //             prefix: '${car.prefix} COPIA',
  //             km: 0,
  //             arref: 0,
  //             oil: 0,
  //             state: StatusCar.waiting,
  //             status: [],
  //             changes: [],
  //             mapas: []));

  //     loading = false;

  //     return result;
  //   } catch (e) {
  //     loading = false;
  //     rethrow;
  //   }
  // }

  @action
  Future<bool> updateKMOil({
    required String id,
    required int value,
  }) async {
    loading = true;
    final result = await repository.updateKMCar(id: id, data: {'oil': value});
    loading = false;

    return result;
  }

  @action
  Future<bool> updateKMArref({
    required String id,
    required int value,
  }) async {
    loading = true;
    final result = await repository.updateKMCar(id: id, data: {'arref': value});
    loading = false;

    return result;
  }

  @action
  Future<bool> saveStatus({
    required CarModel car,
    required CarStatusModel status,
  }) async {
    loading = true;
    final result = await repository.saveStatusCar(car: car, status: status);
    loading = false;

    return result;
  }

  @action
  Future<bool> deleteStatus({
    required CarModel car,
    required CarStatusModel status,
  }) async {
    loading = true;
    final result = await repository.deleteStatusCar(car: car, status: status);
    loading = false;

    return result;
  }

  @action
  Future<bool> insertMapa({required CarMapaModel mapa}) async {
    loading = true;
    final result = await repository.insertMapaCar(mapa: mapa);
    loading = false;

    return result;
  }

  @action
  Future<bool> deleteMapa({required String id}) async {
    loading = true;
    final result = await repository.deleteCarMapa(id: id);

    loading = false;
    return result;
  }
}
