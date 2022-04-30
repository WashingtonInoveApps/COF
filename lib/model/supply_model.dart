import 'dart:convert';
import 'package:bsu_control/model/user_model.dart';
class SupplyModel {
  String? id;
  String? checklistId;
  String? carId;
  UserModel user;
  String kmSupply;
  double litros;
  double value;
  DateTime date;

  SupplyModel({this.id, this.checklistId, this.carId, required this.user , this.kmSupply = "", this.litros = 0.0, this.value = 0.0, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checklistId': checklistId,
      'carId': carId,
      'user': user.toMapResume(),
      'kmSupply': kmSupply,
      'litros': litros,
      'value': value,
      'date': date.millisecondsSinceEpoch,
      'referenceMonth': "${date.month.toString().padLeft(2, '0')}/${date.year}"
    };
  }

  factory SupplyModel.fromMap(Map<String, dynamic> map) {
    return SupplyModel(
      id: map['id'],
      checklistId: map['checklistId'],
      carId: map['carId'],
      user: UserModel.fromMapResume(map['user']),
      kmSupply: map['kmSupply'] ?? '',
      litros: map['litros']?.toDouble() ?? 0.0,
      value: map['value']?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplyModel.fromJson(String source) => SupplyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SupplyModel(id: $id, checklistId: $checklistId, carId: $carId, user: $user, kmSupply: $kmSupply, litros: $litros, value: $value, date: $date)';
  }
}
