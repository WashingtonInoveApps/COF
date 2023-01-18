// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String name;
  String matricula;
  String contato;
  bool adm;
  bool enable;
  String email;
  String id;
  String graduacao;

  UserModel(
      {this.graduacao = '',
      this.name = "",
      this.matricula = "",
      this.adm = false,
      this.contato = "",
      this.enable = false,
      this.email = "",
      this.id = ""});

  Map<String, dynamic> toMap() {
    return {
      'graduacao': graduacao,
      'name': name,
      'matricula': matricula,
      'contato': contato,
      'adm': adm,
      'enable': enable,
      'email': email,
      'id': id,
    };
  }

  Map<String, dynamic> toMapResume() {
    return {
      'graduacao': graduacao,
      'name': name,
      'matricula': matricula,
      'id': id
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      graduacao: map['graduacao'] ?? '',
      name: map['name'] ?? '',
      matricula: map['matricula'] ?? '',
      contato: map['contato'] ?? '',
      adm: map['adm'] ?? false,
      enable: map['enable'] ?? false,
      email: map['email'] ?? '',
      id: map['id'] ?? '',
    );
  }

  factory UserModel.fromMapResume(Map<String, dynamic> map) {
    return UserModel(
        graduacao: map['graduacao'] ?? '',
        name: map['name'] ?? '',
        matricula: map['matricula'] ?? '',
        id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(graduacao: $graduacao, name: $name, matricula: $matricula, contato: $contato, adm: $adm, enable: $enable, email: $email, id: $id)';
  }

  UserModel copyWith({
    String? name,
    String? matricula,
    String? contato,
    bool? adm,
    bool? enable,
    String? email,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      matricula: matricula ?? this.matricula,
      contato: contato ?? this.contato,
      adm: adm ?? this.adm,
      enable: enable ?? this.enable,
      email: email ?? this.email,
      id: id ?? this.id,
    );
  }
}
