class ItensChangesModel {
  String description;
  List<ItemModel> itens;
  String obs;
  bool value;

  ItensChangesModel({required this.description, required this.itens, this.value = false, this.obs = ""});

  factory ItensChangesModel.from(Map<String, dynamic> json) => ItensChangesModel(description: json["description"], value: json["value"], obs: json["obs"], itens: List<ItemModel>.from(json["itens"].map((e) => ItemModel.from(e))));

  Map<String, dynamic> toJson() => {
        "description": description,
        "itens": List<dynamic>.from(itens.map((e) => e.toJson()).toList()),
        "obs": obs,
        "value": value,
      };
}

class ItemModel {
  String description;
  bool value;

  ItemModel({required this.description, this.value = false});

  factory ItemModel.from(Map<String, dynamic> json) => ItemModel(description: json["description"], value: json["value"]);

  Map<String, dynamic> toJson() => {"description": description, "value": value};
}
