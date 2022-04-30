import 'dart:convert';

class ItensChangesModel {
  String description;
  List<ItemModel> itens;
  String obs;
  bool value;

  ItensChangesModel({required this.description, required this.itens, this.value = false, this.obs = ""});

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
      itens: List<ItemModel>.from(map['itens']?.map((x) => ItemModel.fromMap(x))),
      obs: map['obs'] ?? '',
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItensChangesModel.fromJson(String source) => ItensChangesModel.fromMap(json.decode(source));
}

class ItemModel {
  String description;
  bool value;

  ItemModel({required this.description, this.value = false});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'value': value,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      description: map['description'] ?? '',
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source));

  @override
  String toString() => 'ItemModel(description: $description, value: $value)';
}
