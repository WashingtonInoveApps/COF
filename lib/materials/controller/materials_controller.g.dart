// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MaterialsController on _MaterialsControllerBase, Store {
  Computed<bool>? _$btFinishComputed;

  @override
  bool get btFinish =>
      (_$btFinishComputed ??= Computed<bool>(() => super.btFinish,
              name: '_MaterialsControllerBase.btFinish'))
          .value;
  Computed<int>? _$startMaterialComputed;

  @override
  int get startMaterial =>
      (_$startMaterialComputed ??= Computed<int>(() => super.startMaterial,
              name: '_MaterialsControllerBase.startMaterial'))
          .value;
  Computed<int>? _$endMaterialComputed;

  @override
  int get endMaterial =>
      (_$endMaterialComputed ??= Computed<int>(() => super.endMaterial,
              name: '_MaterialsControllerBase.endMaterial'))
          .value;
  Computed<List<ItemModel>>? _$materialsWarehouseSortComputed;

  @override
  List<ItemModel> get materialsWarehouseSort =>
      (_$materialsWarehouseSortComputed ??= Computed<List<ItemModel>>(
              () => super.materialsWarehouseSort,
              name: '_MaterialsControllerBase.materialsWarehouseSort'))
          .value;

  late final _$materialsWarehouseAtom = Atom(
      name: '_MaterialsControllerBase.materialsWarehouse', context: context);

  @override
  ObservableList<ItemModel> get materialsWarehouse {
    _$materialsWarehouseAtom.reportRead();
    return super.materialsWarehouse;
  }

  @override
  set materialsWarehouse(ObservableList<ItemModel> value) {
    _$materialsWarehouseAtom.reportWrite(value, super.materialsWarehouse, () {
      super.materialsWarehouse = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_MaterialsControllerBase.loading', context: context);

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

  late final _$filterAtom =
      Atom(name: '_MaterialsControllerBase.filter', context: context);

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
      Atom(name: '_MaterialsControllerBase.limit', context: context);

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
      Atom(name: '_MaterialsControllerBase.page', context: context);

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

  late final _$stepAtom =
      Atom(name: '_MaterialsControllerBase.step', context: context);

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

  late final _$saveMaterialWarehouseAsyncAction = AsyncAction(
      '_MaterialsControllerBase.saveMaterialWarehouse',
      context: context);

  @override
  Future<void> saveMaterialWarehouse({required ItemModel material}) {
    return _$saveMaterialWarehouseAsyncAction
        .run(() => super.saveMaterialWarehouse(material: material));
  }

  late final _$updateMaterialWarehouseAsyncAction = AsyncAction(
      '_MaterialsControllerBase.updateMaterialWarehouse',
      context: context);

  @override
  Future<void> updateMaterialWarehouse({required ItemModel material}) {
    return _$updateMaterialWarehouseAsyncAction
        .run(() => super.updateMaterialWarehouse(material: material));
  }

  late final _$deleteMaterialWarehouseAsyncAction = AsyncAction(
      '_MaterialsControllerBase.deleteMaterialWarehouse',
      context: context);

  @override
  Future<void> deleteMaterialWarehouse({required ItemModel material}) {
    return _$deleteMaterialWarehouseAsyncAction
        .run(() => super.deleteMaterialWarehouse(material: material));
  }

  late final _$_MaterialsControllerBaseActionController =
      ActionController(name: '_MaterialsControllerBase', context: context);

  @override
  void setLoading(bool value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setLoading');
    try {
      return super.setLoading(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMaterialsWarehouse(List<ItemModel> value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setMaterialsWarehouse');
    try {
      return super.setMaterialsWarehouse(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLimit(int? value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setLimit');
    try {
      return super.setLimit(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setPage');
    try {
      return super.setPage(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onChangeFilter(String? value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.onChangeFilter');
    try {
      return super.onChangeFilter(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void processStep(bool value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.processStep');
    try {
      return super.processStep(value);
    } finally {
      _$_MaterialsControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
materialsWarehouse: ${materialsWarehouse},
loading: ${loading},
filter: ${filter},
limit: ${limit},
page: ${page},
step: ${step},
btFinish: ${btFinish},
startMaterial: ${startMaterial},
endMaterial: ${endMaterial},
materialsWarehouseSort: ${materialsWarehouseSort}
    ''';
  }
}
