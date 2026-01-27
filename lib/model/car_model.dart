// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StatusCar { operando, reserva, baixado }

extension CarStateLabel on StatusCar {
  String get label {
    switch (this) {
      case StatusCar.operando:
        return "Operando";
      case StatusCar.reserva:
        return "Reserva";
      case StatusCar.baixado:
        return "Baixado";
    }
  }
}

extension CarStateColor on StatusCar {
  Color get color {
    switch (this) {
      case StatusCar.operando:
        return Colors.green.shade800;
      case StatusCar.reserva:
        return Colors.orange;
      case StatusCar.baixado:
        return Colors.red;
    }
  }
}

extension CarStateIcon on StatusCar {
  IconData get icon {
    switch (this) {
      case StatusCar.operando:
        return Icons.check_circle;
      case StatusCar.reserva:
        return Icons.info_rounded;
      case StatusCar.baixado:
        return MdiIcons.closeCircle;
    }
  }
}

class CarModel {
  String? id;
  String prefix;
  String model;
  String plate;
  String modelPneu;
  String ticket;
  String obm;
  String typeCar;
  String obs;
  StatusCar state;

  List<ItensChangesModel> itens;
  List<CarChangeModel> changes;
  List<CarStatusModel> status;
  List<CarMapaModel>? mapas;
  List<FileModel?> images;

  int km;
  int oil;
  int arref;
  bool adm;
  bool enable;

  CarModel(
      {this.prefix = "",
      this.model = "",
      this.plate = "",
      this.km = 0,
      this.modelPneu = "",
      this.ticket = "",
      this.obm = "",
      this.state = StatusCar.operando,
      required this.itens,
      required this.changes,
      required this.status,
      required this.images,
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
        "images": [],
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
      'obm': obm,
      'state': state.name,
      'itens': itens.map((x) => x.toMap()).toList(),
      'changes': changes.map((x) => x.toMap()).toList(),
      'mapas': mapas?.map((x) => x.toMap()).toList(),
      "images": images.map((x) => x?.toMap()).toList(),
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
      images: [],
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
      obm: map['obm'] ?? '',
      state: statusFromString(map['state'] as String),
      itens: List<ItensChangesModel>.from(
          map['itens']?.map((x) => ItensChangesModel.fromMap(x))),
      changes: List<CarChangeModel>.from(
          map['changes']?.map((x) => CarChangeModel.fromMap(x))),
      mapas: List<CarMapaModel>.from(
          map['mapas']?.map((x) => CarMapaModel.fromMap(x))),
      images: List<FileModel?>.from(
          map['images'].map((x) => (x == null) ? null : FileModel.fromMap(x))),
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
    String? obm,
    List<ItensChangesModel>? itens,
    List<CarChangeModel>? changes,
    List<CarStatusModel>? status,
    List<CarMapaModel>? mapas,
    List<FileModel>? images,
    StatusCar? state,
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
      obm: obm ?? this.obm,
      images: images ?? this.images,
      itens: itens ?? this.itens,
      changes: changes ?? this.changes,
      status: status ?? this.status,
      mapas: mapas ?? this.mapas,
      typeCar: typeCar ?? this.typeCar,
      adm: adm ?? this.adm,
      state: state ?? this.state,
      enable: enable ?? this.enable,
      obs: obs ?? this.obs,
      oil: oil ?? this.oil,
      arref: arref ?? this.arref,
    );
  }
}

StatusCar statusFromString(String value) {
  return StatusCar.values.firstWhere(
    (e) => e.name == value,
    orElse: () => StatusCar.operando,
  );
}
