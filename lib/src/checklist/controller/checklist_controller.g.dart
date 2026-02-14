// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckListController on _CheckListControllerBase, Store {
  Computed<bool>? _$btFinishComputed;

  @override
  bool get btFinish =>
      (_$btFinishComputed ??= Computed<bool>(() => super.btFinish,
              name: '_CheckListControllerBase.btFinish'))
          .value;
  Computed<List<CarModel>>? _$carsComputed;

  @override
  List<CarModel> get cars =>
      (_$carsComputed ??= Computed<List<CarModel>>(() => super.cars,
              name: '_CheckListControllerBase.cars'))
          .value;
  Computed<List<CheckListModel>>? _$myChecklistUserSortComputed;

  @override
  List<CheckListModel> get myChecklistUserSort =>
      (_$myChecklistUserSortComputed ??= Computed<List<CheckListModel>>(
              () => super.myChecklistUserSort,
              name: '_CheckListControllerBase.myChecklistUserSort'))
          .value;
  Computed<List<String>>? _$prefixsComputed;

  @override
  List<String> get prefixs =>
      (_$prefixsComputed ??= Computed<List<String>>(() => super.prefixs,
              name: '_CheckListControllerBase.prefixs'))
          .value;

  late final _$loadingAtom =
      Atom(name: '_CheckListControllerBase.loading', context: context);

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

  late final _$carChangesAtom =
      Atom(name: '_CheckListControllerBase.carChanges', context: context);

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

  late final _$itensAtom =
      Atom(name: '_CheckListControllerBase.itens', context: context);

  @override
  ObservableList<ItensChangesModel> get itens {
    _$itensAtom.reportRead();
    return super.itens;
  }

  @override
  set itens(ObservableList<ItensChangesModel> value) {
    _$itensAtom.reportWrite(value, super.itens, () {
      super.itens = value;
    });
  }

  late final _$myChecklistUserAtom =
      Atom(name: '_CheckListControllerBase.myChecklistUser', context: context);

  @override
  ObservableList<CheckListModel> get myChecklistUser {
    _$myChecklistUserAtom.reportRead();
    return super.myChecklistUser;
  }

  @override
  set myChecklistUser(ObservableList<CheckListModel> value) {
    _$myChecklistUserAtom.reportWrite(value, super.myChecklistUser, () {
      super.myChecklistUser = value;
    });
  }

  late final _$materialsAtom =
      Atom(name: '_CheckListControllerBase.materials', context: context);

  @override
  ObservableList<ItensChangesModel> get materials {
    _$materialsAtom.reportRead();
    return super.materials;
  }

  @override
  set materials(ObservableList<ItensChangesModel> value) {
    _$materialsAtom.reportWrite(value, super.materials, () {
      super.materials = value;
    });
  }

  late final _$materialsConsumableAtom = Atom(
      name: '_CheckListControllerBase.materialsConsumable', context: context);

  @override
  ObservableList<ItensChangesModel> get materialsConsumable {
    _$materialsConsumableAtom.reportRead();
    return super.materialsConsumable;
  }

  @override
  set materialsConsumable(ObservableList<ItensChangesModel> value) {
    _$materialsConsumableAtom.reportWrite(value, super.materialsConsumable, () {
      super.materialsConsumable = value;
    });
  }

  late final _$outhersAtom =
      Atom(name: '_CheckListControllerBase.outhers', context: context);

  @override
  ObservableList<ChecklistOutherChange> get outhers {
    _$outhersAtom.reportRead();
    return super.outhers;
  }

  @override
  set outhers(ObservableList<ChecklistOutherChange> value) {
    _$outhersAtom.reportWrite(value, super.outhers, () {
      super.outhers = value;
    });
  }

  late final _$teamsAtom =
      Atom(name: '_CheckListControllerBase.teams', context: context);

  @override
  ObservableList<String> get teams {
    _$teamsAtom.reportRead();
    return super.teams;
  }

  @override
  set teams(ObservableList<String> value) {
    _$teamsAtom.reportWrite(value, super.teams, () {
      super.teams = value;
    });
  }

  late final _$materialsConsumedUsedAtom = Atom(
      name: '_CheckListControllerBase.materialsConsumedUsed', context: context);

  @override
  ObservableList<ItemModel> get materialsConsumedUsed {
    _$materialsConsumedUsedAtom.reportRead();
    return super.materialsConsumedUsed;
  }

  @override
  set materialsConsumedUsed(ObservableList<ItemModel> value) {
    _$materialsConsumedUsedAtom.reportWrite(value, super.materialsConsumedUsed,
        () {
      super.materialsConsumedUsed = value;
    });
  }

  late final _$dateAtom =
      Atom(name: '_CheckListControllerBase.date', context: context);

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

  late final _$dateReferenceStartAtom = Atom(
      name: '_CheckListControllerBase.dateReferenceStart', context: context);

  @override
  DateTime get dateReferenceStart {
    _$dateReferenceStartAtom.reportRead();
    return super.dateReferenceStart;
  }

  @override
  set dateReferenceStart(DateTime value) {
    _$dateReferenceStartAtom.reportWrite(value, super.dateReferenceStart, () {
      super.dateReferenceStart = value;
    });
  }

  late final _$dateReferenceFinishAtom = Atom(
      name: '_CheckListControllerBase.dateReferenceFinish', context: context);

  @override
  DateTime get dateReferenceFinish {
    _$dateReferenceFinishAtom.reportRead();
    return super.dateReferenceFinish;
  }

  @override
  set dateReferenceFinish(DateTime value) {
    _$dateReferenceFinishAtom.reportWrite(value, super.dateReferenceFinish, () {
      super.dateReferenceFinish = value;
    });
  }

  late final _$dateStartConfigAtom =
      Atom(name: '_CheckListControllerBase.dateStartConfig', context: context);

  @override
  DateTime get dateStartConfig {
    _$dateStartConfigAtom.reportRead();
    return super.dateStartConfig;
  }

  @override
  set dateStartConfig(DateTime value) {
    _$dateStartConfigAtom.reportWrite(value, super.dateStartConfig, () {
      super.dateStartConfig = value;
    });
  }

  late final _$dateFinishConfigAtom =
      Atom(name: '_CheckListControllerBase.dateFinishConfig', context: context);

  @override
  DateTime get dateFinishConfig {
    _$dateFinishConfigAtom.reportRead();
    return super.dateFinishConfig;
  }

  @override
  set dateFinishConfig(DateTime value) {
    _$dateFinishConfigAtom.reportWrite(value, super.dateFinishConfig, () {
      super.dateFinishConfig = value;
    });
  }

  late final _$dateMyChecklistAtom =
      Atom(name: '_CheckListControllerBase.dateMyChecklist', context: context);

  @override
  DateTime get dateMyChecklist {
    _$dateMyChecklistAtom.reportRead();
    return super.dateMyChecklist;
  }

  @override
  set dateMyChecklist(DateTime value) {
    _$dateMyChecklistAtom.reportWrite(value, super.dateMyChecklist, () {
      super.dateMyChecklist = value;
    });
  }

  late final _$prefixAtom =
      Atom(name: '_CheckListControllerBase.prefix', context: context);

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

  late final _$enableAtom =
      Atom(name: '_CheckListControllerBase.enable', context: context);

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

  late final _$stepAtom =
      Atom(name: '_CheckListControllerBase.step', context: context);

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

  late final _$contactAtom =
      Atom(name: '_CheckListControllerBase.contact', context: context);

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

  late final _$ciaAtom =
      Atom(name: '_CheckListControllerBase.cia', context: context);

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

  late final _$teamAtom =
      Atom(name: '_CheckListControllerBase.team', context: context);

  @override
  String get team {
    _$teamAtom.reportRead();
    return super.team;
  }

  @override
  set team(String value) {
    _$teamAtom.reportWrite(value, super.team, () {
      super.team = value;
    });
  }

  late final _$pbAtom =
      Atom(name: '_CheckListControllerBase.pb', context: context);

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
      Atom(name: '_CheckListControllerBase.obs', context: context);

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

  late final _$startKMAtom =
      Atom(name: '_CheckListControllerBase.startKM', context: context);

  @override
  String get startKM {
    _$startKMAtom.reportRead();
    return super.startKM;
  }

  @override
  set startKM(String value) {
    _$startKMAtom.reportWrite(value, super.startKM, () {
      super.startKM = value;
    });
  }

  late final _$endKMAtom =
      Atom(name: '_CheckListControllerBase.endKM', context: context);

  @override
  String get endKM {
    _$endKMAtom.reportRead();
    return super.endKM;
  }

  @override
  set endKM(String value) {
    _$endKMAtom.reportWrite(value, super.endKM, () {
      super.endKM = value;
    });
  }

  late final _$filterAtom =
      Atom(name: '_CheckListControllerBase.filter', context: context);

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

  late final _$limitAtom =
      Atom(name: '_CheckListControllerBase.limit', context: context);

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
      Atom(name: '_CheckListControllerBase.page', context: context);

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

  late final _$oilAtom =
      Atom(name: '_CheckListControllerBase.oil', context: context);

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
      Atom(name: '_CheckListControllerBase.hidra', context: context);

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
      Atom(name: '_CheckListControllerBase.fuel', context: context);

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

  late final _$obmAtom =
      Atom(name: '_CheckListControllerBase.obm', context: context);

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

  late final _$frAtom =
      Atom(name: '_CheckListControllerBase.fr', context: context);

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
      Atom(name: '_CheckListControllerBase.arref', context: context);

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

  late final _$carAtom =
      Atom(name: '_CheckListControllerBase.car', context: context);

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

  late final _$saveAsyncAction =
      AsyncAction('_CheckListControllerBase.save', context: context);

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$finishAsyncAction =
      AsyncAction('_CheckListControllerBase.finish', context: context);

  @override
  Future<bool> finish({required CheckListModel checklist, Uint8List? image}) {
    return _$finishAsyncAction
        .run(() => super.finish(checklist: checklist, image: image));
  }

  late final _$deleteChecklistAsyncAction =
      AsyncAction('_CheckListControllerBase.deleteChecklist', context: context);

  @override
  Future<bool> deleteChecklist({required CheckListModel checklist}) {
    return _$deleteChecklistAsyncAction
        .run(() => super.deleteChecklist(checklist: checklist));
  }

  late final _$_CheckListControllerBaseActionController =
      ActionController(name: '_CheckListControllerBase', context: context);

  @override
  dynamic initController(CheckListModel? init) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.initController');
    try {
      return super.initController(init);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeDate(DateTime? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeDate');
    try {
      return super.changeDate(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateMyChecklist(DateTime? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setDateMyChecklist');
    try {
      return super.setDateMyChecklist(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setDateRangeChecklist');
    try {
      return super
          .setDateRangeChecklist(dateStart: dateStart, dateFinish: dateFinish);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cleanExibitionConfig() {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.cleanExibitionConfig');
    try {
      return super.cleanExibitionConfig();
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateStartConfig(DateTime? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setDateStartConfig');
    try {
      return super.setDateStartConfig(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateFinishConfig(DateTime? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setDateFinishConfig');
    try {
      return super.setDateFinishConfig(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setMyChecklistUser(List<CheckListModel> value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setMyChecklistUser');
    try {
      return super.setMyChecklistUser(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangeFilter(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLimit(int? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPage(int value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addOuthersChange(ChecklistOutherChange value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.addOuthersChange');
    try {
      return super.addOuthersChange(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteOuhtersChange(int index) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.deleteOuhtersChange');
    try {
      return super.deleteOuhtersChange(index);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addMaterialsConsumedUsed(List<ItemModel> values) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.addMaterialsConsumedUsed');
    try {
      return super.addMaterialsConsumedUsed(values);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteMaterialsConsumedUsed(int index) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.deleteMaterialsConsumedUsed');
    try {
      return super.deleteMaterialsConsumedUsed(index);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPrefix(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setPrefix');
    try {
      return super.setPrefix(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBM(OBMModel? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic processStep(bool value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.processStep');
    try {
      return super.processStep(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCia(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTeam(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setTeam');
    try {
      return super.setTeam(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setContact(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setContact');
    try {
      return super.setContact(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPB(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setPB');
    try {
      return super.setPB(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setKMStart(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setKMStart');
    try {
      return super.setKMStart(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBS(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setOBS');
    try {
      return super.setOBS(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOil(double? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setOil');
    try {
      return super.setOil(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHidra(double? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setHidra');
    try {
      return super.setHidra(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFuel(double? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setFuel');
    try {
      return super.setFuel(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFR(double? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setFR');
    try {
      return super.setFR(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setArref(double? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setArref');
    try {
      return super.setArref(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addCarChanges(List<CarChangeModel> value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.addCarChanges');
    try {
      return super.addCarChanges(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeCarChanges(int index) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.removeCarChanges');
    try {
      return super.removeCarChanges(index);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeItens(ItemModel value, int indexCategory, int indexItem) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeItens');
    try {
      return super.changeItens(value, indexCategory, indexItem);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeOBSItens(String obs, int indexCategory) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeOBSItens');
    try {
      return super.changeOBSItens(obs, indexCategory);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeMaterials(ItemModel value, int indexCategory, int indexItem) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeMaterials');
    try {
      return super.changeMaterials(value, indexCategory, indexItem);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<ItensChangesModel> changeList(
      {required List<ItensChangesModel> list,
      required ItemModel value,
      required int indexSection,
      required int indexItem}) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeList');
    try {
      return super.changeList(
          list: list,
          value: value,
          indexSection: indexSection,
          indexItem: indexItem);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeOBS(
      {required List<ItensChangesModel> list,
      required String obs,
      required int indexSection}) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeOBS');
    try {
      return super.changeOBS(list: list, obs: obs, indexSection: indexSection);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeOBSMaterials(String obs, int indexCategory) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.changeOBSMaterials');
    try {
      return super.changeOBSMaterials(obs, indexCategory);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
carChanges: ${carChanges},
itens: ${itens},
myChecklistUser: ${myChecklistUser},
materials: ${materials},
materialsConsumable: ${materialsConsumable},
outhers: ${outhers},
teams: ${teams},
materialsConsumedUsed: ${materialsConsumedUsed},
date: ${date},
dateReferenceStart: ${dateReferenceStart},
dateReferenceFinish: ${dateReferenceFinish},
dateStartConfig: ${dateStartConfig},
dateFinishConfig: ${dateFinishConfig},
dateMyChecklist: ${dateMyChecklist},
prefix: ${prefix},
enable: ${enable},
step: ${step},
contact: ${contact},
cia: ${cia},
team: ${team},
pb: ${pb},
obs: ${obs},
startKM: ${startKM},
endKM: ${endKM},
filter: ${filter},
limit: ${limit},
page: ${page},
oil: ${oil},
hidra: ${hidra},
fuel: ${fuel},
obm: ${obm},
fr: ${fr},
arref: ${arref},
car: ${car},
btFinish: ${btFinish},
cars: ${cars},
myChecklistUserSort: ${myChecklistUserSort},
prefixs: ${prefixs}
    ''';
  }
}
