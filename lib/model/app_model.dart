// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AppModel {
  int version;
  List<String> carsTypes;

  AppModel({required this.carsTypes, this.version = 1});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'carsTypes': carsTypes,
    };
  }

  factory AppModel.fromMap(Map<String, dynamic> map) {
    return AppModel(
        version: map['version'] as int,
        carsTypes: List<String>.from(map['carsTypes']));
  }

  String toJson() => json.encode(toMap());

  factory AppModel.fromJson(String source) =>
      AppModel.fromMap(json.decode(source) as Map<String, dynamic>);

  AppModel copyWith({
    int? version,
    List<String>? carsTypes,
  }) {
    return AppModel(
      version: version ?? this.version,
      carsTypes: carsTypes ?? this.carsTypes,
    );
  }
}
