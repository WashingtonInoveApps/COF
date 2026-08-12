// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ServiceController on _ServiceControllerBase, Store {
  Computed<bool>? _$btFinishComputed;

  @override
  bool get btFinish =>
      (_$btFinishComputed ??= Computed<bool>(() => super.btFinish,
              name: '_ServiceControllerBase.btFinish'))
          .value;

  late final _$loadingAtom =
      Atom(name: '_ServiceControllerBase.loading', context: context);

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

  late final _$userSelectAtom =
      Atom(name: '_ServiceControllerBase.userSelect', context: context);

  @override
  UserModel? get userSelect {
    _$userSelectAtom.reportRead();
    return super.userSelect;
  }

  @override
  set userSelect(UserModel? value) {
    _$userSelectAtom.reportWrite(value, super.userSelect, () {
      super.userSelect = value;
    });
  }

  late final _$dateAtom =
      Atom(name: '_ServiceControllerBase.date', context: context);

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

  late final _$stepAtom =
      Atom(name: '_ServiceControllerBase.step', context: context);

  @override
  int get step {
    _$stepAtom.reportRead();
    return super.step;
  }

  @override
  set step(int value) {
    _$stepAtom.reportWrite(value, super.step, () {
      super.step = value;
    });
  }

  late final _$contactAtom =
      Atom(name: '_ServiceControllerBase.contact', context: context);

  @override
  String get contact {
    _$contactAtom.reportRead();
    return super.contact;
  }

  @override
  set contact(String value) {
    _$contactAtom.reportWrite(value, super.contact, () {
      super.contact = value;
    });
  }

  late final _$ciaAtom =
      Atom(name: '_ServiceControllerBase.cia', context: context);

  @override
  CiaModel? get cia {
    _$ciaAtom.reportRead();
    return super.cia;
  }

  @override
  set cia(CiaModel? value) {
    _$ciaAtom.reportWrite(value, super.cia, () {
      super.cia = value;
    });
  }

  late final _$teamAtom =
      Atom(name: '_ServiceControllerBase.team', context: context);

  @override
  TeamModel? get team {
    _$teamAtom.reportRead();
    return super.team;
  }

  @override
  set team(TeamModel? value) {
    _$teamAtom.reportWrite(value, super.team, () {
      super.team = value;
    });
  }

  late final _$pbAtom =
      Atom(name: '_ServiceControllerBase.pb', context: context);

  @override
  String get pb {
    _$pbAtom.reportRead();
    return super.pb;
  }

  @override
  set pb(String value) {
    _$pbAtom.reportWrite(value, super.pb, () {
      super.pb = value;
    });
  }

  late final _$obsAtom =
      Atom(name: '_ServiceControllerBase.obs', context: context);

  @override
  String get obs {
    _$obsAtom.reportRead();
    return super.obs;
  }

  @override
  set obs(String value) {
    _$obsAtom.reportWrite(value, super.obs, () {
      super.obs = value;
    });
  }

  late final _$obmAtom =
      Atom(name: '_ServiceControllerBase.obm', context: context);

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

  late final _$teamsAtom =
      Atom(name: '_ServiceControllerBase.teams', context: context);

  @override
  ObservableList<TeamModel> get teams {
    _$teamsAtom.reportRead();
    return super.teams;
  }

  @override
  set teams(ObservableList<TeamModel> value) {
    _$teamsAtom.reportWrite(value, super.teams, () {
      super.teams = value;
    });
  }

  late final _$componentsAtom =
      Atom(name: '_ServiceControllerBase.components', context: context);

  @override
  ObservableList<ServicesComponent> get components {
    _$componentsAtom.reportRead();
    return super.components;
  }

  @override
  set components(ObservableList<ServicesComponent> value) {
    _$componentsAtom.reportWrite(value, super.components, () {
      super.components = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_ServiceControllerBase.save', context: context);

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_ServiceControllerBaseActionController =
      ActionController(name: '_ServiceControllerBase', context: context);

  @override
  void setUserSelect(UserModel? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setUserSelect');
    try {
      return super.setUserSelect(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void processStep(bool value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.processStep');
    try {
      return super.processStep(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setComponent(ServicesComponent value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setComponent');
    try {
      return super.setComponent(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteComponent(int index) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.deleteComponent');
    try {
      return super.deleteComponent(index);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeComponent(ServicesComponent value, int index) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.changeComponent');
    try {
      return super.changeComponent(value, index);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOBM(OBMModel? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setOBM');
    try {
      return super.setOBM(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCia(CiaModel? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setCia');
    try {
      return super.setCia(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTeam(TeamModel? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setTeam');
    try {
      return super.setTeam(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setContact(String? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.setContact');
    try {
      return super.setContact(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeDate(DateTime? value) {
    final _$actionInfo = _$_ServiceControllerBaseActionController.startAction(
        name: '_ServiceControllerBase.changeDate');
    try {
      return super.changeDate(value);
    } finally {
      _$_ServiceControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loading: ${loading},
userSelect: ${userSelect},
date: ${date},
step: ${step},
contact: ${contact},
cia: ${cia},
team: ${team},
pb: ${pb},
obs: ${obs},
obm: ${obm},
teams: ${teams},
components: ${components},
btFinish: ${btFinish}
    ''';
  }
}
