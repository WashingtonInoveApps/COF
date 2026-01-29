// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String name;
  String registration;
  String contact;
  String email;
  String id;
  String graduation;
  String obmID;
  String fullname;

  bool adminFull;
  bool admin;
  bool enable;

  UserModel({
    this.name = '',
    this.registration = '',
    this.contact = '',
    this.email = '',
    this.id = '',
    this.graduation = '',
    this.obmID = '',
    this.fullname = '',
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
    bool? adminFull,
    bool? admin,
    bool? enable,
  }) {
    return UserModel(
      name: name ?? this.name,
      registration: registration ?? this.registration,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      id: id ?? this.id,
      graduation: graduation ?? this.graduation,
      obmID: obmID ?? this.obmID,
      fullname: fullname ?? this.fullname,
      adminFull: adminFull ?? this.adminFull,
      admin: admin ?? this.admin,
      enable: enable ?? this.enable,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'registration': registration,
      'contact': contact,
      'email': email,
      'id': id,
      'graduation': graduation,
      'obmID': obmID,
      'fullname': fullname,
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
      'graduation': graduation,
      'obmID': obmID,
      'fullname': fullname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      registration: map['registration'] ?? '',
      contact: map['contact'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      graduation: map['graduation'] ?? '',
      obmID: map['obmID'] ?? '',
      fullname: map['fullname'] ?? '',
      adminFull: map['adminFull'] ?? false,
      admin: map['admin'] ?? false,
      enable: map['enable'] ?? false,
    );
  }

  factory UserModel.fromMapResume(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        registration: map['registration'] ?? '',
        id: map['id'] ?? '',
        graduation: map['graduation'] ?? '',
        obmID: map['obmID'] ?? '',
        fullname: map['fullname'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, registration: $registration, contact: $contact, email: $email, id: $id, graduation: $graduation, obmID: $obmID, fullname: $fullname, adminFull: $adminFull, admin: $admin, )';
  }
}
