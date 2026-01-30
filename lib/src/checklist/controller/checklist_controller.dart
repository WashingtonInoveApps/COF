import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/src/checklist/repository/checklist_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final List<CarModel> cars;
  final UserModel user;
  final AppController app;

  late ICheckListRepository repository;

  @observable
  late CheckListModel checklist;

  @observable
  bool loading = false;

  _CheckListControllerBase(
      {required this.checklist,
      required this.cars,
      required this.user,
      required this.app}) {
    repository = CheckListRepository(
        endpoint: app.endpoint, appID: app.appID, test: app.test);
    initController();
  }

  DateTime get date => checklist.date;
  String? get id => checklist.id;
  String? get obs => checklist.obs;

  @action
  initController() {
    final infors = checklist.checkCar;

    prefix = checklist.prefix;
    alfa = checklist.alfa;
    oil = infors.oil;
    hidra = infors.hidra;
    fr = infors.fr;
    arref = infors.arref;

    carChanges.addAll(infors.car.changes);
    itens.addAll(infors.car.itens.where((i) => i.itens.isNotEmpty).toList());
  }

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> itens =
      <ItensChangesModel>[].asObservable();

  @observable
  String prefix = "";

  @observable
  int step = 0;

  @observable
  String alfa = "";

  @observable
  String contact = "";

  @observable
  String? cia;

  @observable
  String? team;

  @observable
  double oil = 0.0;

  @observable
  double hidra = 0.0;

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  double fr = 0.0;

  @observable
  double arref = 0.0;

  @action
  setPrefix(String? value) {
    if (value != null) {
      final car = CarModel.copy(cars.firstWhere((c) => c.prefix == value));

      checklist.checkCar.car = car;
      checklist.prefix = car.prefix;
      prefix = value;

      carChanges
        ..clear()
        ..addAll(car.changes);
      debugPrint('Mudou');
    }
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

        if (obm.team.isNotEmpty) {
          team = obm.team.first;
        } else {
          team = null;
        }
      }
    }
  }

  @action
  setCia(String? value) => cia = value;

  @action
  setTeam(String? value) => team = value;

  @action
  setContact(String? value) => contact = value ?? '';

  @action
  setAlfa(String? value) {
    final result = value ?? Constants.alfas.first;
    checklist.alfa = result;
    alfa = result;
  }

  setPB(String? value) => checklist.pb = value ?? '';
  setKMStart(String? value) => checklist.kmStart = value ?? '';
  setOBS(String? value) => checklist.obs = value ?? '';

  @action
  setOil(dynamic value) {
    final result = (double.parse(value.toString()));
    checklist.checkCar.oil = result;
    oil = value;
  }

  @action
  setHidra(dynamic value) {
    final result = (double.parse(value.toString()));
    checklist.checkCar.hidra = result;
    hidra = value;
  }

  @action
  setFR(dynamic value) {
    final result = (double.parse(value.toString()));
    checklist.checkCar.fr = result;
    fr = value;
  }

  @action
  setArref(dynamic value) {
    final result = (double.parse(value.toString()));
    checklist.checkCar.arref = result;
    arref = value;
  }

  @action
  addCarChanges(CarChangeModel value) {
    checklist.checkCar.car.changes.add(value);
    carChanges.add(value);
  }

  @action
  removeCarChanges(int index) {
    checklist.checkCar.car.changes.removeAt(index);
    carChanges.removeAt(index);
  }

  @action
  statusExpanded(int index, bool value) {
    final result = itens.elementAt(index);

    result.value = value;

    itens
      ..removeAt(index)
      ..insert(index, result);

    checklist.checkCar.car.itens = itens;
  }

  @action
  selectValueItens(bool value, int index, int indexItem) {
    final item = itens.elementAt(index);
    final subItem = item.itens.elementAt(indexItem);

    subItem.value = value;
    itens
      ..removeAt(index)
      ..insert(index, item);

    checklist.checkCar.car.itens = itens;
  }

  @action
  Future<bool> save({required CheckListModel checkList, String? id}) async {
    loading = true;
    final result = await repository.save(
        checkList: checkList, unidade: app.unidade, id: id);
    loading = false;

    return result;
  }

  @action
  Future<bool> finish(
      {required String kmFinal, required CheckListModel checkList}) async {
    loading = true;
    final result =
        await repository.finish(kmFinal: kmFinal, checkList: checkList);
    loading = false;

    return result;
  }

  String? validationForm() {
    switch (step) {
      case 0:
        return Validation.validatorPhone(contact);
      default:
        return null;
    }
  }
}
