import 'dart:developer';

import 'package:bsu_control/app_interface.dart';
import 'package:bsu_control/app_repository.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/app_model.dart';
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

  AppModel appModel = AppModel(carsTypes: []);

  @observable
  int version = 1;

  @observable
  double width = 0.0;

  @observable
  int router = 0;

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  UserModel user = UserModel();

  @observable
  bool menuOpen = false;

  @observable
  bool loading = false;

  @observable
  bool loadingCheklist = false;

  @observable
  bool checklistVeicular = false;

  @observable
  bool modeMOBILE = false;

  @observable
  DateTime dateReferenceStart =
      DateTime.now().subtract(const Duration(days: 1));

  @observable
  DateTime dateReferenceFinish = DateTime.now();

  @observable
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<CheckListModel> checklistsPeriod = <CheckListModel>[].asObservable();

  @observable
  List<CheckListModel> checklistsToday = <CheckListModel>[].asObservable();

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
  CheckListModel? get checklistUser {
    if (checklistsToday.isEmpty) return null;

    final list = checklistsToday.where((e) => e.userID == user.id).toList();

    if (list.isEmpty) return null;

    list.sort((a, b) => a.date.compareTo(b.date));

    return list.last;
  }

  @computed
  int get checklistTodayPendent {
    if (checklistsToday.isEmpty) return 0;

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
  List<CheckListModel> get checklistPeriodSort {
    final list =
        Core.paginate(list: checklistsPeriod, page: page, limit: limit);
    return List<CheckListModel>.from(list);
  }

  @computed
  List<CarModel> get carsADM => cars.where((e) => e.adm).toList();

  @computed
  List<CarModel> get carsOPR => cars.where((e) => !e.adm).toList();

  @computed
  List<String> get prefixs => cars.map((e) => e.prefix).toList();

  @computed
  List<CarModel> get carsUsers {
    if (user.adminFull) {
      return List<CarModel>.from(cars);
    } else if (user.admin) {
      return List<CarModel>.from(
          cars.where((e) => e.obmID == user.obmID).toList());
    } else {
      return List<CarModel>.from(cars
          .where((e) => e.cia.toLowerCase() == user.cia.toLowerCase())
          .toList());
    }
  }

  List<CheckListModel> getChecklistUser({required List<CheckListModel> list}) {
    if (user.adminFull) {
      return List<CheckListModel>.from(list);
    } else if (user.admin) {
      return List<CheckListModel>.from(
          list.where((e) => e.obmID == user.obmID).toList());
    } else {
      return List<CheckListModel>.from(list
          .where((e) => e.cia.toLowerCase() == user.cia.toLowerCase())
          .toList());
    }
  }

  @action
  setUser(UserModel value) => user = value;

  @action
  setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    dateReferenceStart = dateStart;
    dateReferenceFinish = dateFinish;
  }

  @action
  changeMenuOpen() => menuOpen = !menuOpen;

  @action
  setRouter(int value) {
    router = value;
    menuOpen = false;
  }

  @action
  setCheckListVeicular(bool value) => checklistVeicular = value;

  Stream<List<CheckListModel>> listenChecklistToday() {
    final dateReference = Core.getOperationalDay(DateTime.now());

    log('Data Operacional: ${Core.formatDate(dateReference)}');
    return repository.listenChecklistToday(referenceDate: dateReference);
  }

  @observable
  Stream<List<CheckListModel>> listenChecklistPeriod(
      {required DateTime dateStart, required DateTime dateFinish}) {
    loadingCheklist = true;

    log('Date Start: ${Core.formatDate(dateStart)}');
    log('Date Finish: ${Core.formatDate(dateFinish)}');

    final stream = repository.listenChecklistPeriod(
      referenceDateStart: dateStart,
      referenceDateFinish: dateFinish,
    );

    loadingCheklist = false;

    return stream;
  }

  @action
  setCars(List<CarModel> value) {
    cars
      ..clear()
      ..addAll(value);
  }

  @action
  setLimit(int? value) {
    limit = value ?? limit;
  }

  @action
  setPage(int value) {
    page = value;
  }

  @action
  setUsers(List<UserModel> value) {
    users
      ..clear()
      ..addAll(value);

    users.sort((a, b) => a.name.compareTo(b.name));
  }

  @action
  setChecklistPeriod(List<CheckListModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    checklistsPeriod
      ..clear()
      ..addAll(value);
  }

  @action
  setChecklistToday(List<CheckListModel> value) {
    value.sort((a, b) => a.date.compareTo(b.date));
    checklistsToday
      ..clear()
      ..addAll(getChecklistUser(list: value));
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

  @action
  Future<void> initApplication() async {
    final result = await repository.getAppModel();
    version = result.version;
  }
}
