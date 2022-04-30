import 'dart:convert';
import 'dart:typed_data';
import 'package:bsu_control/model/user_model.dart';

class CarChangeModel {
  double dx;
  double dy;
  String description;
  String image;
  String? checklistId;
  UserModel user;
  DateTime date;
  Uint8List? fileImage;
  bool value;

  CarChangeModel(
      {required this.dx,
      required this.dy,
      this.description = "",
      this.checklistId,
      this.image = "",
      required this.user,
      this.fileImage,
      required this.date,
      this.value = false});

  Map<String, dynamic> toMap() {
    return {
      'dx': dx,
      'dy': dy,
      'description': description,
      'image': image,
      'checklistId': checklistId,
      'user': user.toMapResume(),
      'date': date.millisecondsSinceEpoch,
      'value': value,
    };
  }

  factory CarChangeModel.fromMap(Map<String, dynamic> map) {
    return CarChangeModel(
      dx: map['dx']?.toDouble() ?? 0.0,
      dy: map['dy']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
      image: map['image'] ?? '',
      checklistId: map['checklistId'],
      user: UserModel.fromMapResume(map['user']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarChangeModel.fromJson(String source) => CarChangeModel.fromMap(json.decode(source));
}
