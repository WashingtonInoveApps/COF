import 'package:bsu_control/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplyModel {
  String? id;
  String? idCheckList;
  UserModel user;
  String kmAbastecimento;
  double litros;
  double value;
  DateTime date;

  SupplyModel({this.id, this.idCheckList, required this.user , this.kmAbastecimento = "", this.litros = 0.0, this.value = 0.0, required this.date});

  factory SupplyModel.from(Map<String, dynamic> json) => SupplyModel(
      id: json['id'],
      idCheckList: json['idCheckList'],
      user: UserModel.fromResume(json['user']),
      kmAbastecimento: json["kmAbastecimento"],
      litros: json["litros"],
      value: json["value"],
      date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate());

  Map<String, dynamic> toJson() =>
      {'id': id, "idCheckList": idCheckList, "user": user.toJsonResume(), "date": date, "kmAbastecimento": kmAbastecimento, "litros": litros, "value": value};
}
