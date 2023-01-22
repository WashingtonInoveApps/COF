// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ExchangeController on _ExchangeControllerBase, Store {
  Computed<List<ExchangeModel>>? _$exhangesSortComputed;

  @override
  List<ExchangeModel> get exhangesSort => (_$exhangesSortComputed ??=
          Computed<List<ExchangeModel>>(() => super.exhangesSort,
              name: '_ExchangeControllerBase.exhangesSort'))
      .value;

  late final _$loadingAtom =
      Atom(name: '_ExchangeControllerBase.loading', context: context);

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

  late final _$checkConfirmAtom =
      Atom(name: '_ExchangeControllerBase.checkConfirm', context: context);

  @override
  bool get checkConfirm {
    _$checkConfirmAtom.reportRead();
    return super.checkConfirm;
  }

  @override
  set checkConfirm(bool value) {
    _$checkConfirmAtom.reportWrite(value, super.checkConfirm, () {
      super.checkConfirm = value;
    });
  }

  late final _$requestedAtom =
      Atom(name: '_ExchangeControllerBase.requested', context: context);

  @override
  UserModel? get requested {
    _$requestedAtom.reportRead();
    return super.requested;
  }

  @override
  set requested(UserModel? value) {
    _$requestedAtom.reportWrite(value, super.requested, () {
      super.requested = value;
    });
  }

  late final _$exchangesAtom =
      Atom(name: '_ExchangeControllerBase.exchanges', context: context);

  @override
  ObservableList<ExchangeModel> get exchanges {
    _$exchangesAtom.reportRead();
    return super.exchanges;
  }

  @override
  set exchanges(ObservableList<ExchangeModel> value) {
    _$exchangesAtom.reportWrite(value, super.exchanges, () {
      super.exchanges = value;
    });
  }

  late final _$referenceDateAtom =
      Atom(name: '_ExchangeControllerBase.referenceDate', context: context);

  @override
  DateTime get referenceDate {
    _$referenceDateAtom.reportRead();
    return super.referenceDate;
  }

  @override
  set referenceDate(DateTime value) {
    _$referenceDateAtom.reportWrite(value, super.referenceDate, () {
      super.referenceDate = value;
    });
  }

  late final _$dateFirstAtom =
      Atom(name: '_ExchangeControllerBase.dateFirst', context: context);

  @override
  DateTime get dateFirst {
    _$dateFirstAtom.reportRead();
    return super.dateFirst;
  }

  @override
  set dateFirst(DateTime value) {
    _$dateFirstAtom.reportWrite(value, super.dateFirst, () {
      super.dateFirst = value;
    });
  }

  late final _$dateLastAtom =
      Atom(name: '_ExchangeControllerBase.dateLast', context: context);

  @override
  DateTime get dateLast {
    _$dateLastAtom.reportRead();
    return super.dateLast;
  }

  @override
  set dateLast(DateTime value) {
    _$dateLastAtom.reportWrite(value, super.dateLast, () {
      super.dateLast = value;
    });
  }

  late final _$exchangeVerifyAtom =
      Atom(name: '_ExchangeControllerBase.exchangeVerify', context: context);

  @override
  ExchangeModel? get exchangeVerify {
    _$exchangeVerifyAtom.reportRead();
    return super.exchangeVerify;
  }

  @override
  set exchangeVerify(ExchangeModel? value) {
    _$exchangeVerifyAtom.reportWrite(value, super.exchangeVerify, () {
      super.exchangeVerify = value;
    });
  }

  late final _$verifyFileAsyncAction =
      AsyncAction('_ExchangeControllerBase.verifyFile', context: context);

  @override
  Future<ExchangeModel?> verifyFile({required String token}) {
    return _$verifyFileAsyncAction.run(() => super.verifyFile(token: token));
  }

  late final _$saveAsyncAction =
      AsyncAction('_ExchangeControllerBase.save', context: context);

  @override
  Future<bool> save({required ExchangeModel exchange}) {
    return _$saveAsyncAction.run(() => super.save(exchange: exchange));
  }

  late final _$updateAsyncAction =
      AsyncAction('_ExchangeControllerBase.update', context: context);

  @override
  Future<bool> update({required ExchangeModel exchange}) {
    return _$updateAsyncAction.run(() => super.update(exchange: exchange));
  }

  late final _$onDownloadAsyncAction =
      AsyncAction('_ExchangeControllerBase.onDownload', context: context);

  @override
  Future<void> onDownload({required String id}) {
    return _$onDownloadAsyncAction.run(() => super.onDownload(id: id));
  }

  late final _$_ExchangeControllerBaseActionController =
      ActionController(name: '_ExchangeControllerBase', context: context);

  @override
  dynamic setExchanges(List<ExchangeModel> value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setExchanges');
    try {
      return super.setExchanges(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setRequested(UserModel? value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setRequested');
    try {
      return super.setRequested(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateFirst(DateTime value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setDateFirst');
    try {
      return super.setDateFirst(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReferenceDate(DateTime value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setReferenceDate');
    try {
      return super.setReferenceDate(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCheckConfirm(bool? value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setCheckConfirm');
    try {
      return super.setCheckConfirm(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDateLast(DateTime value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setDateLast');
    try {
      return super.setDateLast(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setExchangeVerify(ExchangeModel? value) {
    final _$actionInfo = _$_ExchangeControllerBaseActionController.startAction(
        name: '_ExchangeControllerBase.setExchangeVerify');
    try {
      return super.setExchangeVerify(value);
    } finally {
      _$_ExchangeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
checkConfirm: ${checkConfirm},
requested: ${requested},
exchanges: ${exchanges},
referenceDate: ${referenceDate},
dateFirst: ${dateFirst},
dateLast: ${dateLast},
exchangeVerify: ${exchangeVerify},
exhangesSort: ${exhangesSort}
    ''';
  }
}
