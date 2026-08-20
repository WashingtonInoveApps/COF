// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckListController on _CheckListControllerBase, Store {
  Computed<List<ChecklistModel>>? _$myChecklistUserSortComputed;

  @override
  List<ChecklistModel> get myChecklistUserSort =>
      (_$myChecklistUserSortComputed ??= Computed<List<ChecklistModel>>(
              () => super.myChecklistUserSort,
              name: '_CheckListControllerBase.myChecklistUserSort'))
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

  late final _$myChecklistUserAtom =
      Atom(name: '_CheckListControllerBase.myChecklistUser', context: context);

  @override
  ObservableList<ChecklistModel> get myChecklistUser {
    _$myChecklistUserAtom.reportRead();
    return super.myChecklistUser;
  }

  @override
  set myChecklistUser(ObservableList<ChecklistModel> value) {
    _$myChecklistUserAtom.reportWrite(value, super.myChecklistUser, () {
      super.myChecklistUser = value;
    });
  }

  late final _$materialsConsumableAtom = Atom(
      name: '_CheckListControllerBase.materialsConsumable', context: context);

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

  late final _$saveAsyncAction =
      AsyncAction('_CheckListControllerBase.save', context: context);

  @override
  Future<bool> save({required ChecklistModel checklist}) {
    return _$saveAsyncAction.run(() => super.save(checklist: checklist));
  }

  late final _$finishAsyncAction =
      AsyncAction('_CheckListControllerBase.finish', context: context);

  @override
  Future<bool> finish({required ChecklistModel checklist, Uint8List? image}) {
    return _$finishAsyncAction
        .run(() => super.finish(checklist: checklist, image: image));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_CheckListControllerBase.delete', context: context);

  @override
  Future<bool> delete({required ChecklistModel checklist}) {
    return _$deleteAsyncAction.run(() => super.delete(checklist: checklist));
  }

  late final _$getChecklistMaterialAsyncAction = AsyncAction(
      '_CheckListControllerBase.getChecklistMaterial',
      context: context);

  @override
  Future<MaterialChecklistModel?> getChecklistMaterial(
      {required String? teamID}) {
    return _$getChecklistMaterialAsyncAction
        .run(() => super.getChecklistMaterial(teamID: teamID));
  }

  late final _$_CheckListControllerBaseActionController =
      ActionController(name: '_CheckListControllerBase', context: context);

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
  dynamic setMyChecklistUser(List<ChecklistModel> value) {
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
  void processStep(bool value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.processStep');
    try {
      return super.processStep(value);
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
myChecklistUser: ${myChecklistUser},
materialsConsumable: ${materialsConsumable},
materialsConsumedUsed: ${materialsConsumedUsed},
date: ${date},
dateReferenceStart: ${dateReferenceStart},
dateReferenceFinish: ${dateReferenceFinish},
dateStartConfig: ${dateStartConfig},
dateFinishConfig: ${dateFinishConfig},
dateMyChecklist: ${dateMyChecklist},
step: ${step},
filter: ${filter},
limit: ${limit},
page: ${page},
myChecklistUserSort: ${myChecklistUserSort}
    ''';
  }
}
