// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppController on _AppControllerBase, Store {
  Computed<List<String>>? _$carsTypesComputed;

  @override
  List<String> get carsTypes =>
      (_$carsTypesComputed ??= Computed<List<String>>(() => super.carsTypes,
              name: '_AppControllerBase.carsTypes'))
          .value;
  Computed<bool>? _$newRegisterVehicularComputed;

  @override
  bool get newRegisterVehicular => (_$newRegisterVehicularComputed ??=
          Computed<bool>(() => super.newRegisterVehicular,
              name: '_AppControllerBase.newRegisterVehicular'))
      .value;
  Computed<bool>? _$newRegisterMaterialComputed;

  @override
  bool get newRegisterMaterial => (_$newRegisterMaterialComputed ??=
          Computed<bool>(() => super.newRegisterMaterial,
              name: '_AppControllerBase.newRegisterMaterial'))
      .value;
  Computed<List<CarModel>>? _$carsUsersComputed;

  @override
  List<CarModel> get carsUsers =>
      (_$carsUsersComputed ??= Computed<List<CarModel>>(() => super.carsUsers,
              name: '_AppControllerBase.carsUsers'))
          .value;

  late final _$versionAtom =
      Atom(name: '_AppControllerBase.version', context: context);

  @override
  int get version {
    _$versionAtom.reportRead();
    return super.version;
  }

  @override
  set version(int value) {
    _$versionAtom.reportWrite(value, super.version, () {
      super.version = value;
    });
  }

  late final _$widthAtom =
      Atom(name: '_AppControllerBase.width', context: context);

  @override
  double get width {
    _$widthAtom.reportRead();
    return super.width;
  }

  @override
  set width(double value) {
    _$widthAtom.reportWrite(value, super.width, () {
      super.width = value;
    });
  }

  late final _$routerAtom =
      Atom(name: '_AppControllerBase.router', context: context);

  @override
  int get router {
    _$routerAtom.reportRead();
    return super.router;
  }

  @override
  set router(int value) {
    _$routerAtom.reportWrite(value, super.router, () {
      super.router = value;
    });
  }

  late final _$userAtom =
      Atom(name: '_AppControllerBase.user', context: context);

  @override
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$menuOpenAtom =
      Atom(name: '_AppControllerBase.menuOpen', context: context);

  @override
  bool get menuOpen {
    _$menuOpenAtom.reportRead();
    return super.menuOpen;
  }

  @override
  set menuOpen(bool value) {
    _$menuOpenAtom.reportWrite(value, super.menuOpen, () {
      super.menuOpen = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_AppControllerBase.loading', context: context);

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

  late final _$checklistVeicularAtom =
      Atom(name: '_AppControllerBase.checklistVeicular', context: context);

  @override
  bool get checklistVeicular {
    _$checklistVeicularAtom.reportRead();
    return super.checklistVeicular;
  }

  @override
  set checklistVeicular(bool value) {
    _$checklistVeicularAtom.reportWrite(value, super.checklistVeicular, () {
      super.checklistVeicular = value;
    });
  }

  late final _$modeMOBILEAtom =
      Atom(name: '_AppControllerBase.modeMOBILE', context: context);

  @override
  bool get modeMOBILE {
    _$modeMOBILEAtom.reportRead();
    return super.modeMOBILE;
  }

  @override
  set modeMOBILE(bool value) {
    _$modeMOBILEAtom.reportWrite(value, super.modeMOBILE, () {
      super.modeMOBILE = value;
    });
  }

  late final _$checklistUserVehicularAtom =
      Atom(name: '_AppControllerBase.checklistUserVehicular', context: context);

  @override
  ChecklistModel? get checklistUserVehicular {
    _$checklistUserVehicularAtom.reportRead();
    return super.checklistUserVehicular;
  }

  @override
  set checklistUserVehicular(ChecklistModel? value) {
    _$checklistUserVehicularAtom
        .reportWrite(value, super.checklistUserVehicular, () {
      super.checklistUserVehicular = value;
    });
  }

  late final _$checklistUserMaterialAtom =
      Atom(name: '_AppControllerBase.checklistUserMaterial', context: context);

  @override
  ChecklistModel? get checklistUserMaterial {
    _$checklistUserMaterialAtom.reportRead();
    return super.checklistUserMaterial;
  }

  @override
  set checklistUserMaterial(ChecklistModel? value) {
    _$checklistUserMaterialAtom.reportWrite(value, super.checklistUserMaterial,
        () {
      super.checklistUserMaterial = value;
    });
  }

  late final _$carsAtom =
      Atom(name: '_AppControllerBase.cars', context: context);

  @override
  List<CarModel> get cars {
    _$carsAtom.reportRead();
    return super.cars;
  }

  @override
  set cars(List<CarModel> value) {
    _$carsAtom.reportWrite(value, super.cars, () {
      super.cars = value;
    });
  }

  late final _$checklistsOperationDayAtom =
      Atom(name: '_AppControllerBase.checklistsOperationDay', context: context);

  @override
  List<ChecklistModel> get checklistsOperationDay {
    _$checklistsOperationDayAtom.reportRead();
    return super.checklistsOperationDay;
  }

  @override
  set checklistsOperationDay(List<ChecklistModel> value) {
    _$checklistsOperationDayAtom
        .reportWrite(value, super.checklistsOperationDay, () {
      super.checklistsOperationDay = value;
    });
  }

  late final _$notificationsAtom =
      Atom(name: '_AppControllerBase.notifications', context: context);

  @override
  List<NotificationModel> get notifications {
    _$notificationsAtom.reportRead();
    return super.notifications;
  }

  @override
  set notifications(List<NotificationModel> value) {
    _$notificationsAtom.reportWrite(value, super.notifications, () {
      super.notifications = value;
    });
  }

  late final _$usersAtom =
      Atom(name: '_AppControllerBase.users', context: context);

  @override
  List<UserModel> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(List<UserModel> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  late final _$setUserAsyncAction =
      AsyncAction('_AppControllerBase.setUser', context: context);

  @override
  Future<void> setUser(UserModel value) {
    return _$setUserAsyncAction.run(() => super.setUser(value));
  }

  late final _$initApplicationAsyncAction =
      AsyncAction('_AppControllerBase.initApplication', context: context);

  @override
  Future<void> initApplication() {
    return _$initApplicationAsyncAction.run(() => super.initApplication());
  }

  late final _$_AppControllerBaseActionController =
      ActionController(name: '_AppControllerBase', context: context);

  @override
  void changeMenuOpen() {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.changeMenuOpen');
    try {
      return super.changeMenuOpen();
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setRouter(int value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setRouter');
    try {
      return super.setRouter(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCheckListVeicular(bool value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setCheckListVeicular');
    try {
      return super.setCheckListVeicular(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCars(List<CarModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setCars');
    try {
      return super.setCars(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUsers(List<UserModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setUsers');
    try {
      return super.setUsers(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChecklistsOperationDay(List<ChecklistModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setChecklistsOperationDay');
    try {
      return super.setChecklistsOperationDay(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  double processWidth(
      {required double constrainedMaxWidth, required bool childRight}) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.processWidth');
    try {
      return super.processWidth(
          constrainedMaxWidth: constrainedMaxWidth, childRight: childRight);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
version: ${version},
width: ${width},
router: ${router},
user: ${user},
menuOpen: ${menuOpen},
loading: ${loading},
checklistVeicular: ${checklistVeicular},
modeMOBILE: ${modeMOBILE},
checklistUserVehicular: ${checklistUserVehicular},
checklistUserMaterial: ${checklistUserMaterial},
cars: ${cars},
checklistsOperationDay: ${checklistsOperationDay},
notifications: ${notifications},
users: ${users},
carsTypes: ${carsTypes},
newRegisterVehicular: ${newRegisterVehicular},
newRegisterMaterial: ${newRegisterMaterial},
carsUsers: ${carsUsers}
    ''';
  }
}
