// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'materials_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MaterialsController on _MaterialsControllerBase, Store {
  Computed<int>? _$startItensWarehouseComputed;

  @override
  int get startItensWarehouse => (_$startItensWarehouseComputed ??=
          Computed<int>(() => super.startItensWarehouse,
              name: '_MaterialsControllerBase.startItensWarehouse'))
      .value;
  Computed<int>? _$endItensWarehouseComputed;

  @override
  int get endItensWarehouse => (_$endItensWarehouseComputed ??= Computed<int>(
          () => super.endItensWarehouse,
          name: '_MaterialsControllerBase.endItensWarehouse'))
      .value;
  Computed<int>? _$startMaterialsChecklistComputed;

  @override
  int get startMaterialsChecklist => (_$startMaterialsChecklistComputed ??=
          Computed<int>(() => super.startMaterialsChecklist,
              name: '_MaterialsControllerBase.startMaterialsChecklist'))
      .value;
  Computed<int>? _$endMaterialsChecklistComputed;

  @override
  int get endMaterialsChecklist => (_$endMaterialsChecklistComputed ??=
          Computed<int>(() => super.endMaterialsChecklist,
              name: '_MaterialsControllerBase.endMaterialsChecklist'))
      .value;
  Computed<int>? _$lengthItensWarehouseSortingsComputed;

  @override
  int get lengthItensWarehouseSortings =>
      (_$lengthItensWarehouseSortingsComputed ??= Computed<int>(
              () => super.lengthItensWarehouseSortings,
              name: '_MaterialsControllerBase.lengthItensWarehouseSortings'))
          .value;
  Computed<int>? _$lengthMaterialChecklistSortingsComputed;

  @override
  int get lengthMaterialChecklistSortings =>
      (_$lengthMaterialChecklistSortingsComputed ??= Computed<int>(
              () => super.lengthMaterialChecklistSortings,
              name: '_MaterialsControllerBase.lengthMaterialChecklistSortings'))
          .value;
  Computed<List<ItemModel>>? _$materialsWarehouseSortComputed;

  @override
  List<ItemModel> get materialsWarehouseSort =>
      (_$materialsWarehouseSortComputed ??= Computed<List<ItemModel>>(
              () => super.materialsWarehouseSort,
              name: '_MaterialsControllerBase.materialsWarehouseSort'))
          .value;
  Computed<List<MaterialChecklistModel>>? _$materialChecklistSortComputed;

  @override
  List<MaterialChecklistModel> get materialChecklistSort =>
      (_$materialChecklistSortComputed ??=
              Computed<List<MaterialChecklistModel>>(
                  () => super.materialChecklistSort,
                  name: '_MaterialsControllerBase.materialChecklistSort'))
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

  late final _$materialsChecklistAtom = Atom(
      name: '_MaterialsControllerBase.materialsChecklist', context: context);

  @override
  ObservableList<MaterialChecklistModel> get materialsChecklist {
    _$materialsChecklistAtom.reportRead();
    return super.materialsChecklist;
  }

  @override
  set materialsChecklist(ObservableList<MaterialChecklistModel> value) {
    _$materialsChecklistAtom.reportWrite(value, super.materialsChecklist, () {
      super.materialsChecklist = value;
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

  late final _$getMaterialsWarehouseAsyncAction = AsyncAction(
      '_MaterialsControllerBase.getMaterialsWarehouse',
      context: context);

  @override
  Future<List<ItemModel>?> getMaterialsWarehouse() {
    return _$getMaterialsWarehouseAsyncAction
        .run(() => super.getMaterialsWarehouse());
  }

  late final _$getMaterialChecklistAsyncAction = AsyncAction(
      '_MaterialsControllerBase.getMaterialChecklist',
      context: context);

  @override
  Future<List<MaterialChecklistModel>> getMaterialChecklist() {
    return _$getMaterialChecklistAsyncAction
        .run(() => super.getMaterialChecklist());
  }

  late final _$saveMaterialChecklistAsyncAction = AsyncAction(
      '_MaterialsControllerBase.saveMaterialChecklist',
      context: context);

  @override
  Future<void> saveMaterialChecklist(
      {required MaterialChecklistModel material,
      required List<OtherChangeModel> others,
      required List<FileModel> deletedFiles}) {
    return _$saveMaterialChecklistAsyncAction.run(() => super
        .saveMaterialChecklist(
            material: material, others: others, deletedFiles: deletedFiles));
  }

  late final _$deleteMaterialChecklistAsyncAction = AsyncAction(
      '_MaterialsControllerBase.deleteMaterialChecklist',
      context: context);

  @override
  Future<void> deleteMaterialChecklist(
      {required MaterialChecklistModel material}) {
    return _$deleteMaterialChecklistAsyncAction
        .run(() => super.deleteMaterialChecklist(material: material));
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
  void setMaterialsChecklist(List<MaterialChecklistModel> value) {
    final _$actionInfo = _$_MaterialsControllerBaseActionController.startAction(
        name: '_MaterialsControllerBase.setMaterialsChecklist');
    try {
      return super.setMaterialsChecklist(value);
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
  String toString() {
    return '''
materialsWarehouse: ${materialsWarehouse},
materialsChecklist: ${materialsChecklist},
loading: ${loading},
filter: ${filter},
limit: ${limit},
page: ${page},
startItensWarehouse: ${startItensWarehouse},
endItensWarehouse: ${endItensWarehouse},
startMaterialsChecklist: ${startMaterialsChecklist},
endMaterialsChecklist: ${endMaterialsChecklist},
lengthItensWarehouseSortings: ${lengthItensWarehouseSortings},
lengthMaterialChecklistSortings: ${lengthMaterialChecklistSortings},
materialsWarehouseSort: ${materialsWarehouseSort},
materialChecklistSort: ${materialChecklistSort}
    ''';
  }
}
