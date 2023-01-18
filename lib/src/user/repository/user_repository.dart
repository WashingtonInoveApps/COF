import 'package:bsu_control/src/user/repository/user_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model.dart';

class UserRepository implements IUserRepository {
  final instance = FirebaseFirestore.instance;

  @override
  Future<bool> create(
      {required UserModel user, required String password}) async {
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: password);

      if (result.user == null) return false;

      user.id = result.user!.uid;
      await instance.collection("users").doc(user.id).set(user.toMap());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user.email);

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> update({required UserModel user}) async {
    try {
      await instance.collection('users').doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete({required UserModel user}) async {
    try {
      await instance.collection('users').doc(user.id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
