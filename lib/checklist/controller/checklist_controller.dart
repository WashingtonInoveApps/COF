import 'dart:typed_data';

import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/checklist_car_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/team_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/checklist/repository/checklist_interface.dart';
import 'package:bsu_control/checklist/repository/checklist_repository.dart';
import 'package:mobx/mobx.dart';

import '../../model/supply_model.dart';

part 'checklist_controller.g.dart';

// ignore: library_private_types_in_public_api
class CheckListController = _CheckListControllerBase with _$CheckListController;

abstract class _CheckListControllerBase with Store {
  final ConfigModel config;
  final ChecklistModel? init;
  final List<CarModel> cars;
  final List<ChecklistModel> checklistTodays;

  final bool update;

  late ICheckListRepository repository;

  List<String> messagesErros = [];

  @observable
  bool loading = false;

  _CheckListControllerBase(
      {required this.init,
      required this.config,
      required this.update,
      required this.cars,
      required this.checklistTodays}) {
    repository = CheckListRepository(
      endpoint: config.endpoint,
      appID: config.appID,
      test: config.test,
    );

    initController(init);
  }

  Stream<ChecklistModel> streamChecklistByID({required String checklistID}) {
    return repository.streamChecklistByID(checklistID: checklistID);
  }

  @action
  initController(ChecklistModel? init) {
    itens.clear();
    materials.clear();
    materialsConsumable.clear();

    id = init?.id;
    prefix = init?.prefix ?? 'SELECIONE';
    oil = init?.vehicular?.oil ?? 0.0;
    hidra = init?.vehicular?.hidra ?? 0.0;
    fr = init?.vehicular?.fr ?? 0.0;
    arref = init?.vehicular?.arref ?? 0.0;
    fuel = init?.vehicular?.fuel ?? 0.0;
    team = init?.team ?? team;
    startKM = init?.startKM ?? 0;
    endKM = init?.endKM ?? 0;
    date = init?.date ?? date;
    obs = init?.obs ?? '';
    enable = init?.enable ?? true;
    states = init?.states ??
        [StatesChecklist(state: StateProgress.inprogress, date: date)];
    supplies = init?.supply ?? [];

    if (init != null) {
      car = cars.firstWhere((e) => e.id == init.vehicular?.car.id);

      itens.addAll(mergeSections(
          currentSections: deepCopySections(value: car?.itens ?? []),
          savedSections: deepCopySections(
            value: init.vehicular?.car.itens ?? [],
          )));

      // others
      //   ..clear()
      //   ..addAll(init.others ?? []);
    } else {
      itens.addAll(deepCopySections(value: car?.itens ?? []));
    }

    carChanges
      ..clear()
      ..addAll(car?.changes ?? []);
  }

  @observable
  ObservableList<CarChangeModel> carChanges = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> itens =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<ChecklistModel> myChecklistUser =
      <ChecklistModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> materials =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> materialsConsumable =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<OtherChangeModel> others = <OtherChangeModel>[].asObservable();

  @observable
  ObservableList<TeamModel> teams = <TeamModel>[].asObservable();

  @observable
  ObservableList<ItemModel> materialsConsumedUsed =
      <ItemModel>[].asObservable();

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
  CiaModel? cia;

  @observable
  TeamModel? team;

  @observable
  String pb = "";

  @observable
  String obs = "";

  @observable
  int startKM = 0;

  @observable
  int endKM = 0;

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
    if (step == 4) {
      return true;
    }

