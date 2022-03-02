import 'package:bsu_control/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarStatusModel {
  String type;
  String description;
  DateTime date;
  bool value;
  UserModel user;
  String local;

  CarStatusModel({this.type = "", this.description = "", required this.date, this.value = false, required this.user, this.local = ""});

  factory CarStatusModel.from(Map<String, dynamic> json) => CarStatusModel(
      date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate(),
      user: UserModel.fromResume(json["user"]),
      description: json["description"],
      value: json["value"],
      local: json["local"],
      type: json["type"]);

  Map<String, dynamic> toJson() =>
      {"date": date, "type": type, "description": description, "value": value, "local": local, "user": user.toJsonResume()};
}
