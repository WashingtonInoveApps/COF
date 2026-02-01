import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/src/checklist/repository/checklist_repository.dart';
import 'package:mobx/mobx.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final AppController app;
  final CheckListModel? init;

  late ICheckListRepository repository;

  List<String> messagesErros = [];

  @observable
  bool loading = false;

  _CheckListControllerBase({required this.init, required this.app}) {
    repository = CheckListRepository(
        endpoint: app.endpoint, appID: app.appID, test: app.test);
    initController(init);
  }

  @action
  initController(CheckListModel? init) {
    id = init?.id;
    prefix = init?.prefix ?? 'SELECIONE';
    oil = init?.checkCar.oil ?? 0.0;
    hidra = init?.checkCar.hidra ?? 0.0;
    fr = init?.checkCar.fr ?? 0.0;
    arref = init?.checkCar.arref ?? 0.0;
    fuel = init?.checkCar.fuel ?? 0.0;
    team = init?.team ?? team;
    startKM = init?.startKM ?? '';

    if (init != null) {
      car = app.cars.firstWhere((e) => e.id == init.checkCar.car.id);
    }

    carChanges.addAll(car?.changes ?? []);
    itens.addAll(car?.itens.where((i) => i.itens.isNotEmpty).toList() ?? []);
  }

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<ItensChangesModel> itens =
      <ItensChangesModel>[].asObservable();

  @observable
  DateTime date = DateTime.now();

  @observable
  String prefix = "";

  String? id;

  @observable
  int step = 0;

  @observable
  String alfa = "";

  @observable
  String contact = "";

  @observable
  String? cia;

  @observable
  String team = "SELECIONE";

  @observable
  String pb = "";

  @observable
  String obs = "";

  @observable
  String startKM = "";

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
  List<CarModel> get cars {
    return app.cars
        .where((e) => (cia != null)
            ? (e.cia.toLowerCase() == cia?.toLowerCase())
            : (e.obmID.toLowerCase() == obm.id?.toLowerCase()))
        .toList();
  }

  @action
  setPrefix(String? value) {
    if (value != null && value != "SELECIONE") {
      car = CarModel.copy(cars.firstWhere((c) => c.prefix == value));
      prefix = value;

      carChanges
        ..clear()
        ..addAll(car?.changes ?? []);
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
  setAlfa(String? value) => alfa = value ?? alfa;

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
  statusExpanded(int index, bool value) {
    final result = itens.elementAt(index);

    result.value = value;

    itens
      ..removeAt(index)
      ..insert(index, result);
  }

  @action
  selectValueItens(bool value, int index, int indexItem) {
    final item = itens.elementAt(index);
    final subItem = item.itens.elementAt(indexItem);

    subItem.value = value;
    itens
      ..removeAt(index)
      ..insert(index, item);
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

  bool validationForm() {
    messagesErros.clear();
    switch (step) {
      case 0:
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
      default:
        return false;
    }
  }
}
