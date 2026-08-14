import 'dart:convert';

import 'package:bsu_control/enum/core_enum.dart';

class ItemModel {
  String id;
  String description;
  String register;
  bool value;
  int quantity;
  int quantityMarked;
  DateTime? validity;
  ItemStatus status;
  ItemUnit unit;

  ItemModel({
    required this.id,
    required this.description,
    this.value = false,
    this.quantity = 0,
    this.quantityMarked = 0,
    this.status = ItemStatus.normal,
    this.unit = ItemUnit.un,
    this.validity,
    this.register = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'register': register,
      'value': value,
      'quantity': quantity,
      'quantityMarked': quantityMarked,
      'status': status.name,
      'unit': unit.name,
      'validity': validity?.millisecondsSinceEpoch,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      register: map['register'] ?? '',
      value: map['value'] ?? false,
      quantity: map['quantity']?.toInt() ?? 0,
      quantityMarked: map['quantityMarked']?.toInt() ?? 0,
      status: (map['status'] != null)
          ? CoreEnum.itemStatusFromString(map['status'])
          : ItemStatus.normal,
      unit: (map['unit'] != null)
          ? CoreEnum.itemUnitFromString(map['unit'])
          : ItemUnit.un,
      validity: map['validity'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['validity'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ItemModel(description: $description, value: $value, quantity: $quantity)';

  ItemModel copyWith({
    String? id,
    String? description,
    String? register,
    bool? value,
    int? quantity,
    int? quantityMin,
    int? quantityMarked,
    ItemStatus? status,
    ItemUnit? unit,
    DateTime? validity,
  }) {
    return ItemModel(
        id: id ?? this.id,
        validity: validity ?? this.validity,
        unit: unit ?? this.unit,
        description: description ?? this.description,
        register: register ?? this.register,
        value: value ?? this.value,
        quantity: quantity ?? this.quantity,
        quantityMarked: quantityMarked ?? this.quantityMarked);
  }
}
