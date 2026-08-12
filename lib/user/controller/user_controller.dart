import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/user/repository/user_interface.dart';
import 'package:bsu_control/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../model/cia_model.dart';
import '../../model/user_model.dart';

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

    final userOBM = obms
        .cast<OBMModel?>()
        .firstWhere((e) => e?.id == value?.obmID, orElse: () => null);

    obm = userOBM;
    cia = userOBM?.cias
        .cast<CiaModel?>()
        .firstWhere((e) => e?.id == value?.ciaID, orElse: () => null);
  }

  List<String> messagesError = [];

  @observable
  bool loading = false;

  @observable
  ObservableList<UserModel> users = <UserModel>[].asObservable();

  @observable
  String graduation = '';

  @observable
  CiaModel? cia;

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  OBMModel? obm;

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
        cia: cia,
        ciaID: cia?.id ?? '',
        company: company,
        enable: enable,
        graduation: graduation,
        managerFleet: managerFleet,
        managerOperational: managerOperational,
        email: init?.email ?? '',
        obmID: obm?.id ?? '');
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
          .where(
              (e) => e.cia?.name.toLowerCase() == user.cia?.name.toLowerCase())
          .toList());
    }
  }

  @computed
  List<UserModel> get usersSorts {
    if (filter.isNotEmpty) {
      final search = filter.toLowerCase();

      final filtered = usersOBM
          .where((e) => (e.fullname.toLowerCase().contains(search) ||
              ((e.cia?.name.toLowerCase() ?? '').contains(search)) ||
              (e.graduation.toLowerCase().contains(search)) ||
              (e.registration.toLowerCase().contains(search))))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<UserModel>.from(list);
    } else {
      final list = Core.paginate(list: usersOBM, page: page, limit: limit);
      return List<UserModel>.from(list);
    }
  }

  @computed
  int get lengthSortings {
    if (filter.isEmpty) return usersOBM.length;

    return usersSorts.length;
  }

  @computed
  int get start => usersSorts.isEmpty ? 0 : ((page - 1) * limit) + 1;

  @computed
  int get end => usersSorts.isEmpty ? 0 : start + usersSorts.length - 1;

  @action
  void onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  void setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  void setPage(int value) {
    page = value;
  }

  @action
  void setUsers(List<UserModel> values) {
    if (values.isNotEmpty) {
      values.sort((a, b) => a.graduation.compareTo(b.graduation));
    }

    users
      ..clear()
      ..addAll(values);
  }

  @action
  void setGraduation(String? value) => graduation = value ?? graduation;

  @action
  void setAdmin(bool? value) => admin = value ?? admin;

  @action
  void setBattalion(bool? value) => battalion = value ?? battalion;

  @action
  void setCompany(bool? value) => company = value ?? company;

  @action
  void setManagerFleet(bool? value) => managerFleet = value ?? managerFleet;

  @action
  void setManagerOperational(bool? value) =>
      managerOperational = value ?? managerOperational;

  @action
  void setCia(CiaModel? value) => cia = value;

  @action
  void setOBM(OBMModel? value) => obm = value;

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
