// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'cia_model.dart';

class UserModel {
  String? id;
  String name;
  String registration;
  String contact;
  String email;
  String graduation;
  String obmID;
  String ciaID;
  CiaModel? cia;
  String fullname;
  String acessToken;
  String codeVerifyPassword;

  bool admin;
  bool enable;
  bool battalion;
  bool company;
  bool managerOperational;
  bool managerFleet;

  UserModel({
    this.id,
    this.name = '',
    this.ciaID = '',
    this.registration = '',
    this.contact = '',
    this.email = '',
    this.graduation = '',
    this.obmID = '',
    this.cia,
    this.fullname = '',
    this.acessToken = '',
    this.codeVerifyPassword = '',
    this.admin = false,
    this.enable = false,
    this.battalion = false,
    this.company = false,
    this.managerOperational = false,
    this.managerFleet = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ciaID': ciaID,
      'registration': registration,
      'contact': contact,
      'email': email,
      'graduation': graduation,
      'obmID': obmID,
      'cia': cia?.toMapResume(),
      'fullname': fullname,
      'acessToken': acessToken,
      'codeVerifyPassword': codeVerifyPassword,
      'admin': admin,
      'enable': enable,
      'battalion': battalion,
      'company': company,
      'managerOperational': managerOperational,
      'managerFleet': managerFleet,
    };
  }

  Map<String, dynamic> toMapResume() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ciaID': ciaID,
      'registration': registration,
      'contact': contact,
      'email': email,
      'graduation': graduation,
      'obmID': obmID,
      'cia': cia?.toMapResume(),
      'fullname': fullname
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      registration: map['registration'] ?? '',
      contact: map['contact'] ?? '',
      ciaID: map['ciaID'] ?? '',
      email: map['email'] ?? '',
      graduation: map['graduation'] ?? '',
      obmID: map['obmID'] ?? '',
      cia: (map['cia'] != null) ? CiaModel.fromMap(map['cia']) : null,
      fullname: map['fullname'] ?? '',
      acessToken: map['acessToken'] ?? '',
      codeVerifyPassword: map['codeVerifyPassword'] ?? '',
      admin: map['admin'] ?? false,
      enable: map['enable'] ?? false,
      battalion: map['battalion'] ?? false,
      company: map['company'] ?? false,
      managerOperational: map['managerOperational'] ?? false,
      managerFleet: map['managerFleet'] ?? false,
    );
  }

  factory UserModel.fromMapResume(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'] ?? '',
        registration: map['registration'] ?? '',
        contact: map['contact'] ?? '',
        email: map['email'] ?? '',
        graduation: map['graduation'] ?? '',
        obmID: map['obmID'] ?? '',
        ciaID: map['ciaID'] ?? '',
        cia: (map['cia'] != null) ? CiaModel.fromMap(map['cia']) : null,
        fullname: map['fullname'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserModel copyWith({
    String? id,
    String? name,
    String? registration,
    String? contact,
    String? email,
    String? graduation,
    String? obmID,
    CiaModel? cia,
    String? fullname,
    String? ciaID,
    String? acessToken,
    String? codeVerifyPassword,
    bool? admin,
    bool? enable,
    bool? battalion,
    bool? company,
    bool? managerOperational,
    bool? managerFleet,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      registration: registration ?? this.registration,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      ciaID: ciaID ?? this.ciaID,
      graduation: graduation ?? this.graduation,
      obmID: obmID ?? this.obmID,
      cia: cia ?? this.cia,
      fullname: fullname ?? this.fullname,
      acessToken: acessToken ?? this.acessToken,
      codeVerifyPassword: codeVerifyPassword ?? this.codeVerifyPassword,
      admin: admin ?? this.admin,
      enable: enable ?? this.enable,
      battalion: battalion ?? this.battalion,
      company: company ?? this.company,
      managerOperational: managerOperational ?? this.managerOperational,
      managerFleet: managerFleet ?? this.managerFleet,
    );
  }
}
