// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';

import 'cia_model.dart';

class CarModel {
  String? id;
  String prefix;
  String model;
  String plate;
  String modelPneu;
  String ticket;
  String obmID;
  CiaModel? cia;
  OBMModel? obm;
  String? ciaID;
  String type;
  FunctionCar function;
  String obs;
  StatusCar state;

  List<SectionItensModel> itens;
  List<CarChangeModel> changes;
  List<CarStatusModel> status;
  List<CarMapaModel>? mapas;
  List<OtherChangeModel>? others;
  List<FileModel?> images;

  int km;
  int distance;
  int oil;
  int arref;
  bool adm;
  bool enable;

  CarModel({
    this.prefix = "",
    this.model = "",
    this.plate = "",
    this.km = 0,
    this.modelPneu = "",
    this.ticket = "",
    this.obmID = "",
    this.obm,
    this.function = FunctionCar.operational,
    this.cia,
    this.ciaID,
    this.state = StatusCar.waiting,
    required this.itens,
    required this.changes,
    required this.status,
    required this.images,
    this.others,
    this.mapas,
    this.type = "",
    this.adm = false,
    this.enable = true,
    this.obs = "",
    this.id,
    this.oil = 0,
    this.arref = 0,
    this.distance = 0,
  });

  Map<String, dynamic> toMapResume() => {
        "id": id,
        "prefix": prefix,
        "itens": itens.map((e) => e.toMap()).toList(),
        "changes": [],
        "images": [],
        "obmID": obmID,
        "cia": cia?.toMapResume(),
        "obm": obm?.toMapResume(),
        'ciaID': ciaID,
      };

  Map<String, dynamic> toMapServiceResume() => {
        "id": id,
        "prefix": prefix,
        "obmID": obmID,
        'ciaID': ciaID,
        'obm': obm?.toMapResume(),
        'cia': cia?.toMapResume(),
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
      'function': function.name,
      'obmID': obmID,
      "cia": cia?.toMapResume(),
      "obm": obm?.toMapResume(),
      'ciaID': ciaID,
      'state': state.name,
      'itens': itens.map((x) => x.toMap()).toList(),
      'changes': changes.map((x) => x.toMap()).toList(),
      'mapas': mapas?.map((x) => x.toMap()).toList(),
      'others': others?.map((x) => x.toMap()).toList(),
      "images": images.map((x) => x?.toMap()).toList(),
      'type': type,
      'adm': adm,
      'enable': enable,
      'obs': obs,
      'oil': oil,
      'arref': arref,
      'distance': distance,
    };
  }

  factory CarModel.fromMapResume(Map<String, dynamic> map) {
    return CarModel(
        id: map['id'] ?? '',
        prefix: map['prefix'] ?? '',
        itens: List<SectionItensModel>.from(
            map['itens']?.map((x) => SectionItensModel.fromMap(x))),
        changes: [],
        images: [],
        status: [],
        cia: (map['cia'] != null) ? CiaModel.fromMap(map['cia']) : null,
        obm: (map['obm'] != null) ? OBMModel.fromMapResume(map['obm']) : null,
        ciaID: map['ciaID'] ?? '',
        obmID: map['obmID']);
  }

  factory CarModel.fromMapServiceResume(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      prefix: map['prefix'] ?? '',
      ciaID: map['ciaID'] ?? '',
      obmID: map['obmID'],
      cia: (map['cia'] != null) ? CiaModel.fromMap(map['cia']) : null,
      obm: (map['obm'] != null) ? OBMModel.fromMapResume(map['obm']) : null,
      itens: [],
      changes: [],
      status: [],
      images: [],
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
      obmID: map['obmID'] ?? '',
      cia: (map['cia'] != null) ? CiaModel.fromMap(map['cia']) : null,
      obm: (map['obm'] != null) ? OBMModel.fromMapResume(map['obm']) : null,
      ciaID: map['ciaID'] ?? '',
      function: CarEnumCore.functionCarFromString(map['function'] as String),
      state: CarEnumCore.statusCarFromString(map['state'] as String),
      itens: List<SectionItensModel>.from(
          map['itens']?.map((x) => SectionItensModel.fromMap(x))),
      changes: List<CarChangeModel>.from(
          map['changes']?.map((x) => CarChangeModel.fromMap(x))),
      mapas: map['mapas'] != null
          ? List<CarMapaModel>.from(
              map['mapas']?.map((x) => CarMapaModel.fromMap(x)))
          : null,
      others: map['others'] != null
          ? List<OtherChangeModel>.from(
              map['others']?.map((x) => OtherChangeModel.fromMap(x)))
          : null,
      images: List<FileModel?>.from(
          map['images'].map((x) => (x == null) ? null : FileModel.fromMap(x))),
      status: [],
      type: map['type'] ?? '',
      adm: map['adm'] ?? false,
      enable: map['enable'] ?? false,
      obs: map['obs'] ?? '',
      oil: map['oil']?.toInt() ?? 0,
      distance: map['distance']?.toInt() ?? 0,
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
    String? obmID,
    CiaModel? cia,
    OBMModel? obm,
    String? ciaID,
    FunctionCar? function,
    List<SectionItensModel>? itens,
    List<CarChangeModel>? changes,
    List<CarStatusModel>? status,
    List<CarMapaModel>? mapas,
    List<FileModel?>? images,
    List<OtherChangeModel>? others,
    StatusCar? state,
    String? type,
    bool? adm,
    bool? enable,
    String? obs,
    int? oil,
    int? arref,
    int? distance,
  }) {
    return CarModel(
      id: id ?? this.id,
      prefix: prefix ?? this.prefix,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      km: km ?? this.km,
      modelPneu: modelPneu ?? this.modelPneu,
      ticket: ticket ?? this.ticket,
      obmID: obmID ?? this.obmID,
      cia: cia ?? this.cia,
      ciaID: ciaID ?? this.ciaID,
      obm: obm ?? this.obm,
      images: images ?? this.images,
      itens: itens ?? this.itens,
      changes: changes ?? this.changes,
      status: status ?? this.status,
      mapas: mapas ?? this.mapas,
      others: others ?? this.others,
      function: function ?? this.function,
      type: type ?? this.type,
      adm: adm ?? this.adm,
      state: state ?? this.state,
      enable: enable ?? this.enable,
      obs: obs ?? this.obs,
      oil: oil ?? this.oil,
      arref: arref ?? this.arref,
      distance: distance ?? this.distance,
    );
  }
}
