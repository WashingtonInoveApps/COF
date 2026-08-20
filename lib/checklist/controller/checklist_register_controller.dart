import 'dart:developer';

import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/model/checklist_car_model.dart';
import 'package:bsu_control/model/checklist_material_model.dart';
import 'package:bsu_control/model/material_checklist_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/team_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../../core/sections_controller.dart';
import '../../core/validation.dart';
import '../../enum/state_enum.dart';
import '../../model/car_changes_model.dart';
import '../../model/car_model.dart';
import '../../model/checklist_model.dart';
import '../../model/cia_model.dart';
import '../../model/item_model.dart';
import '../../model/outher_changes_model.dart';
import '../../model/section_itens_model.dart';

part 'checklist_register_controller.g.dart';

class ChecklistRegisterController = _ChecklistRegisterControllerBase
    with _$ChecklistRegisterController;

abstract class _ChecklistRegisterControllerBase with Store {
  final UserModel user;
  final ChecklistModel? init;
  final List<OBMModel> obms;
  final List<ChecklistModel> checklistTodays;
  final List<CarModel> cars;
  final ChecklistType type;

  List<String> messagesErros = [];
  List<StatesChecklist> states = [];
  List<SupplyModel> supplies = [];

  _ChecklistRegisterControllerBase({
    required this.init,
    required this.checklistTodays,
    required this.obms,
    required this.cars,
    required this.type,
    required this.user,
  }) {
    initController();
  }

  List<CarModel> get carsValidations {
    final ids = checklistTodays.map((e) => e.carID).toList();
    final carsOBM = cars.where((e) => e.obmID == obm?.id).toList();

    return carsOBM
        .where((e) => !ids.contains(e.id) || (init?.carID == e.id))
        .toList();
  }

  @observable
  ObservableList<CarChangeModel> changes = <CarChangeModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> itens =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> materials =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<SectionItensModel> materialsConsumable =
      <SectionItensModel>[].asObservable();

  @observable
  ObservableList<OtherChangeModel> others = <OtherChangeModel>[].asObservable();

  @observable
  DateTime date = DateTime.now();

  @observable
  OBMModel? obm;

  @observable
  CiaModel? cia;

  @observable
  TeamModel? team;

  @observable
  String? id;

  @observable
  String pb = "";

  @observable
  String obs = "";

  @observable
  String obsGeral = "";

  @observable
  String contact = "";

  @observable
  int startKM = 0;

  @observable
  int endKM = 0;

  @observable
  double oil = 0.0;

  @observable
  double hidra = 0.0;

  @observable
  double fuel = 0.0;

  @observable
  double fr = 0.0;

  @observable
  double arref = 0.0;

  @observable
  bool enable = true;

  @observable
  CarModel? car;

  @observable
  MaterialChecklistModel? material;

  @computed
  bool get update => init != null;

  @computed
  ChecklistCarModel? get checklistCar {
    if (car == null) return null;

    return ChecklistCarModel(
      car: car!,
      oil: oil,
      arref: arref,
      fr: fr,
      fuel: fuel,
      hidra: hidra,
      changes: changes,
      obs: obs,
    );
  }

  @computed
  ChecklistMaterialModel? get checklistMaterial {
    if (material == null) return null;

    return ChecklistMaterialModel(
      material: material!,
      obs: obs,
    );
  }

  @computed
  ChecklistModel get checklist {
    return ChecklistModel(
      id: init?.id,
      user: user,
      date: date,
      states: states,
      obm: obm,
      carID: car?.id ?? '',
      cia: cia,
      material: checklistMaterial,
      vehicular: checklistCar,
      obmID: obm?.id ?? '',
      obs: obsGeral,
      pb: pb,
      team: team,
      type: type,
      userID: user.id ?? '',
      prefix: car?.prefix ?? '',
      startKM: startKM,
      state: init?.state ?? StateProgress.inprogress,
      supply: supplies,
      others: others,
    );
  }

  @computed
  List<TeamModel> get teams {
    if (obm?.team.isEmpty ?? true) return [];

    List<String> ids = [];

    for (final team in checklistTodays) {
      if (team.id != null) ids.add(team.id!);
    }

    return obm?.team
            .where((e) => !ids.contains(e.id) || (init?.team?.id == e.id))
            .toList() ??
        [];
  }

  @action
  void initController() {
    log('Iniciando Register Controller.');

    obm = obms.cast<OBMModel?>().firstWhere(
        (e) => (e?.id == init?.id) && init != null,
        orElse: () => null);

    cia = obm?.cias.cast<CiaModel?>().firstWhere(
        (e) => (e?.id == init?.id) && init != null,
        orElse: () => null);

    team = obm?.team.cast<TeamModel?>().firstWhere(
        (e) => (e?.id == init?.id) && init != null,
        orElse: () => null);

    car = cars
        .cast<CarModel?>()
        .firstWhere((e) => e?.id == init?.carID, orElse: () => null);

    id = init?.id;
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
        [
          StatesChecklist(
            state: StateProgress.inprogress,
            date: date,
          )
        ];
    supplies = init?.supply ?? [];

    others.addAll(init?.others ?? []);

    fillItensChecklist(
      check: init,
      car: car,
      material: material,
    );
  }

