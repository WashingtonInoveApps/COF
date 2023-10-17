// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppController on _AppControllerBase, Store {
  Computed<List<UserModel>>? _$usersValidationsComputed;

  @override
  List<UserModel> get usersValidations => (_$usersValidationsComputed ??=
          Computed<List<UserModel>>(() => super.usersValidations,
              name: '_AppControllerBase.usersValidations'))
      .value;
  Computed<List<CarModel>>? _$carsADMComputed;

  @override
  List<CarModel> get carsADM =>
      (_$carsADMComputed ??= Computed<List<CarModel>>(() => super.carsADM,
              name: '_AppControllerBase.carsADM'))
          .value;
  Computed<List<CarModel>>? _$carsOPRComputed;

  @override
  List<CarModel> get carsOPR =>
      (_$carsOPRComputed ??= Computed<List<CarModel>>(() => super.carsOPR,
              name: '_AppControllerBase.carsOPR'))
          .value;
  Computed<List<String>>? _$prefixsComputed;

  @override
  List<String> get prefixs =>
      (_$prefixsComputed ??= Computed<List<String>>(() => super.prefixs,
              name: '_AppControllerBase.prefixs'))
          .value;

  late final _$versionAtom =
      Atom(name: '_AppControllerBase.version', context: context);

  @override
  String get version {
    _$versionAtom.reportRead();
    return super.version;
  }

  @override
  set version(String value) {
    _$versionAtom.reportWrite(value, super.version, () {
      super.version = value;
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

  late final _$unidadeAtom =
      Atom(name: '_AppControllerBase.unidade', context: context);

  @override
  String get unidade {
    _$unidadeAtom.reportRead();
    return super.unidade;
  }

  @override
  set unidade(String value) {
    _$unidadeAtom.reportWrite(value, super.unidade, () {
      super.unidade = value;
    });
  }

  late final _$isLoggedAtom =
      Atom(name: '_AppControllerBase.isLogged', context: context);

  @override
  bool get isLogged {
    _$isLoggedAtom.reportRead();
    return super.isLogged;
  }

  @override
  set isLogged(bool value) {
    _$isLoggedAtom.reportWrite(value, super.isLogged, () {
      super.isLogged = value;
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

  late final _$dateAtom =
      Atom(name: '_AppControllerBase.date', context: context);

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
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

  late final _$checkListsAtom =
      Atom(name: '_AppControllerBase.checkLists', context: context);

  @override
  List<CheckListModel> get checkLists {
    _$checkListsAtom.reportRead();
    return super.checkLists;
  }

  @override
  set checkLists(List<CheckListModel> value) {
    _$checkListsAtom.reportWrite(value, super.checkLists, () {
      super.checkLists = value;
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

  late final _$saveSuppliesAsyncAction =
      AsyncAction('_AppControllerBase.saveSupplies', context: context);

  @override
  Future<bool> saveSupplies(
      {required SupplyModel supply, required CheckListModel checklist}) {
    return _$saveSuppliesAsyncAction
        .run(() => super.saveSupplies(supply: supply, checklist: checklist));
  }

  late final _$loginAsyncAction =
      AsyncAction('_AppControllerBase.login', context: context);

  @override
  Future<bool> login({required String email, required String senha}) {
    return _$loginAsyncAction
        .run(() => super.login(email: email, senha: senha));
  }

  late final _$recuperarPasswordAsyncAction =
      AsyncAction('_AppControllerBase.recuperarPassword', context: context);

  @override
  Future<bool> recuperarPassword({required String email}) {
    return _$recuperarPasswordAsyncAction
        .run(() => super.recuperarPassword(email: email));
  }

  late final _$deleteChecklistAsyncAction =
      AsyncAction('_AppControllerBase.deleteChecklist', context: context);

  @override
  Future<bool> deleteChecklist({required CheckListModel checkList}) {
    return _$deleteChecklistAsyncAction
        .run(() => super.deleteChecklist(checkList: checkList));
  }

  late final _$deleteSupplyAsyncAction =
      AsyncAction('_AppControllerBase.deleteSupply', context: context);

  @override
  Future<bool> deleteSupply(
      {required SupplyModel supply, required CheckListModel checklist}) {
    return _$deleteSupplyAsyncAction
        .run(() => super.deleteSupply(supply: supply, checklist: checklist));
  }

  late final _$_AppControllerBaseActionController =
      ActionController(name: '_AppControllerBase', context: context);

  @override
  dynamic setVersion(String value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setVersion');
    try {
      return super.setVersion(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setReferenceDate(DateTime value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setReferenceDate');
    try {
      return super.setReferenceDate(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCheckListVeicular(bool value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setCheckListVeicular');
    try {
      return super.setCheckListVeicular(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCars(List<CarModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setCars');
    try {
      return super.setCars(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUsers(List<UserModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setUsers');
    try {
      return super.setUsers(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCheckList(List<CheckListModel> value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setCheckList');
    try {
      return super.setCheckList(value);
    } finally {
      _$_AppControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
version: ${version},
user: ${user},
unidade: ${unidade},
isLogged: ${isLogged},
loading: ${loading},
checklistVeicular: ${checklistVeicular},
date: ${date},
cars: ${cars},
checkLists: ${checkLists},
users: ${users},
usersValidations: ${usersValidations},
carsADM: ${carsADM},
carsOPR: ${carsOPR},
prefixs: ${prefixs}
    ''';
  }
}
