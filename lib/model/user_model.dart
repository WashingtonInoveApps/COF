// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? id;
  String name;
  String registration;
  String contact;
  String email;
  String graduation;
  String obmID;
  String cia;
  String fullname;
  String acessToken;
  String codeVerifyPassword;

  bool adminFull;
  bool admin;
  bool enable;

  UserModel({
    this.name = '',
    this.registration = '',
    this.contact = '',
    this.email = '',
    this.id,
    this.graduation = '',
    this.obmID = '',
    this.fullname = '',
    this.cia = '',
    this.acessToken = '',
    this.codeVerifyPassword = '',
    this.adminFull = false,
    this.admin = false,
    this.enable = false,
  });

  UserModel copyWith({
    String? name,
    String? registration,
    String? contact,
    String? email,
    String? id,
    String? graduation,
    String? obmID,
    String? fullname,
    String? cia,
    String? acessToken,
    String? codeVerifyPassword,
    bool? adminFull,
    bool? admin,
    bool? enable,
  }) {
    return UserModel(
      name: name ?? this.name,
      cia: cia ?? this.cia,
      registration: registration ?? this.registration,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      id: id ?? this.id,
      graduation: graduation ?? this.graduation,
      obmID: obmID ?? this.obmID,
      fullname: fullname ?? this.fullname,
      adminFull: adminFull ?? this.adminFull,
      acessToken: acessToken ?? this.acessToken,
      codeVerifyPassword: codeVerifyPassword ?? this.codeVerifyPassword,
      admin: admin ?? this.admin,
      enable: enable ?? this.enable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cia': cia,
      'registration': registration,
      'contact': contact,
      'email': email,
      'id': id,
      'graduation': graduation,
      'obmID': obmID,
      'fullname': fullname,
      'acessToken': acessToken,
      'codeVerifyPassword': codeVerifyPassword,
      'adminFull': adminFull,
      'admin': admin,
      'enable': enable,
    };
  }

  Map<String, dynamic> toMapResume() {
    return <String, dynamic>{
      'name': name,
      'registration': registration,
      'id': id,
      'cia': cia,
      'graduation': graduation,
      'obmID': obmID,
      'fullname': fullname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'] ?? '',
      cia: map['cia'] ?? '',
      registration: map['registration'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      graduation: map['graduation'] ?? '',
      obmID: map['obmID'] ?? '',
      fullname: map['fullname'] ?? '',
      codeVerifyPassword: map['codeVerifyPassword'] ?? '',
      acessToken: map['acessToken'] ?? '',
      adminFull: map['adminFull'] ?? false,
      admin: map['admin'] ?? false,
      enable: map['enable'] ?? false,
    );
  }

  factory UserModel.fromMapResume(Map<String, dynamic> map) {
    return UserModel(
        id: map['id'],
        name: map['name'] ?? '',
        registration: map['registration'] ?? '',
        cia: map['cia'] ?? '',
        graduation: map['graduation'] ?? '',
        obmID: map['obmID'] ?? '',
        fullname: map['fullname'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
