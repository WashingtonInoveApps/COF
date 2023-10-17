import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final List<CarModel> cars;
  final UserModel user;
  final ICheckListRepository repository;
  final AppController app;

  @observable
  late CheckListModel checklist;

  @observable
  bool loading = false;

  _CheckListControllerBase(
      {required this.checklist,
      required this.cars,
      required this.user,
      required this.app,
      required this.repository}) {
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
  String alfa = "";

  @observable
  double oil = 0.0;

  @observable
  double hidra = 0.0;

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
  setAlfa(String? value) {
    final result = value ?? alfas.first;
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
}
