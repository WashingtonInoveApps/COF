import 'package:bsu_control/model/user_model.dart';

abstract class IUserRepository {
  Future<bool> save({required UserModel user});
  Future<bool> update({required UserModel user});
  Future<bool> delete({required UserModel user});
}
