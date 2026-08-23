// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/material_checklist_model.dart';

class ChecklistMaterialModel {
  String? id;
  MaterialChecklistModel material;
  List<ItemModel>? materialsConsumed;
  String obs;

  ChecklistMaterialModel({
    this.id,
    required this.material,
    this.materialsConsumed,
    this.obs = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'material': material.toMap(),
      'materialsConsumed': materialsConsumed?.map((x) => x.toMap()).toList(),
      'obs': obs,
    };
  }

  factory ChecklistMaterialModel.fromMap(Map<String, dynamic> map) {
    return ChecklistMaterialModel(
      id: map['id'] != null ? map['id'] as String : null,
      material: MaterialChecklistModel.fromMap(
          map['material'] as Map<String, dynamic>),
      materialsConsumed: map['materialsConsumed'] != null
          ? List<ItemModel>.from(
              (map['materialsConsumed'] as List).map<ItemModel?>(
                (x) => ItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      obs: map['obs'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistMaterialModel.fromJson(String source) =>
      ChecklistMaterialModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  ChecklistMaterialModel copyWith({
    String? id,
    MaterialChecklistModel? material,
    List<ItemModel>? materialsConsumed,
    String? obs,
  }) {
    return ChecklistMaterialModel(
      id: id ?? this.id,
      material: material ?? this.material,
      materialsConsumed: materialsConsumed ?? this.materialsConsumed,
      obs: obs ?? this.obs,
    );
  }
}
