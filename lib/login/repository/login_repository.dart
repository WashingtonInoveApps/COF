import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/login/repository/login_interface.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRepository extends APIClient implements ILoginRepository {
  LoginRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<UserModel?> login(
      {required String email, required String senha}) async {
    try {
      final response = await onRequest(
          path: 'sign',
          data: {'email': email, 'password': senha},
          method: 'POST');

      if (response.statusCode == 200) {
        final user = UserModel.fromMap(response.data);

        await FirebaseAuth.instance.signInWithCustomToken(user.acessToken);
        return user;
      }

      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> currentUser({required String acessToken}) async {
    try {
      final response = await onRequest(
          path: 'login/verify',
          data: {'acessToken': acessToken},
          method: 'POST');

      final user = UserModel.fromMap(response.data);
      await FirebaseAuth.instance.signInWithCustomToken(user.acessToken);
      await updateToken(userID: user.id ?? '', token: user.acessToken);

      return user;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> requestResetPassword(
      {required String email, required String enterprise}) async {
    try {
      final result = await onRequest(
          path: 'login/reset',
          method: 'GET',
          params: {'email': email, 'enterprise': enterprise});

      if (result.statusCode == 200) return true;

      return false;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> verifyCodePassword({required String code}) async {
    try {
      final result = await onRequest(
          path: 'login/reset/verify', method: 'GET', params: {'code': code});
      if (result.statusCode == 200) return result.data['userID'];

      return null;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(
      {required String password, required String userID}) async {
    try {
      final result = await onRequest(
          path: 'login/reset',
          method: 'POST',
          data: {'password': password, 'userID': userID});

      if (result.statusCode == 200) return true;

      return false;
    } on DioException catch (e) {
      throw e.response?.data['message'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateToken(
      {required String userID, required String token}) async {
    try {
      await colUsers.doc(userID).update({'acessToken': token});
      return;
    } catch (e) {
      return;
    }
  }
}
