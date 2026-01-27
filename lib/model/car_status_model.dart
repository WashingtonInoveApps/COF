// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/user_model.dart';

class CarStatusModel {
  String? id;
  String type;
  String carID;
  String description;
  DateTime date;
  bool value;
  UserModel user;
  List<CarStatusDetailsModel>? details;
  String local;

  CarStatusModel(
      {this.id,
      this.type = "",
      this.description = "",
      this.carID = '',
      required this.date,
      this.details,
      this.value = false,
      required this.user,
      this.local = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'carID': carID,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'value': value,
      'user': user.toMapResume(),
      'details': details?.map((e) => e.toMap()).toList(),
      'local': local,
    };
  }

  factory CarStatusModel.fromMap(Map<String, dynamic> map) {
    return CarStatusModel(
      id: map['id'],
      type: map['type'] ?? '',
      carID: map['carID'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? false,
      user: UserModel.fromMapResume(map['user']),
      details: (map['details'] != null)
          ? List<CarStatusDetailsModel>.from(
              map['details']?.map((e) => CarStatusDetailsModel.fromMap(e)))
          : null,
      local: map['local'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarStatusModel.fromJson(String source) =>
      CarStatusModel.fromMap(json.decode(source));

  CarStatusModel copyWith({
    String? id,
    String? type,
    String? carID,
    String? description,
    DateTime? date,
    bool? value,
    UserModel? user,
    String? local,
  }) {
    return CarStatusModel(
      id: id ?? this.id,
      type: type ?? this.type,
      carID: carID ?? this.carID,
      description: description ?? this.description,
      date: date ?? this.date,
      value: value ?? this.value,
      user: user ?? this.user,
      local: local ?? this.local,
    );
  }
}

class CarStatusDetailsModel {
  final DateTime date;
  final String description;
  final UserModel user;

  CarStatusDetailsModel(
      {required this.date, required this.description, required this.user});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'description': description,
      'user': user.toMapResume(),
    };
  }

  factory CarStatusDetailsModel.fromMap(Map<String, dynamic> map) {
    return CarStatusDetailsModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      description: map['description'] as String,
      user: UserModel.fromMapResume(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CarStatusDetailsModel.fromJson(String source) =>
      CarStatusDetailsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
