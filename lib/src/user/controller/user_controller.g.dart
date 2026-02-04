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

  late final _$graduationAtom =
      Atom(name: '_UserControllerBase.graduation', context: context);

  @override
  String get graduation {
    _$graduationAtom.reportRead();
    return super.graduation;
  }

  @override
  set graduation(String value) {
    _$graduationAtom.reportWrite(value, super.graduation, () {
      super.graduation = value;
    });
  }

  late final _$ciaAtom =
      Atom(name: '_UserControllerBase.cia', context: context);

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

  late final _$obmAtom =
      Atom(name: '_UserControllerBase.obm', context: context);

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

  late final _$adminAtom =
      Atom(name: '_UserControllerBase.admin', context: context);

  @override
  bool get admin {
    _$adminAtom.reportRead();
    return super.admin;
  }

  @override
  set admin(bool value) {
    _$adminAtom.reportWrite(value, super.admin, () {
      super.admin = value;
    });
  }

  late final _$adminFullAtom =
      Atom(name: '_UserControllerBase.adminFull', context: context);

  @override
  bool get adminFull {
    _$adminFullAtom.reportRead();
    return super.adminFull;
  }

  @override
  set adminFull(bool value) {
    _$adminFullAtom.reportWrite(value, super.adminFull, () {
      super.adminFull = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_UserControllerBase.save', context: context);

  @override
  Future<bool> save({required UserModel user}) {
    return _$saveAsyncAction.run(() => super.save(user: user));
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
  dynamic setGraduation(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setGraduation');
    try {
      return super.setGraduation(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAdmin(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setAdmin');
    try {
      return super.setAdmin(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAdminFull(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setAdminFull');
    try {
      return super.setAdminFull(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCia(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBM(OBMModel? value) {
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
graduation: ${graduation},
cia: ${cia},
obm: ${obm},
admin: ${admin},
adminFull: ${adminFull}
    ''';
  }
}
