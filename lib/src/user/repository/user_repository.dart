import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/src/user/repository/user_interface.dart';

import '../../../model/user_model.dart';

class UserRepository extends APIClient implements IUserRepository {
  UserRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save({required UserModel user}) async {
    try {
      final doc = colUsers.doc(user.id);
      user.id = doc.id;

      await doc.set(user.toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> update({required UserModel user}) async {
    try {
      await colUsers.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> delete({required UserModel user}) async {
    try {
      await colUsers.doc(user.id).delete();
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
