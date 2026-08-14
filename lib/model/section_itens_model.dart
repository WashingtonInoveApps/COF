// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'item_model.dart';

class SectionItensModel {
  String id;
  String description;
  List<ItemModel> itens;
  String obs;
  bool value;

  SectionItensModel(
      {required this.id,
      required this.description,
      required this.itens,
      this.value = false,
      this.obs = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'itens': itens.map((x) => x.toMap()).toList(),
      'obs': obs,
      'value': value,
    };
  }

  factory SectionItensModel.fromMap(Map<String, dynamic> map) {
    return SectionItensModel(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      itens:
          List<ItemModel>.from(map['itens']?.map((x) => ItemModel.fromMap(x))),
      obs: map['obs'] ?? '',
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionItensModel.fromJson(String source) =>
      SectionItensModel.fromMap(json.decode(source));

  SectionItensModel copyWith({
    String? id,
    String? description,
    List<ItemModel>? itens,
    String? obs,
    bool? value,
  }) {
    return SectionItensModel(
      id: id ?? this.id,
      description: description ?? this.description,
      itens: itens ?? this.itens,
      obs: obs ?? this.obs,
      value: value ?? this.value,
    );
  }
}
