// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserController on _UserControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_UserControllerBase.loading', context: context);

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

  late final _$graduacaoAtom =
      Atom(name: '_UserControllerBase.graduacao', context: context);

  @override
  String get graduacao {
    _$graduacaoAtom.reportRead();
    return super.graduacao;
  }

  @override
  set graduacao(String value) {
    _$graduacaoAtom.reportWrite(value, super.graduacao, () {
      super.graduacao = value;
    });
  }

  late final _$obmAtom =
      Atom(name: '_UserControllerBase.obm', context: context);

  @override
  String get obm {
    _$obmAtom.reportRead();
    return super.obm;
  }

  @override
  set obm(String value) {
    _$obmAtom.reportWrite(value, super.obm, () {
      super.obm = value;
    });
  }

  late final _$isSamuAtom =
      Atom(name: '_UserControllerBase.isSamu', context: context);

  @override
  bool get isSamu {
    _$isSamuAtom.reportRead();
    return super.isSamu;
  }

  @override
  set isSamu(bool value) {
    _$isSamuAtom.reportWrite(value, super.isSamu, () {
      super.isSamu = value;
    });
  }

  late final _$createAsyncAction =
      AsyncAction('_UserControllerBase.create', context: context);

  @override
  Future<bool> create({required UserModel user, bool update = false}) {
    return _$createAsyncAction
        .run(() => super.create(user: user, update: update));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_UserControllerBase.delete', context: context);

  @override
  Future<bool> delete({required UserModel user}) {
    return _$deleteAsyncAction.run(() => super.delete(user: user));
  }

  late final _$updateAsyncAction =
      AsyncAction('_UserControllerBase.update', context: context);

  @override
  Future<bool> update({required UserModel user}) {
    return _$updateAsyncAction.run(() => super.update(user: user));
  }

  late final _$_UserControllerBaseActionController =
      ActionController(name: '_UserControllerBase', context: context);

  @override
  dynamic setGraduacao(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setGraduacao');
    try {
      return super.setGraduacao(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setIsSamu(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setIsSamu');
    try {
      return super.setIsSamu(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBM(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
graduacao: ${graduacao},
obm: ${obm},
isSamu: ${isSamu}
    ''';
  }
}
