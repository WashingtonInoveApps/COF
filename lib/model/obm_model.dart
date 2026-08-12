// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/team_model.dart';

class OBMModel {
  String? id;
  String prefix;
  String name;
  List<TeamModel> team;
  List<CiaModel> cias;

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
      'team': team.map((e) => e.toMap()).toList(),
      'cias': cias.map((e) => e.toMap()).toList(),
    };
  }

  Map<String, dynamic> toMapResume() {
    return <String, dynamic>{
      'id': id,
      'prefix': prefix,
      'name': name,
    };
  }

  factory OBMModel.fromMap(Map<String, dynamic> map) {
    return OBMModel(
      id: map['id'],
      prefix: map['prefix'] ?? '',
      name: map['name'] ?? '',
      team: List<TeamModel>.from(
          (map['team'] as List).map((e) => TeamModel.fromMap(e))),
      cias: List<CiaModel>.from(
          (map['cias'] as List).map((e) => CiaModel.fromMap(e))),
    );
  }

  factory OBMModel.fromMapResume(Map<String, dynamic> map) {
    return OBMModel(
        id: map['id'],
        prefix: map['prefix'] ?? '',
        name: map['name'] ?? '',
        cias: [],
        team: []);
  }

  String toJson() => json.encode(toMap());

  factory OBMModel.fromJson(String source) =>
      OBMModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
