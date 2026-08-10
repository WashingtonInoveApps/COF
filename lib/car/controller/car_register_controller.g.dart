// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarRegisterController on _CarRegisterControllerBase, Store {
  Computed<CarModel>? _$carComputed;

  @override
  CarModel get car => (_$carComputed ??= Computed<CarModel>(() => super.car,
          name: '_CarRegisterControllerBase.car'))
      .value;

  late final _$obmAtom =
      Atom(name: '_CarRegisterControllerBase.obm', context: context);

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
      Atom(name: '_CarRegisterControllerBase.cia', context: context);

  @override
  String? get cia {
    _$ciaAtom.reportRead();
    return super.cia;
  }

  @override
  set cia(String? value) {
    _$ciaAtom.reportWrite(value, super.cia, () {
      super.cia = value;
    });
  }

  late final _$functionAtom =
      Atom(name: '_CarRegisterControllerBase.function', context: context);

  @override
  String? get function {
    _$functionAtom.reportRead();
    return super.function;
  }

  @override
  set function(String? value) {
    _$functionAtom.reportWrite(value, super.function, () {
      super.function = value;
    });
  }

  late final _$typeAtom =
      Atom(name: '_CarRegisterControllerBase.type', context: context);

  @override
  String? get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(String? value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$fieldCarTypeVisibleAtom = Atom(
      name: '_CarRegisterControllerBase.fieldCarTypeVisible', context: context);

  @override
  bool get fieldCarTypeVisible {
    _$fieldCarTypeVisibleAtom.reportRead();
    return super.fieldCarTypeVisible;
  }

  @override
  set fieldCarTypeVisible(bool value) {
    _$fieldCarTypeVisibleAtom.reportWrite(value, super.fieldCarTypeVisible, () {
      super.fieldCarTypeVisible = value;
    });
  }

  late final _$prefixAtom =
      Atom(name: '_CarRegisterControllerBase.prefix', context: context);

  @override
  String get prefix {
    _$prefixAtom.reportRead();
    return super.prefix;
  }

  @override
  set prefix(String value) {
    _$prefixAtom.reportWrite(value, super.prefix, () {
      super.prefix = value;
    });
  }

  late final _$modelAtom =
      Atom(name: '_CarRegisterControllerBase.model', context: context);

  @override
  String get model {
    _$modelAtom.reportRead();
    return super.model;
  }

  @override
  set model(String value) {
    _$modelAtom.reportWrite(value, super.model, () {
      super.model = value;
    });
  }

  late final _$modelPneuAtom =
      Atom(name: '_CarRegisterControllerBase.modelPneu', context: context);

  @override
  String get modelPneu {
    _$modelPneuAtom.reportRead();
    return super.modelPneu;
  }

  @override
  set modelPneu(String value) {
    _$modelPneuAtom.reportWrite(value, super.modelPneu, () {
      super.modelPneu = value;
    });
  }

  late final _$plateAtom =
      Atom(name: '_CarRegisterControllerBase.plate', context: context);

  @override
  String get plate {
    _$plateAtom.reportRead();
    return super.plate;
  }

  @override
  set plate(String value) {
    _$plateAtom.reportWrite(value, super.plate, () {
      super.plate = value;
    });
  }

  late final _$kmAtom =
      Atom(name: '_CarRegisterControllerBase.km', context: context);

  @override
  String get km {
    _$kmAtom.reportRead();
    return super.km;
  }

  @override
  set km(String value) {
    _$kmAtom.reportWrite(value, super.km, () {
      super.km = value;
    });
  }

  late final _$ticketAtom =
      Atom(name: '_CarRegisterControllerBase.ticket', context: context);

  @override
  String get ticket {
    _$ticketAtom.reportRead();
    return super.ticket;
  }

  @override
  set ticket(String value) {
    _$ticketAtom.reportWrite(value, super.ticket, () {
      super.ticket = value;
    });
  }

  late final _$sectionsItensAtom =
      Atom(name: '_CarRegisterControllerBase.sectionsItens', context: context);

  @override
  ObservableList<ItensChangesModel> get sectionsItens {
    _$sectionsItensAtom.reportRead();
    return super.sectionsItens;
  }

  @override
  set sectionsItens(ObservableList<ItensChangesModel> value) {
    _$sectionsItensAtom.reportWrite(value, super.sectionsItens, () {
      super.sectionsItens = value;
    });
  }

  late final _$sectionsMaterialsAtom = Atom(
      name: '_CarRegisterControllerBase.sectionsMaterials', context: context);

  @override
  ObservableList<ItensChangesModel> get sectionsMaterials {
    _$sectionsMaterialsAtom.reportRead();
    return super.sectionsMaterials;
  }

  @override
  set sectionsMaterials(ObservableList<ItensChangesModel> value) {
    _$sectionsMaterialsAtom.reportWrite(value, super.sectionsMaterials, () {
      super.sectionsMaterials = value;
    });
  }

  late final _$sectionsMaterialsConsumableAtom = Atom(
      name: '_CarRegisterControllerBase.sectionsMaterialsConsumable',
      context: context);

  @override
  ObservableList<ItensChangesModel> get sectionsMaterialsConsumable {
    _$sectionsMaterialsConsumableAtom.reportRead();
    return super.sectionsMaterialsConsumable;
  }

  @override
  set sectionsMaterialsConsumable(ObservableList<ItensChangesModel> value) {
    _$sectionsMaterialsConsumableAtom
        .reportWrite(value, super.sectionsMaterialsConsumable, () {
      super.sectionsMaterialsConsumable = value;
    });
  }

  late final _$changesAtom =
      Atom(name: '_CarRegisterControllerBase.changes', context: context);

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

  late final _$statusAtom =
      Atom(name: '_CarRegisterControllerBase.status', context: context);

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

  late final _$_CarRegisterControllerBaseActionController =
      ActionController(name: '_CarRegisterControllerBase', context: context);

  @override
  void inicialization() {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.inicialization');
    try {
      return super.inicialization();
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOBM(OBMModel? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCia(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFunction(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setFunction');
    try {
      return super.setFunction(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setType(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setType');
    try {
      return super.setType(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrefix(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setPrefix');
    try {
      return super.setPrefix(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setModel(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setModel');
    try {
      return super.setModel(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setModelPneu(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setModelPneu');
    try {
      return super.setModelPneu(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTicket(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setTicket');
    try {
      return super.setTicket(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setKM(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setKM');
    try {
      return super.setKM(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPlate(String? value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.setPlate');
    try {
      return super.setPlate(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChanges(List<CarChangeModel> value) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.onChanges');
    try {
      return super.onChanges(value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic expansionSections(
      {required List<ItensChangesModel> list, required int index}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.expansionSections');
    try {
      return super.expansionSections(list: list, index: index);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSections(
      {required List<ItensChangesModel> list,
      required ItensChangesModel value}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.addSections');
    try {
      return super.addSections(list: list, value: value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editSections(
      {required List<ItensChangesModel> list,
      required int index,
      required ItensChangesModel value}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.editSections');
    try {
      return super.editSections(list: list, index: index, value: value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSections(
      {required List<ItensChangesModel> list, required int index}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.removeSections');
    try {
      return super.removeSections(list: list, index: index);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addItensSection(
      {required List<ItensChangesModel> list,
      required int index,
      required ItemModel value}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.addItensSection');
    try {
      return super.addItensSection(list: list, index: index, value: value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editItensSection(
      {required List<ItensChangesModel> list,
      required int index,
      required int indexItem,
      required ItemModel value}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.editItensSection');
    try {
      return super.editItensSection(
          list: list, index: index, indexItem: indexItem, value: value);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void moveItensSection(
      {required List<ItensChangesModel> list,
      required int index,
      required int indexItem,
      required MoveDirection position}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.moveItensSection');
    try {
      return super.moveItensSection(
          list: list, index: index, indexItem: indexItem, position: position);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeItensSection(
      {required List<ItensChangesModel> list,
      required int index,
      required int indexItem}) {
    final _$actionInfo = _$_CarRegisterControllerBaseActionController
        .startAction(name: '_CarRegisterControllerBase.removeItensSection');
    try {
      return super
          .removeItensSection(list: list, index: index, indexItem: indexItem);
    } finally {
      _$_CarRegisterControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
obm: ${obm},
cia: ${cia},
function: ${function},
type: ${type},
fieldCarTypeVisible: ${fieldCarTypeVisible},
prefix: ${prefix},
model: ${model},
modelPneu: ${modelPneu},
plate: ${plate},
km: ${km},
ticket: ${ticket},
sectionsItens: ${sectionsItens},
sectionsMaterials: ${sectionsMaterials},
sectionsMaterialsConsumable: ${sectionsMaterialsConsumable},
changes: ${changes},
status: ${status},
car: ${car}
    ''';
  }
}
