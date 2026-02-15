import 'dart:convert';

class ItemModel {
  String id;
  String description;
  bool value;
  int quantity;
  int quantityMarked;

  ItemModel(
      {required this.id,
      required this.description,
      this.value = false,
      this.quantity = 0,
      this.quantityMarked = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'value': value,
      'quantity': quantity,
      'quantityMarked': quantityMarked
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] ?? '',
      description: map['description'] ?? '',
      value: map['value'] ?? false,
      quantity: map['quantity']?.toInt() ?? 0,
      quantityMarked: map['quantityMarked']?.toInt() ?? 0,
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
    bool? value,
    int? quantity,
    int? quantityMarked,
  }) {
    return ItemModel(
        id: id ?? this.id,
        description: description ?? this.description,
        value: value ?? this.value,
        quantity: quantity ?? this.quantity,
        quantityMarked: quantityMarked ?? this.quantityMarked);
  }
}
