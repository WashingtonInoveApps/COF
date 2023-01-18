// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';

class CarModel {
  String? id;
  String prefix;
  String model;
  String plate;
  int km;
  String modelPneu;
  String ticket;
  String prime;

  List<ItensChangesModel> itens;
  List<CarChangeModel> changes;
  List<CarStatusModel> status;
  List<CarMapaModel>? mapas;

  String typeCar;
  bool adm;
  bool enable;

  String obs;
  int oil;
  int arref;

  CarModel(
      {this.prefix = "",
      this.model = "",
      this.plate = "",
      this.km = 0,
      this.modelPneu = "",
      this.ticket = "",
      this.prime = "",
      required this.itens,
      required this.changes,
      required this.status,
      this.mapas,
      this.typeCar = "",
      this.adm = false,
      this.enable = true,
      this.obs = "",
      this.id,
      this.oil = 0,
      this.arref = 0});

  Map<String, dynamic> toMapResume() => {
        "id": id,
        "prefix": prefix,
        "itens": List<dynamic>.from(itens.map((e) => e.toMap()).toList()),
        "changes": List<dynamic>.from(changes.map((e) => e.toMap()).toList()),
      };

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prefix': prefix,
      'model': model,
      'plate': plate,
      'km': km,
      'modelPneu': modelPneu,
      'ticket': ticket,
      'prime': prime,
      'itens': itens.map((x) => x.toMap()).toList(),
      'changes': changes.map((x) => x.toMap()).toList(),
      'mapas': mapas?.map((x) => x.toMap()).toList(),
      'typeCar': typeCar,
      'adm': adm,
      'enable': enable,
      'obs': obs,
      'oil': oil,
      'arref': arref,
    };
  }

  factory CarModel.fromMapResume(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      prefix: map['prefix'] ?? '',
      itens: List<ItensChangesModel>.from(
          map['itens']?.map((x) => ItensChangesModel.fromMap(x))),
      changes: List<CarChangeModel>.from(
          map['changes']?.map((x) => CarChangeModel.fromMap(x))),
      status: [],
    );
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      prefix: map['prefix'] ?? '',
      model: map['model'] ?? '',
      plate: map['plate'] ?? '',
      km: map['km']?.toInt() ?? 0,
      modelPneu: map['modelPneu'] ?? '',
      ticket: map['ticket'] ?? '',
      prime: map['prime'] ?? '',
      itens: List<ItensChangesModel>.from(
          map['itens']?.map((x) => ItensChangesModel.fromMap(x))),
      changes: List<CarChangeModel>.from(
          map['changes']?.map((x) => CarChangeModel.fromMap(x))),
      mapas: List<CarMapaModel>.from(
          map['mapas']?.map((x) => CarMapaModel.fromMap(x))),
      status: [],
      typeCar: map['typeCar'] ?? '',
      adm: map['adm'] ?? false,
      enable: map['enable'] ?? false,
      obs: map['obs'] ?? '',
      oil: map['oil']?.toInt() ?? 0,
      arref: map['arref']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CarModel.fromJson(String source) =>
      CarModel.fromMap(json.decode(source));

  factory CarModel.copy(CarModel car) => CarModel.fromJson(car.toJson());

  CarModel copyWith({
    String? id,
    String? prefix,
    String? model,
    String? plate,
    int? km,
    String? modelPneu,
    String? ticket,
    String? prime,
    List<ItensChangesModel>? itens,
    List<CarChangeModel>? changes,
    List<CarStatusModel>? status,
    List<CarMapaModel>? mapas,
    String? typeCar,
    bool? adm,
    bool? enable,
    String? obs,
    int? oil,
    int? arref,
  }) {
    return CarModel(
      id: id ?? this.id,
      prefix: prefix ?? this.prefix,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      km: km ?? this.km,
      modelPneu: modelPneu ?? this.modelPneu,
      ticket: ticket ?? this.ticket,
      prime: prime ?? this.prime,
      itens: itens ?? this.itens,
      changes: changes ?? this.changes,
      status: status ?? this.status,
      mapas: mapas ?? this.mapas,
      typeCar: typeCar ?? this.typeCar,
      adm: adm ?? this.adm,
      enable: enable ?? this.enable,
      obs: obs ?? this.obs,
      oil: oil ?? this.oil,
      arref: arref ?? this.arref,
    );
  }
}
