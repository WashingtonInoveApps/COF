import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/user/repository/user_interface.dart';
import 'package:bsu_control/src/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../model/user_model.dart';

part 'user_controller.g.dart';

// ignore: library_private_types_in_public_api
class UserController = _UserControllerBase with _$UserController;

abstract class _UserControllerBase with Store {
  final AppController app;
  late IUserRepository repository;

  final controllerPassword = TextEditingController();
  final controllerPasswordConfirme = TextEditingController();

  _UserControllerBase({required this.app}) {
    repository = UserRepository(
        endpoint: app.endpoint, appID: app.appID, test: app.test);
  }

  @observable
  bool loading = false;

  @observable
  String graduation = '';

  @observable
  String? cia;

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  bool admin = false;

  @observable
  bool adminFull = false;

  @action
  setGraduation(String? value) => graduation = value ?? graduation;

  @action
  setAdmin(bool? value) => admin = value ?? admin;

  @action
  setAdminFull(bool? value) => adminFull = value ?? adminFull;

  @action
  setCia(String? value) => cia = value;

  @action
  setOBM(OBMModel? value) {
    if (value != null) {
      if (obm != value) {
        obm = value;

        if (obm.cias.isNotEmpty) {
          cia = obm.cias.first;
        } else {
          cia = null;
        }
      }
    }
  }

  @action
  Future<bool> save({required UserModel user}) async {
    try {
      loading = true;
      final result = await repository.save(user: user);
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> delete({required UserModel user}) async {
    loading = true;
    final result = await repository.delete(user: user);
    loading = false;

    return result;
  }

  @action
  Future<bool> update({required UserModel user}) async {
    loading = true;
    final result = await repository.update(user: user);
    loading = false;

    return result;
  }
}
