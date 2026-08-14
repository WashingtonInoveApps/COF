// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MaterialsRegisterController on _MaterialsRegisterControllerBase, Store {
  Computed<List<TeamModel>>? _$teamsComputed;

  @override
  List<TeamModel> get teams =>
      (_$teamsComputed ??= Computed<List<TeamModel>>(() => super.teams,
              name: '_MaterialsRegisterControllerBase.teams'))
          .value;
  Computed<MaterialsModel>? _$carComputed;

  @override
  MaterialsModel get car =>
      (_$carComputed ??= Computed<MaterialsModel>(() => super.car,
              name: '_MaterialsRegisterControllerBase.car'))
          .value;

  late final _$imagesAtom =
      Atom(name: '_MaterialsRegisterControllerBase.images', context: context);

  @override
  ObservableList<dynamic> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableList<dynamic> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  late final _$obmAtom =
      Atom(name: '_MaterialsRegisterControllerBase.obm', context: context);

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
      Atom(name: '_MaterialsRegisterControllerBase.cia', context: context);

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
      Atom(name: '_MaterialsRegisterControllerBase.team', context: context);

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

  late final _$sectionsItensAtom = Atom(
      name: '_MaterialsRegisterControllerBase.sectionsItens', context: context);

  @override
  ObservableList<SectionItensModel> get sectionsItens {
    _$sectionsItensAtom.reportRead();
    return super.sectionsItens;
  }

  @override
  set sectionsItens(ObservableList<SectionItensModel> value) {
    _$sectionsItensAtom.reportWrite(value, super.sectionsItens, () {
      super.sectionsItens = value;
    });
  }

  late final _$changesAtom =
      Atom(name: '_MaterialsRegisterControllerBase.changes', context: context);

  @override
  ObservableList<OtherChangeModel> get changes {
    _$changesAtom.reportRead();
    return super.changes;
  }

  @override
  set changes(ObservableList<OtherChangeModel> value) {
    _$changesAtom.reportWrite(value, super.changes, () {
      super.changes = value;
    });
  }

  late final _$statusAtom =
      Atom(name: '_MaterialsRegisterControllerBase.status', context: context);

  @override
  ObservableList<CarStatusModel> get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(ObservableList<CarStatusModel> value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$_MaterialsRegisterControllerBaseActionController =
      ActionController(
          name: '_MaterialsRegisterControllerBase', context: context);

  @override
  void inicialization() {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.inicialization');
    try {
      return super.inicialization();
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setOBM(OBMModel? value) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setCia(CiaModel? value) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setTeam(TeamModel? value) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.setTeam');
    try {
      return super.setTeam(value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void onChanges(List<OtherChangeModel> value) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.onChanges');
    try {
      return super.onChanges(value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void removeChanges(int index) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.removeChanges');
    try {
      return super.removeChanges(index);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void expansionSections(
      {required List<SectionItensModel> list, required int index}) {
    final _$actionInfo =
        _$_MaterialsRegisterControllerBaseActionController.startAction(
            name: '_MaterialsRegisterControllerBase.expansionSections');
    try {
      return super.expansionSections(list: list, index: index);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void addSections(
      {required List<SectionItensModel> list,
      required SectionItensModel value}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.addSections');
    try {
      return super.addSections(list: list, value: value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void editSections(
      {required List<SectionItensModel> list,
      required int index,
      required SectionItensModel value}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.editSections');
    try {
      return super.editSections(list: list, index: index, value: value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void removeSections(
      {required List<SectionItensModel> list, required int index}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.removeSections');
    try {
      return super.removeSections(list: list, index: index);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void addItensSection(
      {required List<SectionItensModel> list,
      required int index,
      required ItemModel value}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.addItensSection');
    try {
      return super.addItensSection(list: list, index: index, value: value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void editItensSection(
      {required List<SectionItensModel> list,
      required int index,
      required int indexItem,
      required ItemModel value}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.editItensSection');
    try {
      return super.editItensSection(
          list: list, index: index, indexItem: indexItem, value: value);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void moveItensSection(
      {required List<SectionItensModel> list,
      required int index,
      required int indexItem,
      required MoveDirection position}) {
    final _$actionInfo = _$_MaterialsRegisterControllerBaseActionController
        .startAction(name: '_MaterialsRegisterControllerBase.moveItensSection');
    try {
      return super.moveItensSection(
          list: list, index: index, indexItem: indexItem, position: position);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void removeItensSection(
      {required List<SectionItensModel> list,
      required int index,
      required int indexItem}) {
    final _$actionInfo =
        _$_MaterialsRegisterControllerBaseActionController.startAction(
            name: '_MaterialsRegisterControllerBase.removeItensSection');
    try {
      return super
          .removeItensSection(list: list, index: index, indexItem: indexItem);
    } finally {
      _$_MaterialsRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
images: ${images},
obm: ${obm},
cia: ${cia},
team: ${team},
sectionsItens: ${sectionsItens},
changes: ${changes},
status: ${status},
teams: ${teams},
car: ${car}
    ''';
  }
}
