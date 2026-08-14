// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TeamModel {
  String? id;
  String name;
  String obmID;
  String ciaID;

  TeamModel({
    this.id,
    this.name = '',
    this.obmID = '',
    this.ciaID = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'obmID': obmID,
      'ciaID': ciaID,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['id'],
      name: map['name'] ?? '',
      obmID: map['obmID'] ?? '',
      ciaID: map['ciaID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamModel.fromJson(String source) =>
      TeamModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
