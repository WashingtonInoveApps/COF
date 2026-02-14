import 'dart:developer';
import 'dart:typed_data';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/src/checklist/repository/checklist_repository.dart';
import 'package:mobx/mobx.dart';

import '../../../model/supply_model.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final AppController app;
  final CheckListModel? init;
  final bool update;

  late ICheckListRepository repository;

  List<String> messagesErros = [];

  @observable
  bool loading = false;

  _CheckListControllerBase(
      {required this.init, required this.app, required this.update}) {
    repository = CheckListRepository(
        endpoint: app.endpoint, appID: app.appID, test: app.test);
    initController(init);
  }

  Stream<CheckListModel> streamChecklistByID({required String checklistID}) {
    return repository.streamChecklistByID(checklistID: checklistID);
  }

  @action
  initController(CheckListModel? init) {
    itens.clear();
    materials.clear();

    id = init?.id;
    prefix = init?.prefix ?? 'SELECIONE';
    oil = init?.checkCar.oil ?? 0.0;
    hidra = init?.checkCar.hidra ?? 0.0;
    fr = init?.checkCar.fr ?? 0.0;
    arref = init?.checkCar.arref ?? 0.0;
    fuel = init?.checkCar.fuel ?? 0.0;
    team = init?.team ?? team;
    startKM = init?.startKM ?? '';
    endKM = init?.endKM ?? '';
    contact = init?.contact ?? '';
    date = init?.date ?? date;
    obs = init?.obs ?? '';
    enable = init?.enable ?? true;
    states = init?.states ??
        [StatesChecklist(state: StateChecklist.inprogress, date: date)];
    supplies = init?.supply ?? [];

    if (init != null) {
      car = app.cars.firstWhere((e) => e.id == init.checkCar.car.id);

      itens.addAll(List<ItensChangesModel>.from(init.checkCar.car.itens));
      materials
          .addAll(List<ItensChangesModel>.from(init.checkCar.car.materials));

      outhers
        ..clear()
        ..addAll(init.outhers ?? []);
    } else {
      itens.addAll(List<ItensChangesModel>.from(car?.itens ?? []));
      materials.addAll(List<ItensChangesModel>.from(car?.materials ?? []));
    }

    carChanges.addAll(car?.changes ?? []);
  }

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> itens =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<CheckListModel> myChecklistUser =
      <CheckListModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> materials =
      <ItensChangesModel>[].asObservable();

  @observable
  ObservableList<ChecklistOutherChange> outhers =
      <ChecklistOutherChange>[].asObservable();

  @observable
  ObservableList<String> teams = <String>[].asObservable();

  @observable
  ObservableList<ItemModel> materialsConsumed = <ItemModel>[].asObservable();

  List<StatesChecklist> states = [];

  List<SupplyModel> supplies = [];

  @observable
  DateTime date = DateTime.now();

  @observable
  DateTime dateReferenceStart = DateTime.now();

  @observable
  DateTime dateReferenceFinish = DateTime.now();

  @observable
  DateTime dateStartConfig = DateTime.now().subtract(const Duration(days: 1));

  @observable
  DateTime dateFinishConfig = DateTime.now();

  @observable
  DateTime dateMyChecklist = DateTime.now();

  @observable
  String prefix = "SELECIONE";

  @observable
  bool enable = true;

  String? id;

  @observable
  int step = 0;

  @observable
  String contact = "";

  @observable
  String? cia;

  @observable
  String team = "";

  @observable
  String pb = "";

  @observable
  String obs = "";

  @observable
  String startKM = "";

  @observable
  String endKM = "";

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  double oil = 0.0;

  @observable
  double hidra = 0.0;

  @observable
  double fuel = 0.0;

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  double fr = 0.0;

  @observable
  double arref = 0.0;

  @observable
  CarModel? car;

  @computed
  bool get btFinish {
    final materialsEmpty = car?.materials.isEmpty ?? true;

    if (materialsEmpty && step == 2) {
      return true;
    } else if (step == 3) {
      return true;
    }

    return false;
  }

  @computed
  List<CarModel> get cars {
    return app.cars
        .where((e) => (cia != null)
            ? (e.cia.toLowerCase() == cia?.toLowerCase())
            : (e.obmID.toLowerCase() == obm.id?.toLowerCase()))
        .toList();
  }

  Stream<List<CheckListModel>> streamChecklistPeriod(
      {required String userID,
      required DateTime referenceDateStart,
      required DateTime referenceDateFinish}) {
    return repository.streamChecklistPeriod(
        referenceDateStart: referenceDateStart,
        referenceDateFinish: referenceDateFinish);
  }

  Stream<List<CheckListModel>> streamChecklistUser({required String userID}) {
    return repository.streamChecklistUser(userID: userID);
  }

  @computed
  List<CheckListModel> get myChecklistUserSort {
    if (filter.isNotEmpty) {
      final filtered = myChecklistUser
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  e.obm.toLowerCase().contains(filter.toLowerCase()) ||
                  (e.cia.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.team.toLowerCase().contains(filter.toLowerCase())) ||
                  (e.state.label.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<CheckListModel>.from(list);
    } else {
      final list =
          Core.paginate(list: myChecklistUser, page: page, limit: limit);
      return List<CheckListModel>.from(list);
    }
  }

  @action
  changeDate(DateTime? value) => date = value ?? date;

  @action
  setDateMyChecklist(DateTime? value) =>
      dateMyChecklist = value ?? dateMyChecklist;

  @action
  setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    dateReferenceStart = dateStart;
    dateReferenceFinish = dateFinish;
  }

  @action
  void cleanExibitionConfig() {
    dateStartConfig = DateTime.now().subtract(const Duration(days: 1));
    dateFinishConfig = DateTime.now();
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
  setMyChecklistUser(List<CheckListModel> value) {
    value.sort((a, b) => b.date.compareTo(a.date));
    myChecklistUser
      ..clear()
      ..addAll(value);
  }

  @action
  onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
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
  addOuthersChange(ChecklistOutherChange value) {
    outhers.add(value);
  }

  @action
  deleteOuhtersChange(int index) {
    outhers.removeAt(index);
  }

  @action
  addMaterialsConsumed(List<ItemModel> values) {
    materialsConsumed
      ..clear()
      ..addAll(values);
  }

  @action
  deleteMaterialsConsumed(int index) {
    materialsConsumed.removeAt(index);
  }

  @action
  setPrefix(String? value) {
    if (value != null && value != "SELECIONE") {
      car = CarModel.copy(cars.firstWhere((c) => c.prefix == value));
      prefix = value;

      carChanges
        ..clear()
        ..addAll(car?.changes ?? []);

      itens
        ..clear()
        ..addAll(processItens(car?.itens ?? []));

      materials
        ..clear()
        ..addAll(processItens(car?.materials ?? []));

      for (final category in itens) {
        for (final item in category.itens) {
          item.quantity = 0;
        }
      }

      for (final category in materials) {
        for (final item in category.itens) {
          item.quantity = 0;
        }
      }
    }
  }

  List<String> teamsValidade({required List<String> teams}) {
    if (obm.team.isEmpty) return [];

    final list = app.checklistsToday.map((e) => e.team).toList();

    List<String> result = obm.team.where((e) => !list.contains(e)).toList();

    if (update) result.insert(0, init!.team);

    return result;
  }

  @computed
  List<String> get prefixs {
    List<String> data = ['SELECIONE'];

    if (cars.isNotEmpty) {
      final list = app.checklistsToday.map((e) => e.prefix).toList();

      final result = cars
          .where((e) => !list.contains(e.prefix))
          .map((e) => e.prefix)
          .toList();

      data.addAll(result);

      if (update) data.add(init!.prefix);
    }

    return data;
  }

  List<ItensChangesModel> processItens(List<ItensChangesModel> value) {
    List<ItensChangesModel> list = [];
    List<ItemModel> itens = [];

    for (final item in value) {
      list.add(ItensChangesModel.fromMap(item.toMap()));
    }

    for (final category in list) {
      for (final item in category.itens) {
        itens.add(item.copyWith(quantity: 0));
      }
    }

    return list;
  }

  @action
  setOBM(OBMModel? value) {
    if (value != null) {
      if (obm != value) {
        teams.clear();

        obm = value;

        teams.addAll(teamsValidade(teams: obm.team));

        if (teams.isNotEmpty && team.isEmpty) team = teams.last;

        if (obm.cias.isNotEmpty) {
          cia = obm.cias.first;
        } else {
          cia = null;
        }
      }
    }
  }

  @action
  processStep(bool value) {
    if (value) {
      step++;
    } else {
      if (step > 0) step--;
    }
  }

  @action
  setCia(String? value) => cia = value;

  @action
  setTeam(String? value) => team = value ?? team;

  @action
  setContact(String? value) => contact = value ?? '';

  @action
  setPB(String? value) => pb = value ?? pb;

  @action
  setKMStart(String? value) => startKM = value ?? startKM;

  @action
  setOBS(String? value) => obs = value ?? obs;

  @action
  setOil(double? value) => oil = value ?? oil;

  @action
  setHidra(double? value) => hidra = value ?? hidra;

  @action
  setFuel(double? value) => fuel = value ?? fuel;

  @action
  setFR(double? value) => fr = value ?? fr;

  @action
  setArref(double? value) => arref = value ?? arref;

  @action
  addCarChanges(List<CarChangeModel> value) {
    carChanges
      ..clear()
      ..addAll(value);

    car = car?.copyWith(changes: carChanges);
  }

  @action
  removeCarChanges(int index) {
    carChanges.removeAt(index);
  }

  @action
  changeItens(ItemModel value, int indexCategory, int indexItem) {
    final category =
        ItensChangesModel.fromMap(itens.elementAt(indexCategory).toMap());

    List<ItemModel> list = List.from(category.itens);

    list.removeAt(indexItem);
    list.insert(indexItem, value);

    itens.removeAt(indexCategory);
    itens.insert(indexCategory, category.copyWith(itens: list));
  }

  @action
  changeOBSItens(String obs, int indexCategory) {
    final category =
        ItensChangesModel.fromMap(itens.elementAt(indexCategory).toMap());

    itens.removeAt(indexCategory);
    itens.insert(indexCategory, category.copyWith(obs: obs));

    log('OBS Itens: ${itens[indexCategory].obs}');
  }

  @action
  changeMaterials(ItemModel value, int indexCategory, int indexItem) {
    final category =
        ItensChangesModel.fromMap(materials.elementAt(indexCategory).toMap());

    List<ItemModel> list = List.from(category.itens);

    list.removeAt(indexItem);
    list.insert(indexItem, value);

    materials.removeAt(indexCategory);
    materials.insert(indexCategory, category.copyWith(itens: list));
  }

  @action
  changeOBSMaterials(String obs, int indexCategory) {
    final category =
        ItensChangesModel.fromMap(materials.elementAt(indexCategory).toMap());

    materials.removeAt(indexCategory);
    materials.insert(indexCategory, category.copyWith(obs: obs));
  }

  @action
  setLoading(bool value) => loading = value;

  @action
  Future<bool> save() async {
    try {
      loading = true;

      final checklist = CheckListModel(
          id: id,
          date: date,
          user: app.user,
          userID: app.user.id ?? '',
          checkCar: CarCheckList(
            car: car!.copyWith(itens: itens, materials: materials),
            arref: arref,
            fr: fr,
            fuel: fuel,
            hidra: hidra,
            oil: oil,
            obs: obs,
          ),
          enable: enable,
          startKM: startKM,
          endKM: endKM,
          prefix: prefix,
          obs: obs,
          team: team,
          state: StateChecklist.inprogress,
          obmID: obm.id ?? '',
          obm: obm.prefix,
          cia: cia?.toLowerCase() ?? '',
          contact: contact,
          changes: [],
          states: states,
          supply: supplies);

      final result = await repository.save(
        checklist: checklist,
        changes: carChanges,
        outhers: outhers,
      );

      loading = false;
      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> finish(
      {required CheckListModel checklist, Uint8List? image}) async {
    try {
      final now = DateTime.now();
      final states = List<StatesChecklist>.from(checklist.states);

      final state = StatesChecklist(state: StateChecklist.completed, date: now);
      states.add(state);

      final result = await repository.finish(
          checklist: checklist.copyWith(
              state: state.state,
              materials: materialsConsumed,
              states: states,
              dateFinish: now,
              enable: false),
          image: image);

      loading = false;
      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> deleteChecklist({required CheckListModel checklist}) async {
    try {
      loading = true;
      final car = app.cars.firstWhere((e) => e.id == checklist.checkCar.car.id);

      final changes = List<CarChangeModel>.from(car.changes);

      for (final change in checklist.changes) {
        changes.removeWhere(
            (e) => (e.checklistID != null) && (e.checklistID == checklist.id));
      }

      final result = await repository.deleteChecklist(
          checklist: checklist, car: car.copyWith(changes: changes));

      loading = false;
      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  bool validationForm() {
    messagesErros.clear();
    switch (step) {
      case 0:
        if (cars.isEmpty) {
          messagesErros.add('Nenhum registro de veículos encontrado.');
        }

        if (Validation.validatorPhone(contact) != null) {
          messagesErros.add("Insira um contato antes de prosseguir.");
        }

        if (obm.team.isNotEmpty && team == "SELECIONE") {
          messagesErros.add("Escolha a guarnição antes de prosseguir.");
        }

        return messagesErros.isEmpty;
      case 1:
        if (prefix == "SELECIONE") {
          messagesErros
              .add("Escolha o prefixo do veiculo antes de prosseguir.");
        }
        if (startKM.isEmpty) {
          messagesErros.add("Insira o KM inicial antes de prosseguir.");
        }
        if (oil == 0.0 || fr == 0.0 || hidra == 0.0 || arref == 0.0) {
          messagesErros
              .add("Verifique os níveis dos fluídos antes de prosseguir.");
        }

        return messagesErros.isEmpty;
      case 2:
        return true;
      default:
        return false;
    }
  }
}
