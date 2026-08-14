import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/item_model.dart';

import 'material_interface.dart';

class MaterialRepository extends APIClient implements IMaterialRepository {
  final String obmID;

  MaterialRepository(
      {required String endpoint,
      required String appID,
      required bool test,
      required this.obmID})
      : super(endpoint: endpoint, appID: appID, test: test);

  @override
  Stream<List<ItemModel>> listenMaterialsWarehouse() {
    return colOBMs.doc(obmID).collection('materials').snapshots().map(
        (e) => e.docs.map((doc) => ItemModel.fromMap(doc.data())).toList());
  }

  @override
  Future<void> saveMaterialWarehouse({required ItemModel material}) async {
    try {
      final doc = colOBMs.doc(obmID).collection('materials').doc();
      material.id = doc.id;

      await doc.set(material.toMap());
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateMaterialWarehouse({required ItemModel material}) async {
    try {
      final doc = colOBMs.doc(obmID).collection('materials').doc(material.id);
      await doc.update(material.toMap());
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMaterialWarehouse({required ItemModel material}) async {
    try {
      await colOBMs
          .doc(obmID)
          .collection('materials')
          .doc(material.id)
          .delete();
      return;
    } catch (e) {
      rethrow;
    }
  }
}
