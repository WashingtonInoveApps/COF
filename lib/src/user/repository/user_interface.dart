import 'package:bsu_control/model/user_model.dart';

abstract class IUserRepository {
  Future<bool> create({required UserModel user, required String password});
  Future<bool> update({required UserModel user});
  Future<bool> delete({required UserModel user});
}
