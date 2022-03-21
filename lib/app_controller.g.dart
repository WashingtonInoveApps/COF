// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppController on _AppControllerBase, Store {
  Computed<bool>? _$enableComputed;

  @override
  bool get enable => (_$enableComputed ??=
          Computed<bool>(() => super.enable, name: '_AppControllerBase.enable'))
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
  Computed<List<String>>? _$resgatesComputed;

  @override
  List<String> get resgates =>
      (_$resgatesComputed ??= Computed<List<String>>(() => super.resgates,
              name: '_AppControllerBase.resgates'))
          .value;
  Computed<Stream<List<CheckListModel>>>? _$listenCheckListComputed;

  @override
  Stream<List<CheckListModel>> get listenCheckList =>
      (_$listenCheckListComputed ??= Computed<Stream<List<CheckListModel>>>(
              () => super.listenCheckList,
              name: '_AppControllerBase.listenCheckList'))
          .value;

  final _$userAtom = Atom(name: '_AppControllerBase.user');

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

  final _$unidadeAtom = Atom(name: '_AppControllerBase.unidade');

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

  final _$isLoggedAtom = Atom(name: '_AppControllerBase.isLogged');

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

  final _$loadingAtom = Atom(name: '_AppControllerBase.loading');

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

  final _$dateAtom = Atom(name: '_AppControllerBase.date');

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

  final _$resgateAtom = Atom(name: '_AppControllerBase.resgate');

  @override
  String get resgate {
    _$resgateAtom.reportRead();
    return super.resgate;
  }

  @override
  set resgate(String value) {
    _$resgateAtom.reportWrite(value, super.resgate, () {
      super.resgate = value;
    });
  }

  final _$carsAtom = Atom(name: '_AppControllerBase.cars');

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

  final _$checkListsAtom = Atom(name: '_AppControllerBase.checkLists');

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

  final _$saveCarAsyncAction = AsyncAction('_AppControllerBase.saveCar');

  @override
  Future<bool> saveCar({required CarModel car, String? id}) {
    return _$saveCarAsyncAction.run(() => super.saveCar(car: car, id: id));
  }

  final _$saveCheckListAsyncAction =
      AsyncAction('_AppControllerBase.saveCheckList');

  @override
  Future<bool> saveCheckList(
      {required CheckListModel checkList, required int updateCar, String? id}) {
    return _$saveCheckListAsyncAction.run(() => super
        .saveCheckList(checkList: checkList, updateCar: updateCar, id: id));
  }

  final _$updateStatusCarAsyncAction =
      AsyncAction('_AppControllerBase.updateStatusCar');

  @override
  Future<bool> updateStatusCar(
      {required List<CarStatusModel> status,
      required String id,
      required bool enable}) {
    return _$updateStatusCarAsyncAction.run(
        () => super.updateStatusCar(status: status, id: id, enable: enable));
  }

  final _$updateKMCarAsyncAction =
      AsyncAction('_AppControllerBase.updateKMCar');

  @override
  Future<bool> updateKMCar(
      {required String id, required Map<String, dynamic> data}) {
    return _$updateKMCarAsyncAction
        .run(() => super.updateKMCar(id: id, data: data));
  }

  final _$insertMapaCarAsyncAction =
      AsyncAction('_AppControllerBase.insertMapaCar');

  @override
  Future<bool> insertMapaCar({required CarMapaModel mapa}) {
    return _$insertMapaCarAsyncAction
        .run(() => super.insertMapaCar(mapa: mapa));
  }

  final _$finishCheckListAsyncAction =
      AsyncAction('_AppControllerBase.finishCheckList');

  @override
  Future<bool> finishCheckList(
      {required String kmFinal, required CheckListModel checkList}) {
    return _$finishCheckListAsyncAction.run(
        () => super.finishCheckList(kmFinal: kmFinal, checkList: checkList));
  }

  final _$createUserAsyncAction = AsyncAction('_AppControllerBase.createUser');

  @override
  Future<bool> createUser({required UserModel user, required String password}) {
    return _$createUserAsyncAction
        .run(() => super.createUser(user: user, password: password));
  }

  final _$loginAsyncAction = AsyncAction('_AppControllerBase.login');

  @override
  Future<bool> login({required String email, required String senha}) {
    return _$loginAsyncAction
        .run(() => super.login(email: email, senha: senha));
  }

  final _$recuperarPasswordAsyncAction =
      AsyncAction('_AppControllerBase.recuperarPassword');

  @override
  Future<bool> recuperarPassword({required String email}) {
    return _$recuperarPasswordAsyncAction
        .run(() => super.recuperarPassword(email: email));
  }

  final _$saveUserDBLocalAsyncAction =
      AsyncAction('_AppControllerBase.saveUserDBLocal');

  @override
  Future<bool> saveUserDBLocal() {
    return _$saveUserDBLocalAsyncAction.run(() => super.saveUserDBLocal());
  }

  final _$getUserDBLocalAsyncAction =
      AsyncAction('_AppControllerBase.getUserDBLocal');

  @override
  Future<bool> getUserDBLocal() {
    return _$getUserDBLocalAsyncAction.run(() => super.getUserDBLocal());
  }

  final _$deleteUserDBLocalAsyncAction =
      AsyncAction('_AppControllerBase.deleteUserDBLocal');

  @override
  Future<bool> deleteUserDBLocal() {
    return _$deleteUserDBLocalAsyncAction.run(() => super.deleteUserDBLocal());
  }

  final _$deleteCarMapaAsyncAction =
      AsyncAction('_AppControllerBase.deleteCarMapa');

  @override
  Future<bool> deleteCarMapa({required String id}) {
    return _$deleteCarMapaAsyncAction.run(() => super.deleteCarMapa(id: id));
  }

  final _$deleteSupplyAsyncAction =
      AsyncAction('_AppControllerBase.deleteSupply');

  @override
  Future<bool> deleteSupply(
      {required List<SupplyModel> supplies,
      required int index,
      required String carId}) {
    return _$deleteSupplyAsyncAction.run(() =>
        super.deleteSupply(supplies: supplies, index: index, carId: carId));
  }

  final _$_AppControllerBaseActionController =
      ActionController(name: '_AppControllerBase');

  @override
  dynamic setResgate(String value) {
    final _$actionInfo = _$_AppControllerBaseActionController.startAction(
        name: '_AppControllerBase.setResgate');
    try {
      return super.setResgate(value);
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
user: ${user},
unidade: ${unidade},
isLogged: ${isLogged},
loading: ${loading},
date: ${date},
resgate: ${resgate},
cars: ${cars},
checkLists: ${checkLists},
enable: ${enable},
carsADM: ${carsADM},
carsOPR: ${carsOPR},
resgates: ${resgates},
listenCheckList: ${listenCheckList}
    ''';
  }
}
