// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String name;
  String matricula;
  String contato;
  String email;
  String id;
  String graduacao;
  String obm;
  String fullname;

  bool adminFull;
  bool admin;
  bool adminFleet;
  bool adminMaterial;
  bool enable;
  bool fleet;
  bool material;
  bool samu;

  UserModel({
    this.name = '',
    this.matricula = '',
    this.contato = '',
    this.email = '',
    this.id = '',
    this.graduacao = '',
    this.obm = '',
    this.fullname = '',
    this.adminFull = false,
    this.admin = false,
    this.adminFleet = false,
    this.adminMaterial = false,
    this.enable = false,
    this.fleet = false,
    this.material = false,
    this.samu = false,
  });

  UserModel copyWith({
    String? name,
    String? matricula,
    String? contato,
    String? email,
    String? id,
    String? graduacao,
    String? obm,
    String? fullname,
    bool? adminFull,
    bool? admin,
    bool? adminFleet,
    bool? adminMaterial,
    bool? enable,
    bool? fleet,
    bool? material,
    bool? samu,
  }) {
    return UserModel(
      name: name ?? this.name,
      matricula: matricula ?? this.matricula,
      contato: contato ?? this.contato,
      email: email ?? this.email,
      id: id ?? this.id,
      graduacao: graduacao ?? this.graduacao,
      obm: obm ?? this.obm,
      fullname: fullname ?? this.fullname,
      adminFull: adminFull ?? this.adminFull,
      admin: admin ?? this.admin,
      adminFleet: adminFleet ?? this.adminFleet,
      adminMaterial: adminMaterial ?? this.adminMaterial,
      enable: enable ?? this.enable,
      fleet: fleet ?? this.fleet,
      material: material ?? this.material,
      samu: samu ?? this.samu,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'matricula': matricula,
      'contato': contato,
      'email': email,
      'id': id,
      'graduacao': graduacao,
      'obm': obm,
      'fullname': fullname,
      'adminFull': adminFull,
      'admin': admin,
      'adminFleet': adminFleet,
      'adminMaterial': adminMaterial,
      'enable': enable,
      'fleet': fleet,
      'material': material,
      'samu': samu,
    };
  }

  Map<String, dynamic> toMapResume() {
    return <String, dynamic>{
      'name': name,
      'matricula': matricula,
      'id': id,
      'graduacao': graduacao,
      'obm': obm,
      'fullname': fullname,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      matricula: map['matricula'] ?? '',
      contato: map['contato'] ?? '',
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      graduacao: map['graduacao'] ?? '',
      obm: map['obm'] ?? '',
      fullname: map['fullname'] ?? '',
      adminFull: map['adminFull'] ?? false,
      admin: map['admin'] ?? false,
      adminFleet: map['adminFleet'] ?? false,
      adminMaterial: map['adminMaterial'] ?? false,
      enable: map['enable'] ?? false,
      fleet: map['fleet'] ?? false,
      material: map['material'] ?? false,
      samu: map['samu'] ?? false,
    );
  }

  factory UserModel.fromMapResume(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        matricula: map['matricula'] ?? '',
        id: map['id'] ?? '',
        graduacao: map['graduacao'] ?? '',
        obm: map['obm'] ?? '',
        fullname: map['fullname'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, matricula: $matricula, contato: $contato, email: $email, id: $id, graduacao: $graduacao, obm: $obm, fullname: $fullname, adminFull: $adminFull, admin: $admin, adminFleet: $adminFleet, adminMaterial: $adminMaterial, enable: $enable, fleet: $fleet, material: $material, samu: $samu)';
  }
}
