import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/config_model.dart';
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
  final ConfigModel config;
  final UserModel? init;
  final UserModel user;
  final List<OBMModel> obms;

  late IUserRepository repository;

  final controllerPassword = TextEditingController();
  final controllerPasswordConfirme = TextEditingController();

  _UserControllerBase(
      {required this.config,
      required this.init,
      required this.obms,
      required this.user}) {
    repository = UserRepository(
        endpoint: config.endpoint, appID: config.appID, test: config.test);

    userControllerInit(init);
  }

  @action
  userControllerInit(UserModel? value) {
    graduation = value?.graduation ?? Constants.graduations.first;

    admin = value?.admin ?? false;
    enable = value?.enable ?? false;
    battalion = value?.battalion ?? false;
    company = value?.company ?? false;
    managerOperational = value?.managerOperational ?? false;
    managerFleet = value?.managerFleet ?? false;

    if (value != null) {
      obm = obms.firstWhere((e) => e.id == value.obmID);
      cia = value.cia;
    } else {
      obm = obms.firstWhere((e) => e.id == user.obmID);
      cia = obm.cias.first;
    }
  }

  @observable
  bool loading = false;

  @observable
  ObservableList<UserModel> users = <UserModel>[].asObservable();

  @observable
  String graduation = '';

  @observable
  String? cia;

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  OBMModel obm = OBMModel(team: [], cias: []);

  @observable
  bool admin = false;

  @observable
  bool enable = false;

  @observable
  bool battalion = false;

  @observable
  bool company = false;

  @observable
  bool managerOperational = false;

  @observable
  bool managerFleet = false;

  @computed
  UserModel get userInit {
    return UserModel(
        id: init?.id,
        admin: admin,
        battalion: battalion,
        cia: cia ?? '',
        company: company,
        enable: enable,
        graduation: graduation,
        managerFleet: managerFleet,
        managerOperational: managerOperational,
        email: init?.email ?? '',
        obmID: obm.id ?? '');
  }

  @computed
  List<UserModel> get usersOBM {
    if (user.admin) {
      return List<UserModel>.from(users);
    } else if (user.battalion) {
      return List<UserModel>.from(
          users.where((e) => e.obmID == user.obmID).toList());
    } else {
      return List<UserModel>.from(users
          .where((e) => e.cia.toLowerCase() == user.cia.toLowerCase())
          .toList());
    }
  }

  @computed
  List<UserModel> get usersSorts {
    if (filter.isNotEmpty) {
      final filtered = usersOBM
          .where((e) => (e.fullname
                  .toLowerCase()
                  .contains(filter.toLowerCase()) ||
              (e.cia.toLowerCase().contains(filter.toLowerCase())) ||
              (e.graduation.toLowerCase().contains(filter.toLowerCase())) ||
              (e.registration.toLowerCase().contains(filter.toLowerCase()))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<UserModel>.from(list);
    } else {
      final list = Core.paginate(list: usersOBM, page: page, limit: limit);
      return List<UserModel>.from(list);
    }
  }

  @action
  onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  setPage(int value) {
    page = value;
  }

  @action
  setUsers(List<UserModel> values) {
    users
      ..clear()
      ..addAll(values);
  }

  @action
  setGraduation(String? value) => graduation = value ?? graduation;

  @action
  setAdmin(bool? value) => admin = value ?? admin;

  @action
  setBattalion(bool? value) => battalion = value ?? battalion;

  @action
  setCompany(bool? value) => company = value ?? company;

  @action
  setManagerFleet(bool? value) => managerFleet = value ?? managerFleet;

  @action
  setManagerOperational(bool? value) =>
      managerOperational = value ?? managerOperational;

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

      final result = (init != null)
          ? await repository.update(user: user)
          : await repository.save(user: user);

      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> delete({required UserModel user}) async {
    try {
      loading = true;
      final result = await repository.delete(user: user);
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<bool> update({required UserModel user}) async {
    loading = true;
    final result = await repository.update(user: user);
    loading = false;

    return result;
  }
}
