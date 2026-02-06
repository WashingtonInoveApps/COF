import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/app_repository.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import 'model/check_list_model.dart';
import 'model/supply_model.dart';

part 'app_controller.g.dart';

// ignore: library_private_types_in_public_api
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  final String appID;
  final bool test;
  final String endpoint;
  final double maxWidth;

  late IAppRepository repository;

  _AppControllerBase(
      {required this.appID,
      required this.endpoint,
      required this.test,
      required this.maxWidth}) {
    repository = AppRepository(
      appID: appID,
      endpoint: endpoint,
      test: test,
    );

    getUserDB(tag: 'user');
  }

  @observable
  String version = '';

  @observable
  double width = 0.0;

  @observable
  int router = 0;

  @observable
  UserModel user = UserModel();

  @observable
  bool menuOpen = false;

  @observable
  bool loading = false;

  @observable
  bool checklistVeicular = false;

  @observable
  bool modeMOBILE = false;

  @observable
  DateTime date = DateTime.now();

  @observable
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<CheckListModel> checkLists = <CheckListModel>[].asObservable();

  @observable
  List<UserModel> users = <UserModel>[].asObservable();

  List<OBMModel> obms = <OBMModel>[];

  // @computed
  // List<UserModel> get usersValidations => users;

  Stream<List<CheckListModel>> get listenChecklist => repository
      .listenChecklist(referenceDate: Core.formatDate(date, largeDay: true));

  Stream<List<CarModel>> get listenCar => repository.listenCar();

  Stream<List<UserModel>> get listenUsers => repository.listenUsers();

  @computed
  List<CarModel> get carsADM => cars.where((e) => e.adm).toList();

  @computed
  List<CarModel> get carsOPR => cars.where((e) => !e.adm).toList();

  @computed
  List<String> get prefixs => cars.map((e) => e.prefix).toList();

  @action
  setVersion(String value) => version = value;

  @action
  setUser(UserModel value) => user = value;

  @action
  changeMenuOpen() => menuOpen = !menuOpen;

  @action
  setReferenceDate(DateTime value) => date = value;

  @action
  setRouter(int value) {
    router = value;
    menuOpen = false;
  }

  @action
  setCheckListVeicular(bool value) => checklistVeicular = value;

  @action
  setCars(List<CarModel> value) {
    cars
      ..clear()
      ..addAll(value);
  }

  @action
  setUsers(List<UserModel> value) {
    users
      ..clear()
      ..addAll(value);

    users.sort((a, b) => a.name.compareTo(b.name));
  }

  @action
  setCheckList(List<CheckListModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    checkLists
      ..clear()
      ..addAll(value);
  }

  @action
  Future<bool> saveSupplies(
      {required SupplyModel supply, required CheckListModel checklist}) async {
    loading = true;
    final result =
        await repository.saveSupplies(supply: supply, checklist: checklist);
    loading = false;

    return result;
  }

  @action
  Future<void> getOBMs() async {
    loading = true;
    final result = await repository.getOBMs();

    result.sort((a, b) => a.prefix.compareTo(b.prefix));

    for (final obm in result) {
      if (obm.cias.isNotEmpty) obm.cias.sort((a, b) => a.compareTo(b));
      if (obm.team.isNotEmpty) obm.team.sort((a, b) => a.compareTo(b));
    }

    obms
      ..clear()
      ..addAll(result);

    loading = false;

    return;
  }

  Future<bool> getUserDB({required String tag}) async {
    final result = await DBController.get(tag: tag);
    if (result != null) user = UserModel.fromMap(result);

    return result != null;
  }

  @action
  Future<bool> deleteChecklist({required CheckListModel checkList}) async {
    try {
      loading = true;

      final car = CarModel.copy(
          cars.firstWhere((e) => e.id == checkList.checkCar.car.id));
      final changes =
          car.changes.where((e) => e.checklistID != checkList.id).toList();

      final result = await repository.deleteChecklist(
          checklist: checkList, car: car.copyWith(changes: changes));
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      return false;
    }
  }

  @action
  Future<bool> deleteSupply(
      {required SupplyModel supply, required CheckListModel checklist}) async {
    loading = true;
    final result =
        await repository.deleteSupply(supply: supply, checklist: checklist);
    loading = false;
    return result;
  }

  @action
  double processWidth(
      {required double constrainedMaxWidth, required bool childRight}) {
    bool modeMOBILE = (constrainedMaxWidth > maxWidth)
        ? (maxWidth <= 500)
        : (constrainedMaxWidth <= 500);

    double width = (modeMOBILE || childRight)
        ? ((constrainedMaxWidth > maxWidth) ? maxWidth : constrainedMaxWidth)
        : maxWidth * 0.48;

    this.modeMOBILE = modeMOBILE;
    this.width = width;

    return width;
  }
}
