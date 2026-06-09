import 'package:bsu_control/model/user_model.dart';

abstract class ILoginRepository {
  Future<UserModel?> login({required String email, required String senha});
  Future<UserModel?> currentUser({required String acessToken});

  Future<bool> requestResetPassword(
      {required String email, required String enterprise});
  Future<String?> verifyCodePassword({required String code});
  Future<bool> resetPassword(
      {required String password, required String userID});
  Future<void> updateToken({required String userID, required String token});
}
