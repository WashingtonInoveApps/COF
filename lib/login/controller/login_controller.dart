import 'dart:developer';

import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../repository/login_interface.dart';
import '../repository/login_repository.dart';

part 'login_controller.g.dart';

// ignore: library_private_types_in_public_api
class LoginController = _LoginControllerBase with _$LoginController;

enum LoginState { done, sucess, reset, request }

abstract class _LoginControllerBase with Store {
  final ConfigModel config;
  late ILoginRepository repository;

  _LoginControllerBase({required this.config}) {
    repository = LoginRepository(
        appID: config.appID, endpoint: config.endpoint, test: config.test);
  }

  @observable
  bool loading = false;

  @observable
  LoginState state = LoginState.done;

  String userID = '';

  @action
  Future<UserModel?> loginInitController(Function(String) onEmail) async {
    try {
      loading = true;
      final result = await DBController.get(tag: 'user');

      if (result == null) {
        log('User: Não encontrado.');

        loading = false;
        return null;
      }

      final user = UserModel.fromMap(result);
      onEmail.call(user.email);

      log('User: ${user.toMapResume()}');

      return await currentUser(acessToken: user.acessToken);
    } catch (e) {
      loading = false;
      return null;
    }
  }

  @action
  setLoading(bool value) => loading = value;

  @action
  Future<UserModel?> currentUser({required String acessToken}) async {
    try {
      final result = await repository.currentUser(acessToken: acessToken);

      if (result == null) {
        state = LoginState.done;
        return null;
      }

      if (!result.enable) {
        throw Exception('Usuário sem permissão de acesso,contate o suporte.');
      }

      return result;
    } catch (e) {
      loading = false;
      state = LoginState.done;
      rethrow;
    }
  }

  @action
  Future<UserModel?> login(
      {required String email, required String senha}) async {
    try {
      loading = true;
      final result = await repository.login(email: email, senha: senha);

      if (result == null) {
        loading = false;
        return null;
      }

      if (!result.enable) {
        loading = false;
        state = LoginState.done;
        throw Exception('Usuário sem permissão de acesso,contate o suporte.');
      }

      await DBController.save(tag: 'user', value: result.toJson());

      return result;
    } catch (e) {
      loading = false;
      state = LoginState.done;
      rethrow;
    }
  }

  @action
  void cancelResetPassword() {
    state = LoginState.done;
  }

  @action
  Future<String?> verifyCodePassword({required String code}) async {
    try {
      loading = true;
      final result = await repository.verifyCodePassword(code: code);
      loading = false;

      if (result == null) return null;

      userID = result;
      state = LoginState.reset;
      return result;
    } catch (e) {
      loading = false;
      state = LoginState.done;
      rethrow;
    }
  }

  @action
  Future<bool> resetPassword({required String password}) async {
    try {
      loading = true;
      final result =
          await repository.resetPassword(password: password, userID: userID);
      loading = false;

      if (result) state = LoginState.done;

      return result;
    } catch (e) {
      loading = false;
      state = LoginState.done;
      rethrow;
    }
  }

  @action
  Future<bool> requestPassword({required String email}) async {
    try {
      loading = true;
      final result = await repository.requestResetPassword(
          email: email, enterprise: 'CBMCE');
      loading = false;

      if (result) state = LoginState.request;

      return result;
    } catch (e) {
      loading = false;
      state = LoginState.done;
      rethrow;
    }
  }
}
