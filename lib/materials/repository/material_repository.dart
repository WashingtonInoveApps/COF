import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

import '../../model/material_checklist_model.dart';
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
    return colOBMs.doc(obmID).collection('itens').snapshots().map(
        (e) => e.docs.map((doc) => ItemModel.fromMap(doc.data())).toList());
  }

  @override
  Stream<List<MaterialChecklistModel>> listenMaterialChecklist() {
    return colOBMs.doc(obmID).collection('materials').snapshots().map((e) => e
        .docs
        .map((doc) => MaterialChecklistModel.fromMap(doc.data()))
        .toList());
  }

  @override
  Future<void> saveMaterialWarehouse({required ItemModel material}) async {
    try {
      final doc = colOBMs.doc(obmID).collection('itens').doc();
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
      final doc = colOBMs.doc(obmID).collection('itens').doc(material.id);
      await doc.update(material.toMap());
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMaterialWarehouse({required ItemModel material}) async {
    try {
      await colOBMs.doc(obmID).collection('itens').doc(material.id).delete();
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemModel>> getMaterialsWarehouse() async {
    try {
      return await colOBMs.doc(obmID).collection('itens').get().then((query) =>
          query.docs.map((doc) => ItemModel.fromMap(doc.data())).toList());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveMaterialChecklist({
    required MaterialChecklistModel material,
    required List<OtherChangeModel> changes,
  }) async {
    try {
      final docMaterials = colOBMs.doc(obmID).collection('materials').doc();
      material.id = docMaterials.id;

      for (OtherChangeModel change in changes) {
        if (change.fileImage != null) {
          final path = material.team?.id ??
              DateTime.now().microsecondsSinceEpoch.toString();

          change.image = await saveFile(
              pathStorage: 'imagens/material/changes/$path',
              data: change.fileImage!,
              filename: '${path}_${DateTime.now().millisecondsSinceEpoch}.png');

          if (change.image == null) {
            throw Exception('Falha ao salvar imagem da alteração do material.');
          }
        }
      }

      await docMaterials.set(material.copyWith(changes: changes).toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
