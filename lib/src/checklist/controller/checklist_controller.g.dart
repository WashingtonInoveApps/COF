// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CheckListController on _CheckListControllerBase, Store {
  late final _$checklistAtom =
      Atom(name: '_CheckListControllerBase.checklist', context: context);

  @override
  CheckListModel get checklist {
    _$checklistAtom.reportRead();
    return super.checklist;
  }

  @override
  set checklist(CheckListModel value) {
    _$checklistAtom.reportWrite(value, super.checklist, () {
      super.checklist = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_CheckListControllerBase.loading', context: context);

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

  late final _$carChangesAtom =
      Atom(name: '_CheckListControllerBase.carChanges', context: context);

  @override
  ObservableList<CarChangeModel> get carChanges {
    _$carChangesAtom.reportRead();
    return super.carChanges;
  }

  @override
  set carChanges(ObservableList<CarChangeModel> value) {
    _$carChangesAtom.reportWrite(value, super.carChanges, () {
      super.carChanges = value;
    });
  }

  late final _$itensAtom =
      Atom(name: '_CheckListControllerBase.itens', context: context);

  @override
  ObservableList<ItensChangesModel> get itens {
    _$itensAtom.reportRead();
    return super.itens;
  }

  @override
  set itens(ObservableList<ItensChangesModel> value) {
    _$itensAtom.reportWrite(value, super.itens, () {
      super.itens = value;
    });
  }

  late final _$prefixAtom =
      Atom(name: '_CheckListControllerBase.prefix', context: context);

  @override
  String get prefix {
    _$prefixAtom.reportRead();
    return super.prefix;
  }

  @override
  set prefix(String value) {
    _$prefixAtom.reportWrite(value, super.prefix, () {
      super.prefix = value;
    });
  }

  late final _$alfaAtom =
      Atom(name: '_CheckListControllerBase.alfa', context: context);

  @override
  String get alfa {
    _$alfaAtom.reportRead();
    return super.alfa;
  }

  @override
  set alfa(String value) {
    _$alfaAtom.reportWrite(value, super.alfa, () {
      super.alfa = value;
    });
  }

  late final _$oilAtom =
      Atom(name: '_CheckListControllerBase.oil', context: context);

  @override
  double get oil {
    _$oilAtom.reportRead();
    return super.oil;
  }

  @override
  set oil(double value) {
    _$oilAtom.reportWrite(value, super.oil, () {
      super.oil = value;
    });
  }

  late final _$hidraAtom =
      Atom(name: '_CheckListControllerBase.hidra', context: context);

  @override
  double get hidra {
    _$hidraAtom.reportRead();
    return super.hidra;
  }

  @override
  set hidra(double value) {
    _$hidraAtom.reportWrite(value, super.hidra, () {
      super.hidra = value;
    });
  }

  late final _$frAtom =
      Atom(name: '_CheckListControllerBase.fr', context: context);

  @override
  double get fr {
    _$frAtom.reportRead();
    return super.fr;
  }

  @override
  set fr(double value) {
    _$frAtom.reportWrite(value, super.fr, () {
      super.fr = value;
    });
  }

  late final _$arrefAtom =
      Atom(name: '_CheckListControllerBase.arref', context: context);

  @override
  double get arref {
    _$arrefAtom.reportRead();
    return super.arref;
  }

  @override
  set arref(double value) {
    _$arrefAtom.reportWrite(value, super.arref, () {
      super.arref = value;
    });
  }

  late final _$saveAsyncAction =
      AsyncAction('_CheckListControllerBase.save', context: context);

  @override
  Future<bool> save({required CheckListModel checkList, String? id}) {
    return _$saveAsyncAction
        .run(() => super.save(checkList: checkList, id: id));
  }

  late final _$finishAsyncAction =
      AsyncAction('_CheckListControllerBase.finish', context: context);

  @override
  Future<bool> finish(
      {required String kmFinal, required CheckListModel checkList}) {
    return _$finishAsyncAction
        .run(() => super.finish(kmFinal: kmFinal, checkList: checkList));
  }

  late final _$_CheckListControllerBaseActionController =
      ActionController(name: '_CheckListControllerBase', context: context);

  @override
  dynamic initController() {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.initController');
    try {
      return super.initController();
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setPrefix(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setPrefix');
    try {
      return super.setPrefix(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAlfa(String? value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setAlfa');
    try {
      return super.setAlfa(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setOil(dynamic value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setOil');
    try {
      return super.setOil(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setHidra(dynamic value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setHidra');
    try {
      return super.setHidra(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFR(dynamic value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setFR');
    try {
      return super.setFR(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setArref(dynamic value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.setArref');
    try {
      return super.setArref(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addCarChanges(CarChangeModel value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.addCarChanges');
    try {
      return super.addCarChanges(value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeCarChanges(int index) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.removeCarChanges');
    try {
      return super.removeCarChanges(index);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic statusExpanded(int index, bool value) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.statusExpanded');
    try {
      return super.statusExpanded(index, value);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic selectValueItens(bool value, int index, int indexItem) {
    final _$actionInfo = _$_CheckListControllerBaseActionController.startAction(
        name: '_CheckListControllerBase.selectValueItens');
    try {
      return super.selectValueItens(value, index, indexItem);
    } finally {
      _$_CheckListControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
checklist: ${checklist},
loading: ${loading},
carChanges: ${carChanges},
itens: ${itens},
prefix: ${prefix},
alfa: ${alfa},
oil: ${oil},
hidra: ${hidra},
fr: ${fr},
arref: ${arref}
    ''';
  }
}
