import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';

class CarModel {
  String id;
  String resgaste;
  String modelo;
  String placa;
  int km;
  String modeloPneu;
  String ticket;
  String prime;

  List<ItensChangesModel> itens;
  List<CarChangeModel> changes;
  List<CarStatusModel> status;
  List<CarMapaModel> mapas;

  String typeCar;
  bool adm;
  bool enable;

  String obs;
  int proxOleo;
  int proxArref;

  CarModel(
      {this.resgaste = "",
      this.modelo = "",
      this.placa = "",
      this.km = 0,
      this.modeloPneu = "",
      this.ticket = "",
      this.prime = "",
      required this.itens,
      required this.changes,
      required this.status,
      required this.mapas,
      this.typeCar = "",
      this.adm = false,
      this.enable = true,
      this.obs = "",
      this.id = "",
      this.proxOleo = 0,
      this.proxArref = 0});

  factory CarModel.from(Map<String, dynamic> json) => CarModel(
      resgaste: json["resgaste"],
      modelo: json["modelo"],
      placa: json["placa"],
      km: int.parse(json["km"].toString()),
      modeloPneu: json["modeloPneu"],
      ticket: json["ticket"],
      prime: json["prime"],
      itens: List<ItensChangesModel>.from(json["itens"].map((e) => ItensChangesModel.from(e))),
      changes: List<CarChangeModel>.from(json["changes"].map((e) => CarChangeModel.from(e))),
      status: List<CarStatusModel>.from(json["status"].map((e) => CarStatusModel.from(e))),
      mapas: List<CarMapaModel>.from(json["mapas"].map((e) => CarMapaModel.from(e))),
      typeCar: json["typeCar"],
      adm: json["adm"],
      enable: json["enable"],
      obs: json["obs"],
      id: json["id"],
      proxOleo: json["proxOleo"],
      proxArref: json["proxArref"]);

  factory CarModel.fromResume(Map<String, dynamic> json) => CarModel(
      resgaste: json["resgaste"],
      itens: List<ItensChangesModel>.from(json["itens"].map((e) => ItensChangesModel.from(e))),
      changes: List<CarChangeModel>.from(json["changes"].map((e) => CarChangeModel.from(e))),
      id: json["id"],
      mapas: [],
      status: []);

  factory CarModel.copy(CarModel car) => CarModel.from(car.toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "resgaste": resgaste,
        "modelo": modelo,
        "placa": placa,
        "km": km,
        "modeloPneu": modeloPneu,
        "ticket": ticket,
        "prime": prime,
        "typeCar": typeCar,
        "adm": adm,
        "enable": enable,
        "obs": obs,
        "proxOleo": proxOleo,
        "proxArref": proxArref,
        "itens": List<dynamic>.from(itens.map((e) => e.toJson()).toList()),
        "changes": List<dynamic>.from(changes.map((e) => e.toJson()).toList()),
        "status": List<dynamic>.from(status.map((e) => e.toJson()).toList()),
        "mapas": List<dynamic>.from(mapas.map((e) => e.toJson()).toList())
      };

  Map<String, dynamic> toJsonResume() => {
        "id": id,
        "resgaste": resgaste,
        "itens": List<dynamic>.from(itens.map((e) => e.toJson()).toList()),
        "changes": List<dynamic>.from(changes.map((e) => e.toJson()).toList())
      };
}
