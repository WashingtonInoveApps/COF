// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'item_model.dart';

class ItensChangesModel {
  String description;
  List<ItemModel> itens;
  String obs;
  bool value;

  ItensChangesModel(
      {required this.description,
      required this.itens,
      this.value = false,
      this.obs = ""});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'itens': itens.map((x) => x.toMap()).toList(),
      'obs': obs,
      'value': value,
    };
  }

  factory ItensChangesModel.fromMap(Map<String, dynamic> map) {
    return ItensChangesModel(
      description: map['description'] ?? '',
      itens:
          List<ItemModel>.from(map['itens']?.map((x) => ItemModel.fromMap(x))),
      obs: map['obs'] ?? '',
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItensChangesModel.fromJson(String source) =>
      ItensChangesModel.fromMap(json.decode(source));

  ItensChangesModel copyWith({
    String? description,
    List<ItemModel>? itens,
    String? obs,
    bool? value,
  }) {
    return ItensChangesModel(
      description: description ?? this.description,
      itens: itens ?? this.itens,
      obs: obs ?? this.obs,
      value: value ?? this.value,
    );
  }
}
