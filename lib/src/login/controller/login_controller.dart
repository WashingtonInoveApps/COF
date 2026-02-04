import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/db.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:mobx/mobx.dart';

import '../repository/login_interface.dart';
import '../repository/login_repository.dart';

part 'login_controller.g.dart';

// ignore: library_private_types_in_public_api
class LoginController = _LoginControllerBase with _$LoginController;

enum LoginState { done, sucess, reset, request }

abstract class _LoginControllerBase with Store {
  final AppController app;
  late ILoginRepository repository;

  _LoginControllerBase({required this.app}) {
    repository = LoginRepository(
        appID: app.appID, endpoint: app.endpoint, test: app.test);
  }

  @observable
  bool loading = false;

  @observable
  LoginState state = LoginState.done;

  @action
  Future<bool> loginController(Function(String) onEmail) async {
    loading = true;

    final result = await DBController.get(tag: 'user');

    if (result == null) {
      loading = false;
      return false;
    }

    final user = UserModel.fromMap(result);
    onEmail.call(user.email);

    if (!(await currentUser(acessToken: user.acessToken))) {
      loading = false;
      return false;
    }

    loading = false;
    return true;
  }

  @action
  setLoading(bool value) => loading = value;

  @action
  Future<bool> initialization({required UserModel user}) async {
    try {
      loading = true;
      await DBController.save(tag: 'user', value: user.toJson());

      if (!user.enable) {
        loading = false;
        throw Exception('Usuário sem permissão de acesso,contate o suporte.');
      }

      app.setUser(user);

      await app.getOBMs();
      await repository.updateToken(
          userID: user.id ?? '', token: user.acessToken);

      loading = false;
      return true;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> currentUser({required String acessToken}) async {
    try {
      final result = await repository.currentUser(acessToken: acessToken);

      if (result == null) {
        state = LoginState.done;
        return false;
      }

      return await initialization(user: result);
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<bool> login({required String email, required String senha}) async {
    try {
      loading = true;
      final result = await repository.login(email: email, senha: senha);

      if (result == null) {
        loading = false;
        return false;
      }

      return await initialization(user: result);
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  void cancelResetPassword() {
    state = LoginState.done;
  }

  @action
  Future<bool> verifyCodePassword({required String code}) async {
    try {
      loading = true;
      final result = await repository.verifyCodePassword(code: code);
      loading = false;

      if (result == null) return false;

      state = LoginState.reset;
      return true;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> resetPassword({required String password}) async {
    try {
      loading = true;
      final result = await repository.resetPassword(
          password: password, userID: app.user.id ?? '');
      loading = false;

      if (result) state = LoginState.done;

      return result;
    } catch (e) {
      loading = false;
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
      rethrow;
    }
  }
}
