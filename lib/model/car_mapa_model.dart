import 'dart:convert';

import 'package:bsu_control/model/user_model.dart';

class CarMapaModel {
  String origin;
  String destiny;
  String kmStart;
  String kmFinal;
  DateTime date;
  UserModel user;
  String carId;
  String id;

  CarMapaModel(
      {this.id = "",
      this.origin = "",
      this.destiny = "",
      this.kmStart = "0",
      this.kmFinal = "0",
      required this.date,
      required this.user,
      required this.carId});

  Map<String, dynamic> toMap() {
    return {
      'origin': origin,
      'destiny': destiny,
      'kmStart': kmStart,
      'kmFinal': kmFinal,
      'date': date.millisecondsSinceEpoch,
      'user': user.toMapResume(),
      'carId': carId,
      'id': id,
    };
  }

  factory CarMapaModel.fromMap(Map<String, dynamic> map) {
    return CarMapaModel(
      origin: map['origin'] ?? '',
      destiny: map['destiny'] ?? '',
      kmStart: map['kmStart'] ?? '',
      kmFinal: map['kmFinal'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      user: UserModel.fromMapResume(map['user']),
      carId: map['carId'] ?? '',
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CarMapaModel.fromJson(String source) => CarMapaModel.fromMap(json.decode(source));
}
