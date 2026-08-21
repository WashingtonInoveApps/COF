import 'package:bsu_control/core/api_client.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/file_model.dart';
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
    return colItens.where('obmID', isEqualTo: obmID).snapshots().map(
          (e) => e.docs
              .map((doc) =>
                  ItemModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  @override
  Stream<List<MaterialChecklistModel>> listenMaterialChecklist() {
    return colMaterials.where('obmID', isEqualTo: obmID).snapshots().map(
          (e) => e.docs
              .map(
                (doc) => MaterialChecklistModel.fromMap(
                    doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  @override
  Future<void> saveMaterialWarehouse({required ItemModel material}) async {
    try {
      final doc = colItens.doc();
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
      await colItens.doc(material.id).update(material.toMap());
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteMaterialWarehouse({required ItemModel material}) async {
    try {
      await colItens.doc(material.id).delete();
      return;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemModel>> getMaterialsWarehouse() async {
    try {
      return await colItens.where('obmID', isEqualTo: obmID).get().then(
            (query) => query.docs
                .map((doc) =>
                    ItemModel.fromMap(doc.data() as Map<String, dynamic>))
                .toList(),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveMaterialChecklist({
    required MaterialChecklistModel material,
    required List<OtherChangeModel> others,
    required List<FileModel> deletedFiles,
  }) async {
    try {
      final docMaterials = colMaterials.doc(material.id);
      material.id = docMaterials.id;

      for (OtherChangeModel other in others) {
        if (other.image.data != null) {
          final path = material.team?.id ??
              DateTime.now().microsecondsSinceEpoch.toString();

          final image = await saveFile(
            pathStorage: Constants.pathOthersImages,
            data: other.image.data!,
            filename: path,
          );

          if (image == null) {
            throw Exception('Falha ao salvar imagem da alteração do material.');
          }

          other.image = other.image.copyWith(
            name: image.name,
            url: image.url,
            path: image.path,
          );
        }
      }

      if (deletedFiles.isNotEmpty) {
        for (final file in deletedFiles) {
          if (file.path.isNotEmpty) {
            await deleteFile(path: file.path, filename: file.name);
          }
        }
      }

      await docMaterials.set(material.copyWith(others: others).toMap());
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteMaterialChecklist(
      {required MaterialChecklistModel material}) async {
    try {
      await colMaterials.doc(material.id).delete();

      for (final OtherChangeModel other in (material.others ?? [])) {
        await deleteFile(path: other.image.path, filename: other.image.name);
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }
}
