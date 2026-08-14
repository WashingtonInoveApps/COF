import 'package:bsu_control/enum/core_enum.dart';
import 'package:bsu_control/materials/repository/material_interface.dart';
import 'package:bsu_control/model/config_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:mobx/mobx.dart';

import '../../core/core.dart';
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

  @observable
  ObservableList<ItemModel> materialsWarehouse = <ItemModel>[].asObservable();

  @observable
  bool loading = false;

  @observable
  String filter = '';

  @observable
  int limit = 10;

  @observable
  int page = 1;

  @observable
  int step = 0;

  @computed
  bool get btFinish => step == 2;

  @computed
  int get startMaterial =>
      materialsWarehouseSort.isEmpty ? 0 : ((page - 1) * limit) + 1;

  @computed
  int get endMaterial => materialsWarehouseSort.isEmpty
      ? 0
      : startMaterial + materialsWarehouseSort.length - 1;

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
  void processStep(bool value) {
    if (value) {
      step++;
    } else {
      if (step > 0) step--;
    }
  }
}
