import 'package:bsu_control/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CarMapaModel {
  String origem;
  String destino;
  String kmInicial;
  String kmFinal;
  DateTime date;
  UserModel user;
  String carId;
  String id;

  CarMapaModel(
      {this.id = "",
      this.origem = "",
      this.destino = "",
      this.kmInicial = "",
      this.kmFinal = "",
      required this.date,
      required this.user,
      required this.carId});

  factory CarMapaModel.from(Map<String, dynamic> json) => CarMapaModel(
        id: json["id"],
        carId: json["carId"],
        date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate(),
        origem: json["origem"],
        destino: json["destino"],
        kmInicial: json["kmInicial"],
        kmFinal: json["kmFinal"],
        user: UserModel.fromResume(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "origem": origem,
        "destino": destino,
        "carId": carId,
        "kmInicial": kmInicial,
        "kmFinal": kmFinal,
        "date": date,
        "user": user.toJsonResume()
      };
}