  @action
  void fillItensChecklist({
    ChecklistModel? check,
    CarModel? car,
    MaterialChecklistModel? material,
  }) {
    log('Preenchendo itens.');

    changes.clear();
    itens.clear();
    others.clear();
    materials.clear();

    if (check != null) {
      if (check.type == ChecklistType.vehicular) {
        itens.addAll(SectionsController.mergeSections(
            currentSections:
                SectionsController.deepCopySections(value: car?.itens ?? []),
            savedSections: SectionsController.deepCopySections(
              value: check.vehicular?.car.itens ?? [],
            )));

        changes
          ..clear()
          ..addAll(car?.changes ?? []);
      } else {
        itens.addAll(SectionsController.mergeSections(
            currentSections: SectionsController.deepCopySections(
                value: material?.itens ?? []),
            savedSections: SectionsController.deepCopySections(
              value: check.material?.material.itens ?? [],
            )));

        materials.addAll(SectionsController.mergeSections(
            currentSections: SectionsController.deepCopySections(
                value: material?.materials ?? []),
            savedSections: SectionsController.deepCopySections(
              value: check.material?.material.materials ?? [],
            )));
      }
    } else {
      if (type == ChecklistType.vehicular) {
        itens.addAll(
          SectionsController.deepCopySections(value: car?.itens ?? []),
        );

        log('Itens: ${itens.length}');
      } else {
        itens.addAll(
          SectionsController.deepCopySections(value: material?.itens ?? []),
        );

        materials.addAll(
          SectionsController.deepCopySections(value: material?.materials ?? []),
        );

        log('Itens: ${itens.length}');
        log('Materials: ${materials.length}');
      }
    }
  }

  @action
  void setCar(CarModel? value) {
    car = value;

    fillItensChecklist(
      check: init,
      car: car,
      material: material,
    );
  }

  @action
  void changeDate(DateTime? value) => date = value ?? date;

  @action
  void setOBM(OBMModel? value) {
    obm = value;
    cia = null;
  }

  @action
  void setCia(CiaModel? value) {
    cia = value;
    team = null;
  }

  @action
  void setChecklistMaterial(MaterialChecklistModel? value) {
    material = value;

    fillItensChecklist(
      check: init,
      car: car,
      material: material,
    );
  }

  @action
  void setTeam(TeamModel? value) {
    team = value;
  }

  @action
  void setContact(String? value) => contact = value ?? '';

  @action
  void setPB(String? value) => pb = value ?? pb;

  @action
  void setKMStart(String? value) {
    if (value == null) return;

    startKM = int.parse(value);
  }

  @action
  void setOBS(String? value) => obs = value ?? obs;

  @action
  void setOBSGeral(String? value) => obsGeral = value ?? obsGeral;

  @action
  void setOil(double? value) => oil = value ?? oil;

  @action
  void setHidra(double? value) => hidra = value ?? hidra;

  @action
  void setFuel(double? value) => fuel = value ?? fuel;

  @action
  void setFR(double? value) => fr = value ?? fr;

  @action
  void setArref(double? value) => arref = value ?? arref;

  @action
  void addOthersChange(OtherChangeModel value) {
    others.add(value);
  }

  @action
  void deleteOuhtersChange(int index) {
    others.removeAt(index);
  }

  @action
  void addCarChanges(List<CarChangeModel> value) {
    changes
      ..clear()
      ..addAll(value);
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
  void changeOBSListItens({
    required List<SectionItensModel> list,
    required String obs,
    required int indexSection,
  }) {
    final section = SectionItensModel.fromMap(list[indexSection].toMap());

    list.removeAt(indexSection);
    list.insert(indexSection, section.copyWith(obs: obs));
  }

  bool processStep(int step) {
    if (type == ChecklistType.vehicular) {
      if (itens.isEmpty && step == 2) return true;

      if (step == 3) return true;
    } else {
      if (itens.isEmpty && step == 2) return true;

      if (step == 3) return true;
    }

    return false;
  }

  List<String> validationForm(int step) {
    messagesErros.clear();

    log('Step: $step');

    switch (step) {
      case 0:
        if (obm == null) {
          messagesErros.add('Selecione a OBM antes de continuar.');
        }

        if ((obm?.cias.isNotEmpty ?? true) && cia == null) {
          messagesErros.add('Selecione a companhia antes de continuar.');
        }

        if ((teams.isNotEmpty) && team == null) {
          messagesErros.add('Selecione a guarnição antes de continuar.');
        }

        if (Validation.validatorPhone(contact) != null) {
          messagesErros.add('Insira um contato válido antes de continuar.');
        }

        return messagesErros;
      case 1:
        if (type == ChecklistType.vehicular) {
          if (car == null) {
            messagesErros.add('Selecione o veículo antes de continuar.');
          }

          if (startKM <= 0) {
            messagesErros
                .add('Preencher o KM inicíal da viatura antes de continuar.');
          }

          if (fuel <= 0) {
            messagesErros
                .add('Selecione o nível de combustível antes de continuar.');
          }

          if (oil <= 0) {
            messagesErros.add('Selecione o nível do oléo antes de continuar.');
          }

          if (fr <= 0) {
            messagesErros
                .add('Selecione o nível do oléo de freio antes de continuar.');
          }

          if (arref <= 0) {
            messagesErros.add(
                'Selecione o nível da água do arrefecimento antes de continuar.');
          }
        }

        return messagesErros;
      default:
        return [];
    }
  }
}
