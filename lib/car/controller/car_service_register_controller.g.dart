// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_service_register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CarServiceRegisterController
    on _CarServiceRegisterControllerBase, Store {
  Computed<CarServiceModel>? _$serviceComputed;

  @override
  CarServiceModel get service =>
      (_$serviceComputed ??= Computed<CarServiceModel>(() => super.service,
              name: '_CarServiceRegisterControllerBase.service'))
          .value;

  late final _$loadingAtom =
      Atom(name: '_CarServiceRegisterControllerBase.loading', context: context);

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

  late final _$dateAtom =
      Atom(name: '_CarServiceRegisterControllerBase.date', context: context);

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

  late final _$expiretedAtom = Atom(
      name: '_CarServiceRegisterControllerBase.expireted', context: context);

  @override
  DateTime? get expireted {
    _$expiretedAtom.reportRead();
    return super.expireted;
  }

  @override
  set expireted(DateTime? value) {
    _$expiretedAtom.reportWrite(value, super.expireted, () {
      super.expireted = value;
    });
  }

  late final _$imagesAtom =
      Atom(name: '_CarServiceRegisterControllerBase.images', context: context);

  @override
  ObservableList<FileModel> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(ObservableList<FileModel> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  late final _$carAtom =
      Atom(name: '_CarServiceRegisterControllerBase.car', context: context);

  @override
  CarModel? get car {
    _$carAtom.reportRead();
    return super.car;
  }

  @override
  set car(CarModel? value) {
    _$carAtom.reportWrite(value, super.car, () {
      super.car = value;
    });
  }

  late final _$descriptionAtom = Atom(
      name: '_CarServiceRegisterControllerBase.description', context: context);

  @override
  String? get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String? value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$obsAtom =
      Atom(name: '_CarServiceRegisterControllerBase.obs', context: context);

  @override
  String? get obs {
    _$obsAtom.reportRead();
    return super.obs;
  }

  @override
  set obs(String? value) {
    _$obsAtom.reportWrite(value, super.obs, () {
      super.obs = value;
    });
  }

  late final _$localAtom =
      Atom(name: '_CarServiceRegisterControllerBase.local', context: context);

  @override
  String? get local {
    _$localAtom.reportRead();
    return super.local;
  }

  @override
  set local(String? value) {
    _$localAtom.reportWrite(value, super.local, () {
      super.local = value;
    });
  }

  late final _$problemAtom =
      Atom(name: '_CarServiceRegisterControllerBase.problem', context: context);

  @override
  StateCarProblems? get problem {
    _$problemAtom.reportRead();
    return super.problem;
  }

  @override
  set problem(StateCarProblems? value) {
    _$problemAtom.reportWrite(value, super.problem, () {
      super.problem = value;
    });
  }

  late final _$_CarServiceRegisterControllerBaseActionController =
      ActionController(
          name: '_CarServiceRegisterControllerBase', context: context);

  @override
  void initialization() {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.initialization');
    try {
      return super.initialization();
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeDate(DateTime? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.changeDate');
    try {
      return super.changeDate(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeExpireted(DateTime? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.changeExpireted');
    try {
      return super.changeExpireted(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void addImage(FileModel value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.addImage');
    try {
      return super.addImage(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void removeImage(int index) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.removeImage');
    try {
      return super.removeImage(index);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setCar(CarModel? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.setCar');
    try {
      return super.setCar(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void setProblem(StateCarProblems? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.setProblem');
    try {
      return super.setProblem(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeDescription(String? value) {
    final _$actionInfo =
        _$_CarServiceRegisterControllerBaseActionController.startAction(
            name: '_CarServiceRegisterControllerBase.changeDescription');
    try {
      return super.changeDescription(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeLocal(String? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.changeLocal');
    try {
      return super.changeLocal(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  void changeOBS(String? value) {
    final _$actionInfo = _$_CarServiceRegisterControllerBaseActionController
        .startAction(name: '_CarServiceRegisterControllerBase.changeOBS');
    try {
      return super.changeOBS(value);
    } finally {
      _$_CarServiceRegisterControllerBaseActionController
          .endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
date: ${date},
expireted: ${expireted},
images: ${images},
car: ${car},
description: ${description},
obs: ${obs},
local: ${local},
problem: ${problem},
service: ${service}
    ''';
  }
}
