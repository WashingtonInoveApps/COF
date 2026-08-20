// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ChecklistRegisterController on _ChecklistRegisterControllerBase, Store {
  Computed<bool>? _$updateComputed;

  @override
  bool get update => (_$updateComputed ??= Computed<bool>(() => super.update,
          name: '_ChecklistRegisterControllerBase.update'))
      .value;
  Computed<ChecklistCarModel?>? _$checklistCarComputed;

  @override
  ChecklistCarModel? get checklistCar => (_$checklistCarComputed ??=
          Computed<ChecklistCarModel?>(() => super.checklistCar,
              name: '_ChecklistRegisterControllerBase.checklistCar'))
      .value;
  Computed<ChecklistMaterialModel?>? _$checklistMaterialComputed;

  @override
  ChecklistMaterialModel? get checklistMaterial =>
      (_$checklistMaterialComputed ??= Computed<ChecklistMaterialModel?>(
              () => super.checklistMaterial,
              name: '_ChecklistRegisterControllerBase.checklistMaterial'))
          .value;
  Computed<ChecklistModel>? _$checklistComputed;

  @override
  ChecklistModel get checklist =>
      (_$checklistComputed ??= Computed<ChecklistModel>(() => super.checklist,
              name: '_ChecklistRegisterControllerBase.checklist'))
          .value;
  Computed<List<TeamModel>>? _$teamsComputed;

  @override
  List<TeamModel> get teams =>
      (_$teamsComputed ??= Computed<List<TeamModel>>(() => super.teams,
              name: '_ChecklistRegisterControllerBase.teams'))
          .value;

  late final _$changesAtom =
      Atom(name: '_ChecklistRegisterControllerBase.changes', context: context);

  @override
  ObservableList<CarChangeModel> get changes {
    _$changesAtom.reportRead();
    return super.changes;
  }

  @override
  set changes(ObservableList<CarChangeModel> value) {
    _$changesAtom.reportWrite(value, super.changes, () {
      super.changes = value;
    });
  }

  late final _$itensAtom =
      Atom(name: '_ChecklistRegisterControllerBase.itens', context: context);

  @override
  ObservableList<SectionItensModel> get itens {
    _$itensAtom.reportRead();
    return super.itens;
  }

  @override
  set itens(ObservableList<SectionItensModel> value) {
    _$itensAtom.reportWrite(value, super.itens, () {
      super.itens = value;
    });
  }

  late final _$materialsAtom = Atom(
      name: '_ChecklistRegisterControllerBase.materials', context: context);

  @override
  ObservableList<SectionItensModel> get materials {
    _$materialsAtom.reportRead();
    return super.materials;
  }

  @override
  set materials(ObservableList<SectionItensModel> value) {
    _$materialsAtom.reportWrite(value, super.materials, () {
      super.materials = value;
    });
  }

  late final _$materialsConsumableAtom = Atom(
      name: '_ChecklistRegisterControllerBase.materialsConsumable',
      context: context);

  @override
  ObservableList<SectionItensModel> get materialsConsumable {
    _$materialsConsumableAtom.reportRead();
    return super.materialsConsumable;
  }

  @override
  set materialsConsumable(ObservableList<SectionItensModel> value) {
    _$materialsConsumableAtom.reportWrite(value, super.materialsConsumable, () {
      super.materialsConsumable = value;
    });
  }

  late final _$othersAtom =
      Atom(name: '_ChecklistRegisterControllerBase.others', context: context);

  @override
  ObservableList<OtherChangeModel> get others {
    _$othersAtom.reportRead();
    return super.others;
  }

  @override
  set others(ObservableList<OtherChangeModel> value) {
    _$othersAtom.reportWrite(value, super.others, () {
      super.others = value;
    });
  }

  late final _$dateAtom =
      Atom(name: '_ChecklistRegisterControllerBase.date', context: context);

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  late final _$obmAtom =
      Atom(name: '_ChecklistRegisterControllerBase.obm', context: context);

  @override
  OBMModel? get obm {
    _$obmAtom.reportRead();
    return super.obm;
  }

  @override
  set obm(OBMModel? value) {
    _$obmAtom.reportWrite(value, super.obm, () {
      super.obm = value;
    });
  }

  late final _$ciaAtom =
      Atom(name: '_ChecklistRegisterControllerBase.cia', context: context);

  @override
  CiaModel? get cia {
    _$ciaAtom.reportRead();
    return super.cia;
  }

  @override
  set cia(CiaModel? value) {
    _$ciaAtom.reportWrite(value, super.cia, () {
      super.cia = value;
    });
  }

  late final _$teamAtom =
      Atom(name: '_ChecklistRegisterControllerBase.team', context: context);

  @override
  TeamModel? get team {
    _$teamAtom.reportRead();
    return super.team;
  }

  @override
  set team(TeamModel? value) {
    _$teamAtom.reportWrite(value, super.team, () {
      super.team = value;
    });
  }

  late final _$idAtom =
      Atom(name: '_ChecklistRegisterControllerBase.id', context: context);

  @override
  String? get id {
    _$idAtom.reportRead();
    return super.id;
  }

  @override
  set id(String? value) {
    _$idAtom.reportWrite(value, super.id, () {
      super.id = value;
    });
  }

  late final _$pbAtom =
      Atom(name: '_ChecklistRegisterControllerBase.pb', context: context);

  @override
  String get pb {
    _$pbAtom.reportRead();
    return super.pb;
  }

  @override
  set pb(String value) {
    _$pbAtom.reportWrite(value, super.pb, () {
      super.pb = value;
    });
  }

  late final _$obsAtom =
      Atom(name: '_ChecklistRegisterControllerBase.obs', context: context);

  @override
  String get obs {
    _$obsAtom.reportRead();
    return super.obs;
  }

  @override
  set obs(String value) {
    _$obsAtom.reportWrite(value, super.obs, () {
      super.obs = value;
    });
  }

  late final _$obsGeralAtom =
      Atom(name: '_ChecklistRegisterControllerBase.obsGeral', context: context);

  @override
  String get obsGeral {
    _$obsGeralAtom.reportRead();
    return super.obsGeral;
  }

  @override
  set obsGeral(String value) {
    _$obsGeralAtom.reportWrite(value, super.obsGeral, () {
      super.obsGeral = value;
    });
  }

  late final _$contactAtom =
      Atom(name: '_ChecklistRegisterControllerBase.contact', context: context);

  @override
  String get contact {
    _$contactAtom.reportRead();
    return super.contact;
  }

  @override
  set contact(String value) {
    _$contactAtom.reportWrite(value, super.contact, () {
      super.contact = value;
    });
  }

  late final _$startKMAtom =
      Atom(name: '_ChecklistRegisterControllerBase.startKM', context: context);

  @override
  int get startKM {
    _$startKMAtom.reportRead();
    return super.startKM;
  }

  @override
  set startKM(int value) {
    _$startKMAtom.reportWrite(value, super.startKM, () {
      super.startKM = value;
    });
  }

  late final _$endKMAtom =
      Atom(name: '_ChecklistRegisterControllerBase.endKM', context: context);

  @override
  int get endKM {
    _$endKMAtom.reportRead();
    return super.endKM;
  }

  @override
  set endKM(int value) {
    _$endKMAtom.reportWrite(value, super.endKM, () {
      super.endKM = value;
    });
  }

  late final _$oilAtom =
      Atom(name: '_ChecklistRegisterControllerBase.oil', context: context);

  @override
  double get oil {
    _$oilAtom.reportRead();
    return super.oil;
  }

  @override
  set oil(double value) {
    _$oilAtom.reportWrite(value, super.oil, () {
      super.oil = value;
    });
  }

  late final _$hidraAtom =
      Atom(name: '_ChecklistRegisterControllerBase.hidra', context: context);

  @override
  double get hidra {
    _$hidraAtom.reportRead();
    return super.hidra;
  }

  @override
  set hidra(double value) {
    _$hidraAtom.reportWrite(value, super.hidra, () {
      super.hidra = value;
    });
  }

  late final _$fuelAtom =
      Atom(name: '_ChecklistRegisterControllerBase.fuel', context: context);

  @override
  double get fuel {
    _$fuelAtom.reportRead();
    return super.fuel;
  }

  @override
  set fuel(double value) {
    _$fuelAtom.reportWrite(value, super.fuel, () {
      super.fuel = value;
    });
  }

  late final _$frAtom =
      Atom(name: '_ChecklistRegisterControllerBase.fr', context: context);

  @override
  double get fr {
    _$frAtom.reportRead();
    return super.fr;
  }

  @override
  set fr(double value) {
    _$frAtom.reportWrite(value, super.fr, () {
      super.fr = value;
    });
  }

  late final _$arrefAtom =
      Atom(name: '_ChecklistRegisterControllerBase.arref', context: context);

  @override
  double get arref {
    _$arrefAtom.reportRead();
    return super.arref;
  }

  @override
  set arref(double value) {
    _$arrefAtom.reportWrite(value, super.arref, () {
      super.arref = value;
    });
  }

  late final _$enableAtom =
      Atom(name: '_ChecklistRegisterControllerBase.enable', context: context);

  @override
  bool get enable {
    _$enableAtom.reportRead();
    return super.enable;
  }

  @override
  set enable(bool value) {
    _$enableAtom.reportWrite(value, super.enable, () {
      super.enable = value;
    });
  }

  late final _$carAtom =
      Atom(name: '_ChecklistRegisterControllerBase.car', context: context);

  @override
  CarModel? get car {
    _$carAtom.reportRead();
    return super.car;
  }

  @override
  set car(CarModel? value) {
    _$carAtom.reportWrite(value, super.car, () {
      super.car = value;
    });
  }

  late final _$materialAtom =
      Atom(name: '_ChecklistRegisterControllerBase.material', context: context);

  @override
  MaterialChecklistModel? get material {
    _$materialAtom.reportRead();
    return super.material;
  }

  @override
  set material(MaterialChecklistModel? value) {
    _$materialAtom.reportWrite(value, super.material, () {
      super.material = value;
    });
  }

  late final _$_ChecklistRegisterControllerBaseActionController =
      ActionController(
          name: '_ChecklistRegisterControllerBase', context: context);

  @override
  void initController() {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.initController');
    try {
      return super.initController();
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void fillItensChecklist(
      {ChecklistModel? check,
      CarModel? car,
      MaterialChecklistModel? material}) {
    final _$actionInfo =
        _$_ChecklistRegisterControllerBaseActionController.startAction(
            name: '_ChecklistRegisterControllerBase.fillItensChecklist');
    try {
      return super
          .fillItensChecklist(check: check, car: car, material: material);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setCar(CarModel? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setCar');
    try {
      return super.setCar(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeDate(DateTime? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.changeDate');
    try {
      return super.changeDate(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setOBM(OBMModel? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setCia(CiaModel? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setChecklistMaterial(MaterialChecklistModel? value) {
    final _$actionInfo =
        _$_ChecklistRegisterControllerBaseActionController.startAction(
            name: '_ChecklistRegisterControllerBase.setChecklistMaterial');
    try {
      return super.setChecklistMaterial(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setTeam(TeamModel? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setTeam');
    try {
      return super.setTeam(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setContact(String? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setContact');
    try {
      return super.setContact(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setPB(String? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setPB');
    try {
      return super.setPB(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setKMStart(String? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setKMStart');
    try {
      return super.setKMStart(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setOBS(String? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setOBS');
    try {
      return super.setOBS(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setOBSGeral(String? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setOBSGeral');
    try {
      return super.setOBSGeral(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setOil(double? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setOil');
    try {
      return super.setOil(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setHidra(double? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setHidra');
    try {
      return super.setHidra(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setFuel(double? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setFuel');
    try {
      return super.setFuel(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setFR(double? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setFR');
    try {
      return super.setFR(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setArref(double? value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.setArref');
    try {
      return super.setArref(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void addOthersChange(OtherChangeModel value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.addOthersChange');
    try {
      return super.addOthersChange(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void deleteOuhtersChange(int index) {
    final _$actionInfo =
        _$_ChecklistRegisterControllerBaseActionController.startAction(
            name: '_ChecklistRegisterControllerBase.deleteOuhtersChange');
    try {
      return super.deleteOuhtersChange(index);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void addCarChanges(List<CarChangeModel> value) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.addCarChanges');
    try {
      return super.addCarChanges(value);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  List<SectionItensModel> changeList(
      {required List<SectionItensModel> list,
      required ItemModel value,
      required int indexSection,
      required int indexItem}) {
    final _$actionInfo = _$_ChecklistRegisterControllerBaseActionController
        .startAction(name: '_ChecklistRegisterControllerBase.changeList');
    try {
      return super.changeList(
          list: list,
          value: value,
          indexSection: indexSection,
          indexItem: indexItem);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeOBSListItens(
      {required List<SectionItensModel> list,
      required String obs,
      required int indexSection}) {
    final _$actionInfo =
        _$_ChecklistRegisterControllerBaseActionController.startAction(
            name: '_ChecklistRegisterControllerBase.changeOBSListItens');
    try {
      return super
          .changeOBSListItens(list: list, obs: obs, indexSection: indexSection);
    } finally {
      _$_ChecklistRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
changes: ${changes},
itens: ${itens},
materials: ${materials},
materialsConsumable: ${materialsConsumable},
others: ${others},
date: ${date},
obm: ${obm},
cia: ${cia},
team: ${team},
id: ${id},
pb: ${pb},
obs: ${obs},
obsGeral: ${obsGeral},
contact: ${contact},
startKM: ${startKM},
endKM: ${endKM},
oil: ${oil},
hidra: ${hidra},
fuel: ${fuel},
fr: ${fr},
arref: ${arref},
enable: ${enable},
car: ${car},
material: ${material},
update: ${update},
checklistCar: ${checklistCar},
checklistMaterial: ${checklistMaterial},
checklist: ${checklist},
teams: ${teams}
    ''';
  }
}
