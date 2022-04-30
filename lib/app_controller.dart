import 'dart:convert';

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/app_interface.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/car_mapa_model.dart';
import 'model/check_list_model.dart';
import 'model/supply_model.dart';

part 'app_controller.g.dart';

class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  final IAppRepository repository;

  _AppControllerBase({required this.repository}){
    PackageInfo.fromPlatform().then((value) => setVersion(value.version));
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
  DateTime date = DateTime.now();

  @observable
  List<CarModel> cars = <CarModel>[].asObservable();

  @observable
  List<CheckListModel> checkLists = <CheckListModel>[].asObservable();

  @computed
  bool get enable => user.adm;

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
  setCars(List<CarModel> value) {
    cars
      ..clear()
      ..addAll(value);
  }

  @action
  setCheckList(List<CheckListModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    checkLists
      ..clear()
      ..addAll(value);
  }

  Stream<List<CarModel>> get listenCar => repository.listenCar();

  Stream<List<UserModel>> get listenUsers => repository.listenUsers();

  Stream<List<CheckListModel>> get listenCheckList => repository.listenCheckList(referenceDate: formatDate(date, referenceDate: true));

  Stream<List<CarMapaModel>> listenMapas({required String carId}) {
    return repository.listenMapas(carId: carId);
  }

  Stream<List<CarStatusModel>> listenStatus({required String carId}) {
    return repository.listenStatusCar(carId: carId);
  }

  @action
  Future<bool> saveCar({required CarModel car, String? id}) async {
    loading = true;
    final result = await repository.saveCar(car: car, unidade: unidade, id: id);
    loading = false;

    return result;
  }

  @action
  Future<bool> saveCheckList({required CheckListModel checkList, String? id}) async {
    loading = true;
    final result = await repository.saveCheckList(checkList: checkList, unidade: unidade, id: id);
    loading = false;

    return result;
  }

  @action
  Future<bool> saveSupplies({required SupplyModel supply, required CheckListModel checklist}) async {
    loading = true;
    final result = await repository.saveSupplies(supply: supply, checklist: checklist);
    loading = false;

    return result;
  }

  @action
  Future<bool> updateStatusCar({required CarStatusModel status, required String id, required bool enable}) async {
    loading = true;
    final result = await repository.updateStatusCar(status: status, id: id, enable: enable);
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
  Future<bool> insertMapaCar({required CarMapaModel mapa}) async {
    loading = true;
    final result = await repository.insertMapaCar(mapa: mapa);
    loading = false;

    return result;
  }

  @action
  Future<bool> finishCheckList({required String kmFinal, required CheckListModel checkList}) async {
    loading = true;
    final result = await repository.finishCheckList(kmFinal: kmFinal, checkList: checkList);
    loading = false;

    return result;
  }

  @action
  Future<bool> createUser({required UserModel user, required String password}) async {
    loading = true;
    final result = await repository.createUser(user: user, password: password);
    loading = false;

    return result;
  }

  @action
  Future<bool> stateUser({required UserModel user}) async {
    loading = true;
    final result = await repository.stateUser(user: user);
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
    isLogged = true;
    return true;
  }

  @action
  Future<bool> recuperarPassword({required String email}) async {
    loading = true;
    final result = await repository.recuperarPassword(email: email);
    loading = false;

    return result;
  }

  @action
  Future<bool> saveUserDBLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("user", jsonEncode(user.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> getUserDBLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final result = prefs.getString("user");

      if (result == null) return false;

      user = UserModel.fromMap(jsonDecode(result));

      return true;
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> deleteUserDBLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove("user");
    } catch (e) {
      return false;
    }
  }

  @action
  Future<bool> deleteCarMapa({required String id}) async {
    loading = true;
    final result = await repository.deleteCarMapa(id: id);

    loading = false;
    return result;
  }

  @action
  Future<bool> deleteSupply({required SupplyModel supply, required CheckListModel checklist}) async {
    loading = true;
    final result = await repository.deleteSupply(supply: supply, checklist: checklist);
    loading = false;
    return result;
  }
}
