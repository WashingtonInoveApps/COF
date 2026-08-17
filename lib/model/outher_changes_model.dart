import 'dart:convert';

import 'package:bsu_control/model/file_model.dart';

class OtherChangeModel {
  String description;
  DateTime date;
  FileModel image;

  OtherChangeModel({
    required this.date,
    this.description = '',
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'image': image.toMap(),
    };
  }

  factory OtherChangeModel.fromMap(Map<String, dynamic> map) {
    return OtherChangeModel(
      description: map['description'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      image: FileModel.fromMap(map['image'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherChangeModel.fromJson(String source) =>
      OtherChangeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
