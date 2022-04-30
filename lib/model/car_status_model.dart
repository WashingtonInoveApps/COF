import 'dart:convert';
import 'package:bsu_control/model/user_model.dart';

class CarStatusModel {
  String? id;
  String type;
  String description;
  DateTime date;
  bool value;
  UserModel user;
  String local;

  CarStatusModel({this.id, this.type = "", this.description = "", required this.date, this.value = false, required this.user, this.local = ""});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'value': value,
      'user': user.toMapResume(),
      'local': local,
    };
  }

  factory CarStatusModel.fromMap(Map<String, dynamic> map) {
    return CarStatusModel(
      id: map['id'],
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? false,
      user: UserModel.fromMapResume(map['user']),
      local: map['local'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarStatusModel.fromJson(String source) => CarStatusModel.fromMap(json.decode(source));
}
