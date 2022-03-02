class UserModel {
  String name;
  String matricula;
  String contato;
  bool adm;
  bool enable;
  String email;
  String id;

  UserModel({this.name = "", this.matricula = "", this.adm = false, this.contato = "", this.enable = false, this.email = "", this.id = ""});

  factory UserModel.from(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      name: json["name"],
      matricula: json["matricula"],
      contato: json["contato"],
      adm: json["adm"],
      email: json["email"],
      enable: json["enable"]);

  factory UserModel.fromResume(Map<String, dynamic> json) => UserModel(name: json["name"], matricula: json["matricula"]);

  Map<String, dynamic> toJsonResume() => {"name": name, "matricula": matricula};

  Map<String, dynamic> toJson() => {"id": id, "name": name, "matricula": matricula, "contato": contato, "adm": adm, "email": email, "enable": enable};
}
