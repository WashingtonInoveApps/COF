import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/src/user/repository/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobx/mobx.dart';

import '../../../model/user_model.dart';
part 'user_controller.g.dart';

// ignore: library_private_types_in_public_api
class UserController = _UserControllerBase with _$UserController;

abstract class _UserControllerBase with Store {
  final IUserRepository repository;
  final AppController app;

  final controllerPassword = TextEditingController();
  final controllerPasswordConfirme = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskMatricula = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  @observable
  bool loading = false;

  @observable
  String graduacao = '';

  @observable
  String obm = '';

  @observable
  bool isSamu = false;

  @observable
  bool admin = false;

  @observable
  bool adminFleet = false;

  @observable
  bool adminMaterial = false;

  @observable
  bool fleet = false;

  @observable
  bool material = false;

  _UserControllerBase({required this.app, required this.repository});

  @action
  setGraduacao(String? value) => graduacao = value ?? graduacao;

  @action
  setIsSamu(bool? value) => isSamu = value ?? isSamu;

  @action
  setAdmin(bool? value) => admin = value ?? admin;

  @action
  setAdminFleet(bool? value) => adminFleet = value ?? adminFleet;

  @action
  setAdminMaterial(bool? value) => adminMaterial = value ?? adminMaterial;

  @action
  setFleet(bool? value) => fleet = value ?? fleet;

  @action
  setMaterial(bool? value) => material = value ?? material;

  @action
  setOBM(String? value) => obm = value ?? obm;

  @action
  Future<bool> create({required UserModel user, bool update = false}) async {
    loading = true;
    user.graduacao = graduacao;

    final result = update
        ? await repository.update(user: user)
        : await repository.create(user: user, password: '12345678');
    loading = false;

    return result;
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