    return false;
  }

  @computed
  List<CarModel> get carsSort {
    return cars
        .where((e) => (cia != null)
            ? (e.ciaID == cia?.id)
            : (e.obmID.toLowerCase() == obm.id?.toLowerCase()))
        .toList();
  }

  Stream<List<ChecklistModel>> streamChecklistPeriod(
      {required String userID,
      required DateTime referenceDateStart,
      required DateTime referenceDateFinish}) {
    return repository.streamChecklistPeriod(
        referenceDateStart: referenceDateStart,
        referenceDateFinish: referenceDateFinish);
  }

  Stream<List<ChecklistModel>> streamChecklistUser({required String userID}) {
    return repository.streamChecklistUser(userID: userID);
  }

  @computed
  List<ChecklistModel> get myChecklistUserSort {
    if (filter.isNotEmpty) {
      final filtered = myChecklistUser
          .where((e) =>
              (e.prefix.toLowerCase().contains(filter.toLowerCase()) ||
                  e.obm.name.toLowerCase().contains(filter.toLowerCase()) ||
                  ((e.cia?.name.toLowerCase() ?? '')
                      .contains(filter.toLowerCase())) ||
                  ((e.team?.name.toLowerCase() ?? '')
                      .contains(filter.toLowerCase())) ||
                  (e.state.label.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<ChecklistModel>.from(list);
    } else {
      final list =
          Core.paginate(list: myChecklistUser, page: page, limit: limit);
      return List<ChecklistModel>.from(list);
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
  setMyChecklistUser(List<ChecklistModel> value) {
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
  addOthersChange(OtherChangeModel value) {
    others.add(value);
  }

  @action
  deleteOuhtersChange(int index) {
    others.removeAt(index);
  }

  @action
  addMaterialsConsumedUsed(List<ItemModel> values) {
    materialsConsumedUsed
      ..clear()
      ..addAll(values);
  }

  @action
  deleteMaterialsConsumedUsed(int index) {
    materialsConsumedUsed.removeAt(index);
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
        ..addAll(deepCopySections(value: car?.itens ?? []));
    }
  }

  List<TeamModel> teamsValidade({required List<TeamModel> teams}) {
    if (obm.team.isEmpty) return [];

    final list = checklistTodays.map((e) => e.team).toList();
    final result = obm.team.where((e) => !list.contains(e)).toList();

    if (update) {
      if (init?.team != null) {
        result.insert(0, init!.team!);
      }
    }

    return result;
  }

  @computed
  List<String> get prefixs {
    List<String> data = [];

    if (cars.isNotEmpty) {
      final list = checklistTodays.map((e) => e.prefix).toList();

      final result = cars
          .where((e) => !list.contains(e.prefix))
          .map((e) => e.prefix)
          .toList();

      data.addAll(result);

      if (update) data.add(init!.prefix);
    }

    return data;
  }

  List<SectionItensModel> deepCopySections({
    required List<SectionItensModel> value,
  }) {
    return value.map((section) {
      return SectionItensModel(
        id: section.id,
        description: section.description,
        value: false,
        obs: section.obs,
        itens: section.itens.map((item) {
          return ItemModel(
            id: item.id,
            description: item.description,
            quantity: item.quantity,
            quantityMarked: item.quantityMarked,
            value: item.value,
          );
        }).toList(),
      );
    }).toList();
  }

  //Criado com auxilio do ChatGPT
  List<SectionItensModel> mergeSections({
    required List<SectionItensModel> currentSections,
    required List<SectionItensModel> savedSections,
  }) {
    /// 1️⃣ Cria um mapa das seções salvas usando o ID como chave
    final Map<String, SectionItensModel> savedSectionsMap = {
      for (var section in savedSections) section.id: section
    };

    /// 2️⃣ Percorre as seções atuais do carro
    return currentSections.map((currentSection) {
      /// 3️⃣ Procura se essa seção já existia no checklist salvo
      final savedSection = savedSectionsMap[currentSection.id];

      /// 4️⃣ Se não existir, significa que é uma seção nova
      if (savedSection == null) {
        return currentSection;
      }

      /// 5️⃣ Cria um mapa dos itens salvos dessa seção
      final Map<String, ItemModel> savedItemsMap = {
        for (var item in savedSection.itens) item.id: item
      };

      /// 6️⃣ Agora percorremos os itens atuais da seção
      final mergedItems = currentSection.itens.map((currentItem) {
        /// 7️⃣ Verifica se esse item já foi salvo antes
        final savedItem = savedItemsMap[currentItem.id];

        /// 8️⃣ Se existir, reaproveita os dados do checklist salvo
        if (savedItem != null) {
          return currentItem.copyWith(
              quantityMarked: savedItem.quantityMarked, value: savedItem.value);
        }

        /// 9️⃣ Se não existir, é um item novo
        return currentItem;
      }).toList();

      /// 🔟 Retorna a seção mesclada
      return currentSection.copyWith(
        itens: mergedItems,
        obs: savedSection.obs,
        value: false,
      );
    }).toList();
  }

  @action
  setOBM(OBMModel? value) {
    if (value != null) {
      if (obm != value) {
        teams.clear();

        obm = value;

        teams.addAll(teamsValidade(teams: obm.team));

        // if (teams.isNotEmpty && team.isEmpty) team = teams.last;

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
  setCia(CiaModel? value) => cia = value;

  @action
  setTeam(TeamModel? value) => team = value;

  @action
  setContact(String? value) => contact = value ?? '';

  @action
  setPB(String? value) => pb = value ?? pb;

  @action
  void setKMStart(String? value) {
    if (value == null) return;

    startKM = int.parse(value);
  }

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
  List<SectionItensModel> changeList({
    required List<SectionItensModel> list,
    required ItemModel value,
    required int indexSection,
    required int indexItem,
  }) {
    final section = SectionItensModel.fromMap(list[indexSection].toMap());
    List<ItemModel> itens = List.from(section.itens);

    itens.removeAt(indexItem);
    itens.insert(indexItem, value);

    list.removeAt(indexSection);
    list.insert(indexSection, section.copyWith(itens: itens));

    return list;
  }

  @action
  changeOBS({
    required List<SectionItensModel> list,
    required String obs,
    required int indexSection,
  }) {
    final section = SectionItensModel.fromMap(list[indexSection].toMap());

    list.removeAt(indexSection);
    list.insert(indexSection, section.copyWith(obs: obs));
  }

  @action
  setLoading(bool value) => loading = value;

  @action
  Future<bool> save({required UserModel user}) async {
    try {
      loading = true;

      final checklist = ChecklistModel(
          id: id,
          date: date,
          user: user,
          userID: user.id ?? '',
          vehicular: ChecklistCarModel(
            car: car!.copyWith(
              itens: itens.map((e) => e.copyWith(value: false)).toList(),
            ),
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
          state: StateProgress.inprogress,
          obmID: obm.id ?? '',
          obm: obm,
          cia: cia,
          states: states,
          supply: supplies);

      final result = await repository.save(
        checklist: checklist,
        changes: carChanges,
        others: others,
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
      {required ChecklistModel checklist, Uint8List? image}) async {
    try {
      final now = DateTime.now();
      final states = List<StatesChecklist>.from(checklist.states);

      final state = StatesChecklist(state: StateProgress.completed, date: now);
      states.add(state);

      final result = await repository.finish(
          checklist: checklist.copyWith(
              state: state.state,
              // materials: materialsConsumedUsed,
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
  Future<bool> delete({required ChecklistModel checklist}) async {
    try {
      loading = true;

      final car = cars.cast<CarModel?>().firstWhere(
          (e) => e?.id == checklist.vehicular?.car.id,
          orElse: () => null);

      if (car == null) {
        throw Exception('Veículo não encontrado.');
      }

      final changes = List<CarChangeModel>.from(car.changes);

      for (final change in (checklist.vehicular?.changes ?? [])) {
        changes.removeWhere(
            (e) => (e.checklistID != null) && (e.checklistID == checklist.id));
      }

      final result = await repository.delete(
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

        if (obm.team.isNotEmpty && team == null) {
          messagesErros.add("Escolha a guarnição antes de prosseguir.");
        }

        return messagesErros.isEmpty;
      case 1:
        if (prefix == "SELECIONE") {
          messagesErros
              .add("Escolha o prefixo do veiculo antes de prosseguir.");
        }
        if (startKM <= 0) {
          messagesErros.add("Insira o KM inicial antes de prosseguir.");
        }
        if (oil == 0.0 || fr == 0.0 || hidra == 0.0 || arref == 0.0) {
          messagesErros
              .add("Verifique os níveis dos fluídos antes de prosseguir.");
        }

        return messagesErros.isEmpty;
      default:
        return true;
    }
  }
}
