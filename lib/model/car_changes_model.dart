import 'dart:convert';

import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/user_model.dart';

class CarChangeModel {
  String id;
  double dx;
  double dy;
  String description;
  FileModel? image;
  String? checklistID;
  UserModel user;
  DateTime date;
  String imageID;
  bool value;
  int indexImage;

  CarChangeModel({
    required this.id,
    required this.dx,
    required this.dy,
    required this.imageID,
    this.description = "",
    this.checklistID,
    this.image,
    required this.indexImage,
    required this.user,
    // this.fileImage,
    required this.date,
    this.value = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dx': dx,
      'dy': dy,
      'imageID': imageID,
      'description': description,
      'image': image?.toMap(),
      'checklistID': checklistID,
      'user': user.toMapResume(),
      'date': date.millisecondsSinceEpoch,
      'value': value,
      'indexImagem': indexImage
    };
  }

  factory CarChangeModel.fromMap(Map<String, dynamic> map) {
    return CarChangeModel(
      id: map['id'],
      dx: map['dx']?.toDouble() ?? 0.0,
      dy: map['dy']?.toDouble() ?? 0.0,
      imageID: map['imageID'] ?? '',
      description: map['description'] ?? '',
      image: (map['image'] != null) ? FileModel.fromMap(map['image']) : null,
      indexImage: map['indexImage']?.toInt() ?? 0,
      checklistID: map['checklistID'],
      user: UserModel.fromMapResume(map['user']),
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarChangeModel.fromJson(String source) =>
      CarChangeModel.fromMap(json.decode(source));
}
