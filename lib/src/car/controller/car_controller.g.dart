// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarController on _CarControllerBase, Store {
  Computed<bool>? _$enableComputed;

  @override
  bool get enable => (_$enableComputed ??=
          Computed<bool>(() => super.enable, name: '_CarControllerBase.enable'))
      .value;
  Computed<bool>? _$admComputed;

  @override
  bool get adm => (_$admComputed ??=
          Computed<bool>(() => super.adm, name: '_CarControllerBase.adm'))
      .value;

  late final _$loadingAtom =
      Atom(name: '_CarControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$typeAtom =
      Atom(name: '_CarControllerBase.type', context: context);

  @override
  String get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(String value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$functionAtom =
      Atom(name: '_CarControllerBase.function', context: context);

  @override
  String get function {
    _$functionAtom.reportRead();
    return super.function;
  }

  @override
  set function(String value) {
    _$functionAtom.reportWrite(value, super.function, () {
      super.function = value;
    });
  }

  late final _$ciaAtom = Atom(name: '_CarControllerBase.cia', context: context);

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

  late final _$obmAtom = Atom(name: '_CarControllerBase.obm', context: context);

  @override
  OBMModel get obm {
    _$obmAtom.reportRead();
    return super.obm;
  }

  @override
  set obm(OBMModel value) {
    _$obmAtom.reportWrite(value, super.obm, () {
      super.obm = value;
    });
  }

  late final _$sectionsItensAtom =
      Atom(name: '_CarControllerBase.sectionsItens', context: context);

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

  late final _$carChangesAtom =
      Atom(name: '_CarControllerBase.carChanges', context: context);

  @override
  ObservableList<CarChangeModel> get carChanges {
    _$carChangesAtom.reportRead();
    return super.carChanges;
  }

  @override
  set carChanges(ObservableList<CarChangeModel> value) {
    _$carChangesAtom.reportWrite(value, super.carChanges, () {
      super.carChanges = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_CarControllerBase.save', context: context);

  @override
  Future<bool> save({required CarModel car, required List<dynamic> images}) {
    return _$saveAsyncAction.run(() => super.save(car: car, images: images));
  }

  late final _$copyAsyncAction =
      AsyncAction('_CarControllerBase.copy', context: context);

  @override
  Future<bool> copy({required CarModel car}) {
    return _$copyAsyncAction.run(() => super.copy(car: car));
  }

  late final _$updateKMOilAsyncAction =
      AsyncAction('_CarControllerBase.updateKMOil', context: context);

  @override
  Future<bool> updateKMOil({required String id, required int value}) {
    return _$updateKMOilAsyncAction
        .run(() => super.updateKMOil(id: id, value: value));
  }

  late final _$updateKMArrefAsyncAction =
      AsyncAction('_CarControllerBase.updateKMArref', context: context);

  @override
  Future<bool> updateKMArref({required String id, required int value}) {
    return _$updateKMArrefAsyncAction
        .run(() => super.updateKMArref(id: id, value: value));
  }

  late final _$updateStatusCarAsyncAction =
      AsyncAction('_CarControllerBase.updateStatusCar', context: context);

  @override
  Future<bool> updateStatusCar(
      {required CarModel car, CarStatusModel? status}) {
    return _$updateStatusCarAsyncAction
        .run(() => super.updateStatusCar(car: car, status: status));
  }

  late final _$deleteStatusCarAsyncAction =
      AsyncAction('_CarControllerBase.deleteStatusCar', context: context);

  @override
  Future<bool> deleteStatusCar(
      {required CarModel car, required CarStatusModel status}) {
    return _$deleteStatusCarAsyncAction
        .run(() => super.deleteStatusCar(car: car, status: status));
  }

  late final _$insertMapaCarAsyncAction =
      AsyncAction('_CarControllerBase.insertMapaCar', context: context);

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapa}) {
    return _$insertMapaCarAsyncAction
        .run(() => super.insertMapaCar(mapa: mapa));
  }

  late final _$deleteCarMapaAsyncAction =
      AsyncAction('_CarControllerBase.deleteCarMapa', context: context);

  @override
  Future<bool> deleteCarMapa({required String id}) {
    return _$deleteCarMapaAsyncAction.run(() => super.deleteCarMapa(id: id));
  }

  late final _$deleteCarAsyncAction =
      AsyncAction('_CarControllerBase.deleteCar', context: context);

  @override
  Future<bool> deleteCar({required String id}) {
    return _$deleteCarAsyncAction.run(() => super.deleteCar(id: id));
  }

  late final _$_CarControllerBaseActionController =
      ActionController(name: '_CarControllerBase', context: context);

  @override
  dynamic setTypeCar(String? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setTypeCar');
    try {
      return super.setTypeCar(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFunctionCar(String? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setFunctionCar');
    try {
      return super.setFunctionCar(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBM(OBMModel? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCia(String? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangesCar(List<CarChangeModel> value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.onChangesCar');
    try {
      return super.onChangesCar(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeChangesCar(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeChangesCar');
    try {
      return super.removeChangesCar(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addSections(ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addSections');
    try {
      return super.addSections(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic editSections(int index, ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.editSections');
    try {
      return super.editSections(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeSections(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeSections');
    try {
      return super.removeSections(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic cleanSections() {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.cleanSections');
    try {
      return super.cleanSections();
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic expansionSections(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.expansionSections');
    try {
      return super.expansionSections(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addItensSection(int index, ItemModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addItensSection');
    try {
      return super.addItensSection(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeItensSection(int index, int itemIndex) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeItensSection');
    try {
      return super.removeItensSection(index, itemIndex);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
type: ${type},
function: ${function},
cia: ${cia},
obm: ${obm},
sectionsItens: ${sectionsItens},
carChanges: ${carChanges},
enable: ${enable},
adm: ${adm}
    ''';
  }
}
