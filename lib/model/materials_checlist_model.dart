// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/materials_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

class MaterialChecklistModel {
  String? id;
  MaterialsModel material;
  List<ItemModel>? materialsConsumed;
  List<OtherChangeModel>? others;
  String obs;

  MaterialChecklistModel({
    this.id,
    required this.material,
    this.materialsConsumed,
    this.others,
    this.obs = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'material': material.toMap(),
      'materialsConsumed': materialsConsumed?.map((x) => x.toMap()).toList(),
      'others': others?.map((x) => x.toMap()).toList(),
      'obs': obs,
    };
  }

  factory MaterialChecklistModel.fromMap(Map<String, dynamic> map) {
    return MaterialChecklistModel(
      id: map['id'] != null ? map['id'] as String : null,
      material: MaterialsModel.fromMap(map['material'] as Map<String, dynamic>),
      materialsConsumed: map['materialsConsumed'] != null
          ? List<ItemModel>.from(
              (map['materialsConsumed'] as List).map<ItemModel?>(
                (x) => ItemModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      others: map['others'] != null
          ? List<OtherChangeModel>.from(
              (map['others'] as List).map<OtherChangeModel?>(
                (x) => OtherChangeModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      obs: map['obs'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaterialChecklistModel.fromJson(String source) =>
      MaterialChecklistModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
