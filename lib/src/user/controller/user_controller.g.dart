// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserController on _UserControllerBase, Store {
  Computed<UserModel>? _$userInitComputed;

  @override
  UserModel get userInit =>
      (_$userInitComputed ??= Computed<UserModel>(() => super.userInit,
              name: '_UserControllerBase.userInit'))
          .value;
  Computed<List<UserModel>>? _$usersOBMComputed;

  @override
  List<UserModel> get usersOBM =>
      (_$usersOBMComputed ??= Computed<List<UserModel>>(() => super.usersOBM,
              name: '_UserControllerBase.usersOBM'))
          .value;
  Computed<List<UserModel>>? _$usersSortsComputed;

  @override
  List<UserModel> get usersSorts => (_$usersSortsComputed ??=
          Computed<List<UserModel>>(() => super.usersSorts,
              name: '_UserControllerBase.usersSorts'))
      .value;

  late final _$loadingAtom =
      Atom(name: '_UserControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$graduationAtom =
      Atom(name: '_UserControllerBase.graduation', context: context);

  @override
  String get graduation {
    _$graduationAtom.reportRead();
    return super.graduation;
  }

  @override
  set graduation(String value) {
    _$graduationAtom.reportWrite(value, super.graduation, () {
      super.graduation = value;
    });
  }

  late final _$ciaAtom =
      Atom(name: '_UserControllerBase.cia', context: context);

  @override
  String? get cia {
    _$ciaAtom.reportRead();
    return super.cia;
  }

  @override
  set cia(String? value) {
    _$ciaAtom.reportWrite(value, super.cia, () {
      super.cia = value;
    });
  }

  late final _$filterAtom =
      Atom(name: '_UserControllerBase.filter', context: context);

  @override
  String get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(String value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  late final _$limitAtom =
      Atom(name: '_UserControllerBase.limit', context: context);

  @override
  int get limit {
    _$limitAtom.reportRead();
    return super.limit;
  }

  @override
  set limit(int value) {
    _$limitAtom.reportWrite(value, super.limit, () {
      super.limit = value;
    });
  }

  late final _$pageAtom =
      Atom(name: '_UserControllerBase.page', context: context);

  @override
  int get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$obmAtom =
      Atom(name: '_UserControllerBase.obm', context: context);

  @override
  OBMModel get obm {
    _$obmAtom.reportRead();
    return super.obm;
  }

  @override
  set obm(OBMModel value) {
    _$obmAtom.reportWrite(value, super.obm, () {
      super.obm = value;
    });
  }

  late final _$adminAtom =
      Atom(name: '_UserControllerBase.admin', context: context);

  @override
  bool get admin {
    _$adminAtom.reportRead();
    return super.admin;
  }

  @override
  set admin(bool value) {
    _$adminAtom.reportWrite(value, super.admin, () {
      super.admin = value;
    });
  }

  late final _$enableAtom =
      Atom(name: '_UserControllerBase.enable', context: context);

  @override
  bool get enable {
    _$enableAtom.reportRead();
    return super.enable;
  }

  @override
  set enable(bool value) {
    _$enableAtom.reportWrite(value, super.enable, () {
      super.enable = value;
    });
  }

  late final _$battalionAtom =
      Atom(name: '_UserControllerBase.battalion', context: context);

  @override
  bool get battalion {
    _$battalionAtom.reportRead();
    return super.battalion;
  }

  @override
  set battalion(bool value) {
    _$battalionAtom.reportWrite(value, super.battalion, () {
      super.battalion = value;
    });
  }

  late final _$companyAtom =
      Atom(name: '_UserControllerBase.company', context: context);

  @override
  bool get company {
    _$companyAtom.reportRead();
    return super.company;
  }

  @override
  set company(bool value) {
    _$companyAtom.reportWrite(value, super.company, () {
      super.company = value;
    });
  }

  late final _$managerOperationalAtom =
      Atom(name: '_UserControllerBase.managerOperational', context: context);

  @override
  bool get managerOperational {
    _$managerOperationalAtom.reportRead();
    return super.managerOperational;
  }

  @override
  set managerOperational(bool value) {
    _$managerOperationalAtom.reportWrite(value, super.managerOperational, () {
      super.managerOperational = value;
    });
  }

  late final _$managerFleetAtom =
      Atom(name: '_UserControllerBase.managerFleet', context: context);

  @override
  bool get managerFleet {
    _$managerFleetAtom.reportRead();
    return super.managerFleet;
  }

  @override
  set managerFleet(bool value) {
    _$managerFleetAtom.reportWrite(value, super.managerFleet, () {
      super.managerFleet = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_UserControllerBase.save', context: context);

  @override
  Future<bool> save({required UserModel user}) {
    return _$saveAsyncAction.run(() => super.save(user: user));
  }

  late final _$deleteAsyncAction =
      AsyncAction('_UserControllerBase.delete', context: context);

  @override
  Future<bool> delete({required UserModel user}) {
    return _$deleteAsyncAction.run(() => super.delete(user: user));
  }

  late final _$updateAsyncAction =
      AsyncAction('_UserControllerBase.update', context: context);

  @override
  Future<bool> update({required UserModel user}) {
    return _$updateAsyncAction.run(() => super.update(user: user));
  }

  late final _$_UserControllerBaseActionController =
      ActionController(name: '_UserControllerBase', context: context);

  @override
  dynamic userControllerInit(UserModel? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.userControllerInit');
    try {
      return super.userControllerInit(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic onChangeFilter(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setLimit(int? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPage(int value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setGraduation(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setGraduation');
    try {
      return super.setGraduation(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAdmin(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setAdmin');
    try {
      return super.setAdmin(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setBattalion(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setBattalion');
    try {
      return super.setBattalion(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCompany(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setCompany');
    try {
      return super.setCompany(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setManagerFleet(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setManagerFleet');
    try {
      return super.setManagerFleet(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setManagerOperational(bool? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setManagerOperational');
    try {
      return super.setManagerOperational(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCia(String? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOBM(OBMModel? value) {
    final _$actionInfo = _$_UserControllerBaseActionController.startAction(
        name: '_UserControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_UserControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
graduation: ${graduation},
cia: ${cia},
filter: ${filter},
limit: ${limit},
page: ${page},
obm: ${obm},
admin: ${admin},
enable: ${enable},
battalion: ${battalion},
company: ${company},
managerOperational: ${managerOperational},
managerFleet: ${managerFleet},
userInit: ${userInit},
usersOBM: ${usersOBM},
usersSorts: ${usersSorts}
    ''';
  }
}
