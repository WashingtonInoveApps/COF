// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
  Computed<List<CheckListModel>>? _$checklistPeriodSortComputed;

  @override
  List<CheckListModel> get checklistPeriodSort =>
      (_$checklistPeriodSortComputed ??= Computed<List<CheckListModel>>(
              () => super.checklistPeriodSort,
              name: '_HomeControllerBase.checklistPeriodSort'))
          .value;

  late final _$loadingAtom =
      Atom(name: '_HomeControllerBase.loading', context: context);

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

  late final _$isOperacionalTodayAtom =
      Atom(name: '_HomeControllerBase.isOperacionalToday', context: context);

  @override
  bool get isOperacionalToday {
    _$isOperacionalTodayAtom.reportRead();
    return super.isOperacionalToday;
  }

  @override
  set isOperacionalToday(bool value) {
    _$isOperacionalTodayAtom.reportWrite(value, super.isOperacionalToday, () {
      super.isOperacionalToday = value;
    });
  }

  late final _$checklistsPeriodAtom =
      Atom(name: '_HomeControllerBase.checklistsPeriod', context: context);

  @override
  List<CheckListModel> get checklistsPeriod {
    _$checklistsPeriodAtom.reportRead();
    return super.checklistsPeriod;
  }

  @override
  set checklistsPeriod(List<CheckListModel> value) {
    _$checklistsPeriodAtom.reportWrite(value, super.checklistsPeriod, () {
      super.checklistsPeriod = value;
    });
  }

  late final _$dateAtom =
      Atom(name: '_HomeControllerBase.date', context: context);

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

  late final _$dateReferenceStartAtom =
      Atom(name: '_HomeControllerBase.dateReferenceStart', context: context);

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

  late final _$dateReferenceFinishAtom =
      Atom(name: '_HomeControllerBase.dateReferenceFinish', context: context);

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

  late final _$filterAtom =
      Atom(name: '_HomeControllerBase.filter', context: context);

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
      Atom(name: '_HomeControllerBase.limit', context: context);

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
      Atom(name: '_HomeControllerBase.page', context: context);

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

  late final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase', context: context);

  @override
  Stream<List<CheckListModel>> listenChecklistPeriod(
      {required DateTime dateStart, required DateTime dateFinish}) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.listenChecklistPeriod');
    try {
      return super
          .listenChecklistPeriod(dateStart: dateStart, dateFinish: dateFinish);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateRangeChecklist(
      {required DateTime dateStart, required DateTime dateFinish}) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setDateRangeChecklist');
    try {
      return super
          .setDateRangeChecklist(dateStart: dateStart, dateFinish: dateFinish);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setChecklistPeriod(List<CheckListModel> value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setChecklistPeriod');
    try {
      return super.setChecklistPeriod(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDate(DateTime value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setDate');
    try {
      return super.setDate(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangeFilter(String? value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLimit(int? value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPage(int value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
isOperacionalToday: ${isOperacionalToday},
checklistsPeriod: ${checklistsPeriod},
date: ${date},
dateReferenceStart: ${dateReferenceStart},
dateReferenceFinish: ${dateReferenceFinish},
filter: ${filter},
limit: ${limit},
page: ${page},
checklistPeriodSort: ${checklistPeriodSort}
    ''';
  }
}
