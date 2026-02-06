// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginController on _LoginControllerBase, Store {
  late final _$loadingAtom =
      Atom(name: '_LoginControllerBase.loading', context: context);

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

  late final _$stateAtom =
      Atom(name: '_LoginControllerBase.state', context: context);

  @override
  LoginState get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(LoginState value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$loginControllerAsyncAction =
      AsyncAction('_LoginControllerBase.loginController', context: context);

  @override
  Future<bool> loginController(dynamic Function(String) onEmail) {
    return _$loginControllerAsyncAction
        .run(() => super.loginController(onEmail));
  }

  late final _$initializationAsyncAction =
      AsyncAction('_LoginControllerBase.initialization', context: context);

  @override
  Future<bool> initialization({required UserModel user}) {
    return _$initializationAsyncAction
        .run(() => super.initialization(user: user));
  }

  late final _$currentUserAsyncAction =
      AsyncAction('_LoginControllerBase.currentUser', context: context);

  @override
  Future<bool> currentUser({required String acessToken}) {
    return _$currentUserAsyncAction
        .run(() => super.currentUser(acessToken: acessToken));
  }

  late final _$loginAsyncAction =
      AsyncAction('_LoginControllerBase.login', context: context);

  @override
  Future<bool> login({required String email, required String senha}) {
    return _$loginAsyncAction
        .run(() => super.login(email: email, senha: senha));
  }

  late final _$verifyCodePasswordAsyncAction =
      AsyncAction('_LoginControllerBase.verifyCodePassword', context: context);

  @override
  Future<String?> verifyCodePassword({required String code}) {
    return _$verifyCodePasswordAsyncAction
        .run(() => super.verifyCodePassword(code: code));
  }

  late final _$resetPasswordAsyncAction =
      AsyncAction('_LoginControllerBase.resetPassword', context: context);

  @override
  Future<bool> resetPassword({required String password}) {
    return _$resetPasswordAsyncAction
        .run(() => super.resetPassword(password: password));
  }

  late final _$requestPasswordAsyncAction =
      AsyncAction('_LoginControllerBase.requestPassword', context: context);

  @override
  Future<bool> requestPassword({required String email}) {
    return _$requestPasswordAsyncAction
        .run(() => super.requestPassword(email: email));
  }

  late final _$_LoginControllerBaseActionController =
      ActionController(name: '_LoginControllerBase', context: context);

  @override
  dynamic setLoading(bool value) {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void cancelResetPassword() {
    final _$actionInfo = _$_LoginControllerBaseActionController.startAction(
        name: '_LoginControllerBase.cancelResetPassword');
    try {
      return super.cancelResetPassword();
    } finally {
      _$_LoginControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
state: ${state}
    ''';
  }
}
