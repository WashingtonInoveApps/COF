import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyModel {
  String kmAbastecimento;
  double litros;
  double value;
  DateTime date;

  SupplyModel({this.kmAbastecimento = "", this.litros = 0.0, this.value = 0.0, required this.date});

  factory SupplyModel.from(Map<String, dynamic> json) => SupplyModel(
      kmAbastecimento: json["kmAbastecimento"],
      litros: json["litros"],
      value: json["value"],
      date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate());

  Map<String, dynamic> toJson() => {"date": date, "kmAbastecimento": kmAbastecimento, "litros": litros, "value": value};
}
