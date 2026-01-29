// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OBMModel {
  String? id;
  String prefix;
  String name;
  List<String> team;
  List<String> cias;

  OBMModel({
    this.id,
    this.prefix = '',
    this.name = '',
    required this.team,
    required this.cias,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'prefix': prefix,
      'name': name,
      'team': team,
      'cias': cias,
    };
  }

  factory OBMModel.fromMap(Map<String, dynamic> map) {
    return OBMModel(
        id: map['id'],
        prefix: map['prefix'] ?? '',
        name: map['name'] ?? '',
        team: List<String>.from((map['team'])),
        cias: List<String>.from((map['cias'])));
  }

  String toJson() => json.encode(toMap());

  factory OBMModel.fromJson(String source) =>
      OBMModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
