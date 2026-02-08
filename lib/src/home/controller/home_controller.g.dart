// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeControllerBase, Store {
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

  late final _$_HomeControllerBaseActionController =
      ActionController(name: '_HomeControllerBase', context: context);

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
  dynamic setDateStart(DateTime? value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setDateStart');
    try {
      return super.setDateStart(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateFinish(DateTime? value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setDateFinish');
    try {
      return super.setDateFinish(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
isOperacionalToday: ${isOperacionalToday},
date: ${date},
dateReferenceStart: ${dateReferenceStart},
dateReferenceFinish: ${dateReferenceFinish}
    ''';
  }
}
