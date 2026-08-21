import 'dart:developer';

import 'package:bsu_control/enum/core_enum.dart';
import 'package:bsu_control/materials/repository/material_interface.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:mobx/mobx.dart';

import '../../core/core.dart';
import '../../model/file_model.dart';
import '../../model/material_checklist_model.dart';
import '../../model/outher_changes_model.dart';
import '../repository/material_repository.dart';

part 'materials_controller.g.dart';

class MaterialsController = _MaterialsControllerBase with _$MaterialsController;

abstract class _MaterialsControllerBase with Store {
  final String obmID;
  final ConfigModel config;
  late IMaterialRepository repository;

  _MaterialsControllerBase({required this.config, required this.obmID}) {
    repository = MaterialRepository(
        endpoint: config.endpoint,
        appID: config.appID,
        test: config.test,
        obmID: obmID);
  }

  Stream<List<ItemModel>> listenMaterialsWarehouse() {
    return repository.listenMaterialsWarehouse();
  }

  Stream<List<MaterialChecklistModel>> listenMaterialChecklist() {
    return repository.listenMaterialChecklist();
  }

  @observable
  ObservableList<ItemModel> materialsWarehouse = <ItemModel>[].asObservable();

  @observable
  ObservableList<MaterialChecklistModel> materialsChecklist =
      <MaterialChecklistModel>[].asObservable();

  @observable
  bool loading = false;

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @computed
  int get startItensWarehouse {
    if (materialsWarehouseSort.isEmpty) return 0;

    return ((page - 1) * limit) + 1;
  }

  @computed
  int get endItensWarehouse {
    if (materialsWarehouseSort.isEmpty) return 0;

    return startItensWarehouse + materialsWarehouseSort.length - 1;
  }

  @computed
  int get startMaterialsChecklist {
    if (materialChecklistSort.isEmpty) return 0;

    return ((page - 1) * limit) + 1;
  }

  @computed
  int get endMaterialsChecklist {
    if (materialChecklistSort.isEmpty) return 0;

    return startMaterialsChecklist + materialChecklistSort.length - 1;
  }

  @computed
  int get lengthItensWarehouseSortings {
    if (filter.isEmpty) return materialsWarehouse.length;

    return materialsWarehouseSort.length;
  }

  @computed
  int get lengthMaterialChecklistSortings {
    if (filter.isEmpty) return materialsChecklist.length;

    return materialChecklistSort.length;
  }

  @computed
  List<ItemModel> get materialsWarehouseSort {
    if (filter.isNotEmpty) {
      final filtered = materialsWarehouse
          .where((e) =>
              (e.description.toLowerCase().contains(filter.toLowerCase())))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<ItemModel>.from(list);
    } else {
      final list =
          Core.paginate(list: materialsWarehouse, page: page, limit: limit);
      return List<ItemModel>.from(list);
    }
  }

  @computed
  List<MaterialChecklistModel> get materialChecklistSort {
    if (filter.isNotEmpty) {
      final filtered = materialsChecklist
          .where((e) =>
              (e.team?.name.toLowerCase().contains(filter.toLowerCase()) ??
                  false))
          .toList();

      final list = Core.paginate(list: filtered, page: page, limit: limit);
      return List<MaterialChecklistModel>.from(list);
    } else {
      final list =
          Core.paginate(list: materialsChecklist, page: page, limit: limit);
      return List<MaterialChecklistModel>.from(list);
    }
  }

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setMaterialsWarehouse(List<ItemModel> value) {
    for (final item in value) {
      if (item.quantity < 10) {
        item.status = ItemStatus.altered;
      } else if (item.validity?.isBefore(DateTime.now()) ?? false) {
        item.status = ItemStatus.altered;
      } else {
        item.status = ItemStatus.normal;
      }
    }

    materialsWarehouse
      ..clear()
      ..addAll(value);
  }

  @action
  void setMaterialsChecklist(List<MaterialChecklistModel> value) {
    materialsChecklist
      ..clear()
      ..addAll(value);
  }

  @action
  Future<void> saveMaterialWarehouse({required ItemModel material}) async {
    try {
      loading = true;
      await repository.saveMaterialWarehouse(material: material);
      loading = false;

      return;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<void> updateMaterialWarehouse({required ItemModel material}) async {
    try {
      loading = true;
      await repository.updateMaterialWarehouse(material: material);
      loading = false;

      return;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<void> deleteMaterialWarehouse({required ItemModel material}) async {
    try {
      loading = true;
      await repository.deleteMaterialWarehouse(material: material);
      loading = false;

      return;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  void setLimit(int? value) {
    limit = value ?? limit;
    page = 1;
  }

  @action
  void setPage(int value) => page = value;

  @action
  void onChangeFilter(String? value) {
    filter = value ?? '';
    page = 1;
  }

  @action
  Future<List<ItemModel>?> getMaterialsWarehouse() async {
    try {
      loading = true;
      final result = repository.getMaterialsWarehouse();
      loading = false;

      return result;
    } catch (e) {
      loading = false;
      return null;
    }
  }

  @action
  Future<void> saveMaterialChecklist({
    required MaterialChecklistModel material,
    required List<OtherChangeModel> others,
    required List<FileModel> deletedFiles,
  }) async {
    try {
      loading = true;
      log(material.toJson());

      await repository.saveMaterialChecklist(
        material: material,
        others: others,
        deletedFiles: deletedFiles,
      );

      loading = false;

      return;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }

  @action
  Future<void> deleteMaterialChecklist({
    required MaterialChecklistModel material,
  }) async {
    try {
      loading = true;
      await repository.deleteMaterialChecklist(
        material: material,
      );
      loading = false;

      return;
    } catch (e) {
      loading = false;
      rethrow;
    }
  }
}
