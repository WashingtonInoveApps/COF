// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/cep_model.dart';

class CiaModel {
  final String? id;
  final String name;
  final String obmID;
  final String contact;
  final CEPModel? adress;

  CiaModel({
    required this.id,
    required this.name,
    required this.obmID,
    this.contact = '',
    this.adress,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'obmID': obmID,
      'contact': contact,
      'adress': adress?.toMap(),
    };
  }

  Map<String, dynamic> toMapResume() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'obmID': obmID,
    };
  }

  factory CiaModel.fromMap(Map<String, dynamic> map) {
    return CiaModel(
      id: map['id'],
      name: map['name'] ?? '',
      obmID: map['obmID'] ?? '',
      contact: map['contact'] ?? '',
      adress: map['adress'] != null
          ? CEPModel.fromMap(map['adress'] as Map<String, dynamic>)
          : null,
    );
  }

  factory CiaModel.fromMapResume(Map<String, dynamic> map) {
    return CiaModel(
      id: map['id'],
      name: map['name'] ?? '',
      obmID: map['obmID'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CiaModel.fromJson(String source) =>
      CiaModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
