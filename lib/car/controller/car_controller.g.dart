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
  Computed<List<CarServiceModel>>? _$servicesSortsComputed;

  @override
  List<CarServiceModel> get servicesSorts => (_$servicesSortsComputed ??=
          Computed<List<CarServiceModel>>(() => super.servicesSorts,
              name: '_CarControllerBase.servicesSorts'))
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
  Computed<int>? _$lengthSortingsComputed;

  @override
  int get lengthSortings =>
      (_$lengthSortingsComputed ??= Computed<int>(() => super.lengthSortings,
              name: '_CarControllerBase.lengthSortings'))
          .value;
  Computed<int>? _$startServicesComputed;

  @override
  int get startServices =>
      (_$startServicesComputed ??= Computed<int>(() => super.startServices,
              name: '_CarControllerBase.startServices'))
          .value;
  Computed<int>? _$endServicesComputed;

  @override
  int get endServices =>
      (_$endServicesComputed ??= Computed<int>(() => super.endServices,
              name: '_CarControllerBase.endServices'))
          .value;
  Computed<int>? _$lengthServicesSortingsComputed;

  @override
  int get lengthServicesSortings => (_$lengthServicesSortingsComputed ??=
          Computed<int>(() => super.lengthServicesSortings,
              name: '_CarControllerBase.lengthServicesSortings'))
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

  late final _$referenceDateDashboardAtom =
      Atom(name: '_CarControllerBase.referenceDateDashboard', context: context);

  @override
  DateTime get referenceDateDashboard {
    _$referenceDateDashboardAtom.reportRead();
    return super.referenceDateDashboard;
  }

  @override
  set referenceDateDashboard(DateTime value) {
    _$referenceDateDashboardAtom
        .reportWrite(value, super.referenceDateDashboard, () {
      super.referenceDateDashboard = value;
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

  late final _$servicesAtom =
      Atom(name: '_CarControllerBase.services', context: context);

  @override
  ObservableList<CarServiceModel> get services {
    _$servicesAtom.reportRead();
    return super.services;
  }

  @override
  set services(ObservableList<CarServiceModel> value) {
    _$servicesAtom.reportWrite(value, super.services, () {
      super.services = value;
    });
  }

  late final _$checklistKMByMonthAtom =
      Atom(name: '_CarControllerBase.checklistKMByMonth', context: context);

  @override
  ObservableList<ChecklistModel> get checklistKMByMonth {
    _$checklistKMByMonthAtom.reportRead();
    return super.checklistKMByMonth;
  }

  @override
  set checklistKMByMonth(ObservableList<ChecklistModel> value) {
    _$checklistKMByMonthAtom.reportWrite(value, super.checklistKMByMonth, () {
      super.checklistKMByMonth = value;
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
  Future<bool> save(
      {required CarModel car,
      required List<FileModel?> images,
      required List<OtherChangeModel> others,
      required List<FileModel> deletedFiles}) {
    return _$saveAsyncAction.run(() => super.save(
        car: car, images: images, others: others, deletedFiles: deletedFiles));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_CarControllerBase.delete', context: context);

  @override
  Future<bool> delete({required CarModel car}) {
    return _$deleteAsyncAction.run(() => super.delete(car: car));
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
  Future<bool> saveStatus(
      {required CarModel car, required CarStatusModel status}) {
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

  late final _$saveServiceAsyncAction =
      AsyncAction('_CarControllerBase.saveService', context: context);

  @override
  Future<void> saveService({required CarServiceModel service}) {
    return _$saveServiceAsyncAction
        .run(() => super.saveService(service: service));
  }

  late final _$deleteServiceAsyncAction =
      AsyncAction('_CarControllerBase.deleteService', context: context);

  @override
  Future<void> deleteService({required CarServiceModel service}) {
    return _$deleteServiceAsyncAction
        .run(() => super.deleteService(service: service));
  }

  late final _$_CarControllerBaseActionController =
      ActionController(name: '_CarControllerBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCarServices(List<CarServiceModel> value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setCarServices');
    try {
      return super.setCarServices(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

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
  void setChecklistKMByMonth(List<ChecklistModel> value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setChecklistKMByMonth');
    try {
      return super.setChecklistKMByMonth(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setStatusGeral(List<CarStatusModel> list) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setStatusGeral');
    try {
      return super.setStatusGeral(list);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeFilter(String? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCars(List<CarModel> values) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setCars');
    try {
      return super.setCars(values);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReferenceDateDashboard(DateTime? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setReferenceDateDashboard');
    try {
      return super.setReferenceDateDashboard(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLimit(int? value) {
    final _$actionInfo = _$_CarControllerBaseActionController.startAction(
        name: '_CarControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_CarControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int value) {
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
referenceDateDashboard: ${referenceDateDashboard},
cars: ${cars},
services: ${services},
checklistKMByMonth: ${checklistKMByMonth},
limit: ${limit},
page: ${page},
statusGeral: ${statusGeral},
carsSorts: ${carsSorts},
servicesSorts: ${servicesSorts},
start: ${start},
end: ${end},
lengthSortings: ${lengthSortings},
startServices: ${startServices},
endServices: ${endServices},
lengthServicesSortings: ${lengthServicesSortings},
btFinish: ${btFinish}
    ''';
  }
}
