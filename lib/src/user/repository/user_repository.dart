import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/src/user/repository/user_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model.dart';

class UserRepository extends APIClient implements IUserRepository {
  UserRepository(
      {required String endpoint, required String appID, required bool test})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Future<bool> save({required UserModel user}) async {
    try {
      if (user.id == null) {
        final result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: user.email, password: '12345678');

        if (result.user == null) {
          throw Exception('Falha ao criar usuário com email/senha.');
        }

        final doc = colUsers.doc(result.user?.uid);
        user.id = doc.id;

        await doc.set(user.toMap());
        await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);
      } else {
        final doc = colUsers.doc(user.id);
        await doc.update(user.toMap());
      }

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
      return false;
    }
  }

  @override
  Future<bool> delete({required UserModel user}) async {
    try {
      await colUsers.doc(user.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
