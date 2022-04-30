import 'dart:convert';

class UserModel {
  String name;
  String matricula;
  String contato;
  bool adm;
  bool enable;
  String email;
  String id;

  UserModel({this.name = "", this.matricula = "", this.adm = false, this.contato = "", this.enable = false, this.email = "", this.id = ""});

  Map<String, dynamic> toMap() {
    return {
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
    return {'name': name, 'matricula': matricula, 'id': id};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
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
    return UserModel(name: map['name'] ?? '', matricula: map['matricula'] ?? '', id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, matricula: $matricula, contato: $contato, adm: $adm, enable: $enable, email: $email, id: $id)';
  }
}
