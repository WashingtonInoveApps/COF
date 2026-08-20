import 'dart:convert';

import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/user_model.dart';

class OtherChangeModel {
  String description;
  DateTime date;
  FileModel image;
  UserModel user;
  String id;
  String checklistID;

  OtherChangeModel({
    required this.id,
    required this.date,
    this.description = '',
    required this.image,
    required this.user,
    this.checklistID = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'image': image.toMap(),
      'user': user.toMapResume(),
      'checklistID': checklistID,
    };
  }

  factory OtherChangeModel.fromMap(Map<String, dynamic> map) {
    return OtherChangeModel(
      id: map['id'] ?? '',
      checklistID: map['checklistID'] ?? '',
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      image: FileModel.fromMap(map['image'] as Map<String, dynamic>),
      user: UserModel.fromMapResume(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherChangeModel.fromJson(String source) =>
      OtherChangeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
