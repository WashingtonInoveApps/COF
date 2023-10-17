import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:mobx/mobx.dart';

import 'model/check_list_model.dart';
import 'model/supply_model.dart';

part 'app_controller.g.dart';

// ignore: library_private_types_in_public_api
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  final IAppRepository repository;

  _AppControllerBase({required this.repository}) {
    // PackageInfo.fromPlatform().then((value) => setVersion(value.version));
    getUserDB(tag: 'user');
  }

  @observable
  String version = '';

  @observable
  UserModel user = UserModel();

  @observable
  String unidade = unidades.first;

  @observable
  bool isLogged = false;

  @observable
  bool loading = false;

  @observable
  bool checklistVeicular = false;

  @observable
  DateTime date = DateTime.now();

  @observable
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<CheckListModel> checkLists = <CheckListModel>[].asObservable();

  @observable
  List<UserModel> users = <UserModel>[].asObservable();

  @computed
  List<UserModel> get usersValidations => users.where((e) => e.samu).toList();

  Stream<List<CheckListModel>> get listenChecklist =>
      repository.listenChecklist(referenceDate: formatDate(date, outher: true));

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
  setReferenceDate(DateTime value) => date = value;

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
  Future<bool> login({required String email, required String senha}) async {
    loading = true;
    final result = await repository.login(email: email, senha: senha);
    loading = false;

    if (result == null) return false;

    user = result;
    await DBController.save(tag: 'user', value: result.toJson());

    isLogged = true;
    return true;
  }

  Future<bool> getUserDB({required String tag}) async {
    final result = await DBController.get(tag: tag);
    if (result != null) user = UserModel.fromMap(result);

    return result != null;
  }

  @action
  Future<bool> recuperarPassword({required String email}) async {
    loading = true;
    final result = await repository.recuperarPassword(email: email);
    loading = false;

    return result;
  }

  @action
  Future<bool> deleteChecklist({required CheckListModel checkList}) async {
    try {
      loading = true;

      final car = CarModel.copy(
          cars.firstWhere((e) => e.id == checkList.checkCar.car.id));
      final changes =
          car.changes.where((e) => e.checklistId != checkList.id).toList();

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
}
