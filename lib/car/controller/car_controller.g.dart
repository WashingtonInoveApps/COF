// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarController on _CarControllerBase, Store {
  Computed<List<CarModel>>? _$carsSortsComputed;

  @override
  List<CarModel> get carsSorts =>
      (_$carsSortsComputed ??= Computed<List<CarModel>>(() => super.carsSorts,
              name: '_CarControllerBase.carsSorts'))
          .value;
  Computed<int>? _$startComputed;

  @override
  int get start => (_$startComputed ??=
          Computed<int>(() => super.start, name: '_CarControllerBase.start'))
      .value;
  Computed<int>? _$endComputed;

  @override
  int get end => (_$endComputed ??=
          Computed<int>(() => super.end, name: '_CarControllerBase.end'))
      .value;
  Computed<bool>? _$btFinishComputed;

  @override
  bool get btFinish =>
      (_$btFinishComputed ??= Computed<bool>(() => super.btFinish,
              name: '_CarControllerBase.btFinish'))
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

  late final _$stepAtom =
      Atom(name: '_CarControllerBase.step', context: context);

  @override
  int get step {
    _$stepAtom.reportRead();
    return super.step;
  }

  @override
  set step(int value) {
    _$stepAtom.reportWrite(value, super.step, () {
      super.step = value;
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

  late final _$deleteAsyncAction =
      AsyncAction('_CarControllerBase.delete', context: context);

  @override
  Future<bool> delete({required String id}) {
    return _$deleteAsyncAction.run(() => super.delete(id: id));
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

  late final _$saveStatusAsyncAction =
      AsyncAction('_CarControllerBase.saveStatus', context: context);

  @override
  Future<bool> saveStatus({required CarModel car, CarStatusModel? status}) {
    return _$saveStatusAsyncAction
        .run(() => super.saveStatus(car: car, status: status));
  }

  late final _$deleteStatusAsyncAction =
      AsyncAction('_CarControllerBase.deleteStatus', context: context);

  @override
  Future<bool> deleteStatus(
      {required CarModel car, required CarStatusModel status}) {
    return _$deleteStatusAsyncAction
        .run(() => super.deleteStatus(car: car, status: status));
  }

  late final _$insertMapaAsyncAction =
      AsyncAction('_CarControllerBase.insertMapa', context: context);

  @override
  Future<bool> insertMapa({required CarMapaModel mapa}) {
    return _$insertMapaAsyncAction.run(() => super.insertMapa(mapa: mapa));
  }

  late final _$deleteMapaAsyncAction =
      AsyncAction('_CarControllerBase.deleteMapa', context: context);

  @override
  Future<bool> deleteMapa({required String id}) {
    return _$deleteMapaAsyncAction.run(() => super.deleteMapa(id: id));
  }

  late final _$_CarControllerBaseActionController =
      ActionController(name: '_CarControllerBase', context: context);

  @override
  void processStep(bool value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.processStep');
    try {
      return super.processStep(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

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
  String toString() {
    return '''
loading: ${loading},
step: ${step},
dateKmByMonth: ${dateKmByMonth},
fieldCarTypeVisible: ${fieldCarTypeVisible},
filter: ${filter},
referenceYearProblem: ${referenceYearProblem},
referenceYearTendencies: ${referenceYearTendencies},
cars: ${cars},
limit: ${limit},
page: ${page},
statusGeral: ${statusGeral},
carsSorts: ${carsSorts},
start: ${start},
end: ${end},
btFinish: ${btFinish}
    ''';
  }
}
