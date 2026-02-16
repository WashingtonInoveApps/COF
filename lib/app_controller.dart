import 'dart:developer';

import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/app_repository.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/app_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import 'model/check_list_model.dart';

part 'app_controller.g.dart';

// ignore: library_private_types_in_public_api
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  final ConfigModel config;
  final double maxWidth;

  late IAppRepository repository;

  _AppControllerBase({required this.config, required this.maxWidth}) {
    repository = AppRepository(
      appID: config.appID,
      endpoint: config.endpoint,
      test: config.test,
    );

    processWidth(constrainedMaxWidth: double.infinity, childRight: false);
    getUserDB(tag: 'user');
  }

  AppModel appModel = AppModel(carsTypes: []);

  @observable
  int version = 1;

  @observable
  double width = 0.0;

  @observable
  int router = 0;

  @observable
  DateTime dateStartConfig = DateTime.now().subtract(const Duration(days: 1));

  @observable
  DateTime dateFinishConfig = DateTime.now();

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
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<ChecklistModel> checklistsToday = <ChecklistModel>[].asObservable();

  @observable
  List<UserModel> users = <UserModel>[].asObservable();

  List<OBMModel> obms = <OBMModel>[];

  Stream<List<CarModel>> get listenCar => repository.listenCar();

  Stream<List<UserModel>> get listenUsers => repository.listenUsers();

  @computed
  List<String> get carsTypes {
    if (cars.isEmpty) return ['Outros'];

    List<String> types = [];

    for (final car in cars) {
      if (!types.contains(car.type)) types.add(car.type);
    }

    types.sort((a, b) => a.compareTo(b));
    return types..add('Outros');
  }

  @computed
  bool get newRegister {
    if (checklistUser == null) return true;

    if (!(checklistUser?.enable ?? false)) return true;

    return false;
  }

  @computed
  ChecklistModel? get checklistUser {
    if (checklistsToday.isEmpty) return null;

    final list = checklistsToday.where((e) => e.userID == user.id).toList();

    if (list.isEmpty) return null;

    list.sort((a, b) => a.date.compareTo(b.date));

    return list.last;
  }

  @computed
  int get checklistTodayPendent {
    final carsOperating =
        cars.where((e) => e.state == StatusCar.operando).length;

    return (carsOperating - checklistsToday.length);
  }

  @computed
  int get checklistTodayChanges {
    if (checklistsToday.isEmpty) return 0;

    return checklistsToday
        .map((e) => e.changes.length)
        .reduce((value, next) => value + next);
  }

  @computed
  List<CarModel> get carsADM => cars.where((e) => e.adm).toList();

  @computed
  List<CarModel> get carsOPR => cars.where((e) => !e.adm).toList();

  @computed
  List<String> get prefixs => cars.map((e) => e.prefix).toList();

  @computed
  List<CarModel> get carsUsers {
    if (user.managerOperational || user.admin) {
      return List<CarModel>.from(cars);
    } else if (user.battalion) {
      return List<CarModel>.from(
          cars.where((e) => e.obmID == user.obmID).toList());
    } else {
      return List<CarModel>.from(cars
          .where((e) => e.cia.toLowerCase() == user.cia.toLowerCase())
          .toList());
    }
  }

  @action
  setDateStartConfig(DateTime? value) {
    dateStartConfig = value ?? dateStartConfig;
  }

  @action
  setDateFinishConfig(DateTime? value) {
    dateFinishConfig = value ?? dateFinishConfig;
  }

  @action
  void cleanExibitionConfig() {
    dateStartConfig = DateTime.now().subtract(const Duration(days: 1));
    dateFinishConfig = DateTime.now();
  }

  @action
  setUser(UserModel value) => user = value;

  @action
  changeMenuOpen() => menuOpen = !menuOpen;

  @action
  setRouter(int value) {
    router = value;
    menuOpen = false;
  }

  @action
  setCheckListVeicular(bool value) => checklistVeicular = value;

  Stream<List<ChecklistModel>> listenChecklistToday() {
    final dateReference = Core.getOperationalDay(DateTime.now());

    log('Data Operacional: ${Core.formatDate(dateReference)}');
    return repository.listenChecklistToday(referenceDate: dateReference);
  }

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
  setChecklistToday(List<ChecklistModel> value) {
    value.sort((a, b) => a.date.compareTo(b.date));
    checklistsToday
      ..clear()
      ..addAll(value);
  }

  Future<void> getOBMs() async {
    final result = await repository.getOBMs();

    result.sort((a, b) => a.prefix.compareTo(b.prefix));

    for (final obm in result) {
      if (obm.cias.isNotEmpty) obm.cias.sort((a, b) => a.compareTo(b));
      if (obm.team.isNotEmpty) obm.team.sort((a, b) => a.compareTo(b));
    }

    obms
      ..clear()
      ..addAll(result);

    return;
  }

  Future<bool> getUserDB({required String tag}) async {
    final result = await DBController.get(tag: tag);
    if (result != null) user = UserModel.fromMap(result);

    return result != null;
  }

  @action
  double processWidth(
      {required double constrainedMaxWidth, required bool childRight}) {
    bool modeMOBILE = (constrainedMaxWidth > maxWidth)
        ? (maxWidth <= 500)
        : (constrainedMaxWidth <= 500);

    double width = (modeMOBILE || childRight)
        ? ((constrainedMaxWidth > maxWidth) ? maxWidth : constrainedMaxWidth)
        : maxWidth * 0.47;

    this.modeMOBILE = modeMOBILE;
    this.width = width;

    log('Modo MOBILE: $modeMOBILE');
    log('Width: $width , Max Width: $maxWidth');

    return width;
  }

  @action
  Future<void> initApplication() async {
    final result = await repository.getAppModel();
    await getOBMs();

    log('OBMs: ${obms.length}');

    version = result.version;
  }
}
