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
  Computed<List<CarModel>>? _$carsSortsComputed;

  @override
  List<CarModel> get carsSorts =>
      (_$carsSortsComputed ??= Computed<List<CarModel>>(() => super.carsSorts,
              name: '_CarControllerBase.carsSorts'))
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

  late final _$dateKmByMonthAtom =
      Atom(name: '_CarControllerBase.dateKmByMonth', context: context);

  @override
  DateTime get dateKmByMonth {
    _$dateKmByMonthAtom.reportRead();
    return super.dateKmByMonth;
  }

  @override
  set dateKmByMonth(DateTime value) {
    _$dateKmByMonthAtom.reportWrite(value, super.dateKmByMonth, () {
      super.dateKmByMonth = value;
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

  late final _$fieldCarTypeVisibleAtom =
      Atom(name: '_CarControllerBase.fieldCarTypeVisible', context: context);

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

  late final _$filterAtom =
      Atom(name: '_CarControllerBase.filter', context: context);

  @override
  String get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(String value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$referenceYearProblemAtom =
      Atom(name: '_CarControllerBase.referenceYearProblem', context: context);

  @override
  DateTime get referenceYearProblem {
    _$referenceYearProblemAtom.reportRead();
    return super.referenceYearProblem;
  }

  @override
  set referenceYearProblem(DateTime value) {
    _$referenceYearProblemAtom.reportWrite(value, super.referenceYearProblem,
        () {
      super.referenceYearProblem = value;
    });
  }

  late final _$referenceYearTendenciesAtom = Atom(
      name: '_CarControllerBase.referenceYearTendencies', context: context);

  @override
  DateTime get referenceYearTendencies {
    _$referenceYearTendenciesAtom.reportRead();
    return super.referenceYearTendencies;
  }

  @override
  set referenceYearTendencies(DateTime value) {
    _$referenceYearTendenciesAtom
        .reportWrite(value, super.referenceYearTendencies, () {
      super.referenceYearTendencies = value;
    });
  }

  late final _$carsAtom =
      Atom(name: '_CarControllerBase.cars', context: context);

  @override
  ObservableList<CarModel> get cars {
    _$carsAtom.reportRead();
    return super.cars;
  }

  @override
  set cars(ObservableList<CarModel> value) {
    _$carsAtom.reportWrite(value, super.cars, () {
      super.cars = value;
    });
  }

  late final _$limitAtom =
      Atom(name: '_CarControllerBase.limit', context: context);

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$pageAtom =
      Atom(name: '_CarControllerBase.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
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

  late final _$statusGeralAtom =
      Atom(name: '_CarControllerBase.statusGeral', context: context);

  @override
  ObservableList<CarStatusModel> get statusGeral {
    _$statusGeralAtom.reportRead();
    return super.statusGeral;
  }

  @override
  set statusGeral(ObservableList<CarStatusModel> value) {
    _$statusGeralAtom.reportWrite(value, super.statusGeral, () {
      super.statusGeral = value;
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

  late final _$sectionsMaterialsAtom =
      Atom(name: '_CarControllerBase.sectionsMaterials', context: context);

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

  late final _$setDateKmByMonthAsyncAction =
      AsyncAction('_CarControllerBase.setDateKmByMonth', context: context);

  @override
  Future<void> setDateKmByMonth(DateTime value) {
    return _$setDateKmByMonthAsyncAction
        .run(() => super.setDateKmByMonth(value));
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

  late final _$saveStatusCarAsyncAction =
      AsyncAction('_CarControllerBase.saveStatusCar', context: context);

  @override
  Future<bool> saveStatusCar({required CarModel car, CarStatusModel? status}) {
    return _$saveStatusCarAsyncAction
        .run(() => super.saveStatusCar(car: car, status: status));
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
  dynamic setStatusGeral(List<CarStatusModel> list) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setStatusGeral');
    try {
      return super.setStatusGeral(list);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangeFilter(String? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

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
  dynamic setCars(List<CarModel> values) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setCars');
    try {
      return super.setCars(values);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReferenceYearProblem(DateTime? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setReferenceYearProblem');
    try {
      return super.setReferenceYearProblem(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReferenceYearTendencies(DateTime? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setReferenceYearTendencies');
    try {
      return super.setReferenceYearTendencies(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLimit(int? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPage(int value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setPage');
    try {
      return super.setPage(value);
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
  dynamic addSectionsItens(ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addSectionsItens');
    try {
      return super.addSectionsItens(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic editSectionsItens(int index, ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.editSectionsItens');
    try {
      return super.editSectionsItens(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeSectionsItens(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeSectionsItens');
    try {
      return super.removeSectionsItens(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic cleanSectionsItens() {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.cleanSectionsItens');
    try {
      return super.cleanSectionsItens();
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addSectionsMaterials(ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addSectionsMaterials');
    try {
      return super.addSectionsMaterials(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic editSectionsMaterials(int index, ItensChangesModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.editSectionsMaterials');
    try {
      return super.editSectionsMaterials(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeSectionsMaterials(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeSectionsMaterials');
    try {
      return super.removeSectionsMaterials(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic cleanSectionsMaterials() {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.cleanSectionsMaterials');
    try {
      return super.cleanSectionsMaterials();
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic expansionSectionsItens(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.expansionSectionsItens');
    try {
      return super.expansionSectionsItens(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addSectionItens(int index, ItemModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addSectionItens');
    try {
      return super.addSectionItens(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeSectionItens(int index, int itemIndex) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeSectionItens');
    try {
      return super.removeSectionItens(index, itemIndex);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic expansionSectionsMaterials(int index) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.expansionSectionsMaterials');
    try {
      return super.expansionSectionsMaterials(index);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addSectionMaterials(int index, ItemModel value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.addSectionMaterials');
    try {
      return super.addSectionMaterials(index, value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeSectionMaterials(int index, int itemIndex) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.removeSectionMaterials');
    try {
      return super.removeSectionMaterials(index, itemIndex);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
type: ${type},
dateKmByMonth: ${dateKmByMonth},
function: ${function},
fieldCarTypeVisible: ${fieldCarTypeVisible},
cia: ${cia},
filter: ${filter},
referenceYearProblem: ${referenceYearProblem},
referenceYearTendencies: ${referenceYearTendencies},
cars: ${cars},
limit: ${limit},
page: ${page},
obm: ${obm},
statusGeral: ${statusGeral},
sectionsItens: ${sectionsItens},
sectionsMaterials: ${sectionsMaterials},
carChanges: ${carChanges},
enable: ${enable},
carsSorts: ${carsSorts},
adm: ${adm}
    ''';
  }
}
