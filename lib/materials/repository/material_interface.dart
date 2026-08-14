import 'package:bsu_control/model/item_model.dart';

abstract class IMaterialRepository {
  Stream<List<ItemModel>> listenMaterialsWarehouse();
  Future<void> saveMaterialWarehouse({required ItemModel material});
  Future<void> updateMaterialWarehouse({required ItemModel material});
  Future<void> deleteMaterialWarehouse({required ItemModel material});
}
