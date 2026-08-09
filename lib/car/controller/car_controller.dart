import 'package:bsu_control/car/repository/car_interface.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../model/car_mapa_model.dart';
import '../../model/car_model.dart';
import '../../model/car_status_model.dart';
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
  String type = '';

  @observable
  DateTime dateKmByMonth = DateTime.now();

  @observable
  String function = '';

  @observable
  bool fieldCarTypeVisible = false;

  @observable
  String? cia;

  @observable
  String filter = '';

  @observable
  DateTime referenceYearProblem = DateTime.now();

  @observable
  DateTime referenceYearTendencies = DateTime.now();

  @observable
  ObservableList<CarModel> cars = <CarModel>[].asObservable();

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  ObservableList<CarStatusModel> statusGeral =
      <CarStatusModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> sectionsItens =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> sectionsMaterials =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> sectionsMaterialsConsumable =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  bool get enable => (user.managerFleet || user.admin);

  @computed
  List<CarModel> get carsSorts {
    if (filter.isNotEmpty) {
      final filtered = cars
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  (e.cia.toLowerCase().contains(filter.toLowerCase())) ||
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
  bool get adm => function == Constants.carsFunctions.first;

  @computed
  int get start => carsSorts.isEmpty ? 0 : ((page - 1) * limit) + 1;

  @computed
  int get end => carsSorts.isEmpty ? 0 : start + carsSorts.length - 1;

  Stream<List<CarStatusModel>> listenStatus({required String carId}) {
    return repository.listenStatusCar(carId: carId);
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
  setStatusGeral(List<CarStatusModel> list) {
    list.sort((a, b) => a.date.compareTo(b.date));

    statusGeral
      ..clear()
      ..addAll(list);
  }

  @action
  onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  setTypeCar(String? value) {
    type = value ?? type;

    if (type == "Outros") {
      fieldCarTypeVisible = true;
    } else {
      fieldCarTypeVisible = false;
    }
  }

  @action
  setCars(List<CarModel> values) {
    cars
      ..clear()
      ..addAll(values);
  }

  @action
  setReferenceYearProblem(DateTime? value) {
    if (value != null) {
      referenceYearProblem = value;
    }
  }

  @action
  setReferenceYearTendencies(DateTime? value) {
    if (value != null) {
      referenceYearTendencies = value;
    }
  }

  @action
  setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  setPage(int value) {
    page = value;
  }

  @action
  setFunctionCar(String? value) {
    function = value ?? function;
  }

  @action
  setOBM(OBMModel? value) {
    if (value != null) {
      if (obm != value) {
        obm = value;

        if (obm.cias.isNotEmpty) {
          cia = obm.cias.first;
        } else {
          cia = null;
        }
      }
    }
  }

  @action
  Future<void> setDateKmByMonth(DateTime value) async {
    if (value != dateKmByMonth) {
      dateKmByMonth = value;
    }
  }

  @action
  setCia(String? value) => cia = value;

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
  addSections(
      {required List<ItensChangesModel> list,
      required ItensChangesModel value}) {
    list.add(value);
  }

  @action
  removeSections({required List<ItensChangesModel> list, required int index}) {
    list.removeAt(index);
  }

  @action
  addItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required ItemModel value,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.add(value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  editItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
    required ItemModel value,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);
    itens.insert(indexItem, value);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  moveItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
    required bool position,
  }) {
    int pos = 0;
    final section = ItensChangesModel.fromMap(list[index].toMap());
    final itens = List<ItemModel>.from(section.itens);

    if (position) {
      pos = indexItem - 1;
    } else {
      pos = indexItem + 1;
    }

    if (pos == -1 || pos > (itens.length - 1)) return;

    final item = ItemModel.fromMap(itens[indexItem].toMap());

    itens.removeAt(indexItem);
    itens.insert(pos, item);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  removeItensSection({
    required List<ItensChangesModel> list,
    required int index,
    required int indexItem,
  }) {
    final section = ItensChangesModel.fromMap(list[index].toMap());

    final itens = List<ItemModel>.from(section.itens);
    itens.removeAt(indexItem);

    list.removeAt(index);
    list.insert(index, section.copyWith(itens: itens));
  }

  @action
  editSections(
      {required List<ItensChangesModel> list,
      required int index,
      required ItensChangesModel value}) {
    final section = list[index].copyWith(description: value.description);

    list.removeAt(index);
    list.insert(index, section);
  }

  @action
  cleanSections({required List<ItensChangesModel> list}) {
    list.clear();
  }

  @action
  expansionSections(
      {required List<ItensChangesModel> list, required int index}) {
    final section = list[index].copyWith(value: !list[index].value);
    list.removeAt(index);
    list.insert(index, section);
  }

  @action
  Future<bool> save(
      {required CarModel car, required List<dynamic> images}) async {
    try {
      loading = true;

      for (final image in images) {
        if (image == null) {
          throw Exception('Insira as imagens das vistas antes de continuar.');
        }
      }

      if (car.type.isEmpty && type == 'Outros') {
        throw Exception('Insira o tipo de veículo antes de continuar.');
      }

      final result = await repository.save(
          car: car.copyWith(
            function: function,
            adm: adm,
            changes: carChanges,
            obmID: obm.id ?? '',
            cia: (cia?.toLowerCase()) ?? (obm.id ?? ''),
            itens: sectionsItens,
            materials: sectionsMaterials,
            materialsConsumable: sectionsMaterialsConsumable,
          ),
          images: images);
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> copy({required CarModel car}) async {
    try {
      loading = true;
      final result = await repository.copy(
          car: car.copyWith(
              prefix: '${car.prefix} COPIA',
              km: 0,
              arref: 0,
              oil: 0,
              state: StatusCar.waiting,
              status: [],
              changes: [],
              mapas: []));

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
  Future<bool> saveStatusCar(
      {required CarModel car, CarStatusModel? status}) async {
    loading = true;
    final result = await repository.saveStatusCar(car: car, status: status);
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
    try {
      loading = true;
      final result = await repository.deleteCar(id: id);

      loading = false;
      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
