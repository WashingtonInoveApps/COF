import 'dart:convert';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/user_model.dart';

class SupplyModel {
  String? id;
  String? checklistID;
  String? carID;
  UserModel user;
  CarModel car;
  String km;
  double litros;
  double value;
  DateTime date;

  SupplyModel({
    this.id,
    required this.car,
    required this.date,
    required this.user,
    this.checklistID,
    this.carID,
    this.km = "",
    this.litros = 0.0,
    this.value = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'car': car.toMapResume(),
      'checklistID': checklistID,
      'carID': carID,
      'user': user.toMapResume(),
      'km': km,
      'litros': litros,
      'value': value,
      'date': date.millisecondsSinceEpoch,
      'referenceMonth': "${date.month.toString().padLeft(2, '0')}/${date.year}"
    };
  }

  factory SupplyModel.fromMap(Map<String, dynamic> map) {
    return SupplyModel(
      id: map['id'],
      checklistID: map['checklistID'],
      carID: map['carID'],
      user: UserModel.fromMapResume(map['user']),
      car: CarModel.fromMapResume(map['car']),
      km: map['km'] ?? '',
      litros: map['litros']?.toDouble() ?? 0.0,
      value: map['value']?.toDouble() ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplyModel.fromJson(String source) =>
      SupplyModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SupplyModel(id: $id, checklistID: $checklistID, carID: $carID, user: $user, km: $km, litros: $litros, value: $value, date: $date)';
  }
}
