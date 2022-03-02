import 'dart:typed_data';
import 'package:bsu_control/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarChangeModel {
  double dx;
  double dy;
  String description;
  String image;
  String? id;
  UserModel user;
  DateTime date;
  Uint8List? fileImage;
  bool value;

  CarChangeModel(
      {required this.dx,
      required this.dy,
      this.description = "",
      this.id,
      this.image = "",
      required this.user,
      this.fileImage,
      required this.date,
      this.value = false});

  factory CarChangeModel.from(Map<String, dynamic> json) => CarChangeModel(
      dx: json["dx"].toDouble(),
      dy: json["dy"].toDouble(),
      id: (json["id"] == null) ? null : json["id"],
      value: json["value"],
      user: UserModel.fromResume(json["user"]),
      date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate(),
      image: json["image"],
      description: json["description"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "date": date, "dx": dx, "dy": dy, "value": value, "description": description, "image": image, "user": user.toJsonResume()};
}
