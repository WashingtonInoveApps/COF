import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

import '../../model/material_checklist_model.dart';

abstract class IMaterialRepository {
  Stream<List<ItemModel>> listenMaterialsWarehouse();
  Stream<List<MaterialChecklistModel>> listenMaterialChecklist();

  Future<void> saveMaterialWarehouse({required ItemModel material});
  Future<void> updateMaterialWarehouse({required ItemModel material});
  Future<void> deleteMaterialWarehouse({required ItemModel material});

  Future<List<ItemModel>> getMaterialsWarehouse();

  Future<bool> saveMaterialChecklist({
    required MaterialChecklistModel material,
    required List<OtherChangeModel> changes,
    required List<FileModel> deletedFiles,
  });

  Future<bool> deleteMaterialChecklist({
    required MaterialChecklistModel material,
  });
}
