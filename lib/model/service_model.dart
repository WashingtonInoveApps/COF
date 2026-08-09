// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs,
import 'dart:convert';

import 'package:bsu_control/enum/services_enum.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';

class ServiceModel {
  String? id;
  UserModel responsable;
  List<ServicesComponent> components;
  List<String> componentsIDs;
  String pb;
  String? team;
  String obs;
  String? cia;
  OBMModel obm;
  String contact;
  String obmID;
  DateTime date;
  DateTime? dateFinish;
  StateProgress state;
  int changesCar;
  int changesMaterials;

  ServiceModel({
    this.id,
    required this.responsable,
    required this.date,
    required this.components,
    required this.obm,
    required this.componentsIDs,
    this.state = StateProgress.inprogress,
    this.pb = "",
    this.cia,
    this.contact = '',
    this.obmID = '',
    this.dateFinish,
    this.changesCar = 0,
    this.changesMaterials = 0,
    this.team,
    this.obs = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'responsable': responsable.toMapResume(),
      'components': components.map((x) => x.toMap()).toList(),
      'componentsIDs': componentsIDs,
      'state': state.name,
      'pb': pb,
      'team': team,
      'obs': obs,
      'cia': cia,
      'changesCar': changesCar,
      'changesMaterials': changesMaterials,
      'obm': obm.toMapResume(),
      'contact': contact,
      'obmID': obmID,
      'date': date.millisecondsSinceEpoch,
      'dateFinish': dateFinish?.millisecondsSinceEpoch,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      responsable:
          UserModel.fromMapResume(map['responsable'] as Map<String, dynamic>),
      components: List<ServicesComponent>.from(
        (map['components'] as List).map<ServicesComponent>(
          (x) => ServicesComponent.fromMap(x as Map<String, dynamic>),
        ),
      ),
      componentsIDs: List<String>.from(map['componentsIDs']),
      pb: map['pb'] as String,
      team: map['team'],
      cia: map['cia'],
      changesCar: map['changesCar'] ?? 0,
      changesMaterials: map['changesMaterials'] ?? 0,
      obs: map['obs'] as String,
      obm: OBMModel.fromMapResume(map['obm']),
      state: StateProgressEnumCore.stateProgressFromString(map['state']),
      contact: map['contact'] as String,
      obmID: map['obmID'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      dateFinish: map['dateFinish'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateFinish'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceModel.fromJson(String source) =>
      ServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ServicesComponent {
  final UserModel user;
  final DateTime startDate;
  final DateTime endDate;
  final List<ServiceFunctions> functions;
  final ServicePeriod period;

  ServicesComponent(
      {required this.user,
      required this.startDate,
      required this.endDate,
      required this.functions,
      this.period = ServicePeriod.turnaAB});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMapResume(),
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'functions': functions.map((e) => e.name).toList(),
      'period': period.name,
    };
  }

  factory ServicesComponent.fromMap(Map<String, dynamic> map) {
    return ServicesComponent(
      functions: List<ServiceFunctions>.from((map['functions'] as List).map(
          (e) => ServiceEnumCore.stateServiceFunctionsFromString(e as String))),
      period:
          ServiceEnumCore.stateServicePeriodFromString(map['period'] as String),
      user: UserModel.fromMapResume(map['user'] as Map<String, dynamic>),
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ServicesComponent.fromJson(String source) =>
      ServicesComponent.fromMap(json.decode(source) as Map<String, dynamic>);

  ServicesComponent copyWith({
    UserModel? user,
    DateTime? startDate,
    DateTime? endDate,
    List<ServiceFunctions>? functions,
    ServicePeriod? period,
  }) {
    return ServicesComponent(
      user: user ?? this.user,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      functions: functions ?? this.functions,
      period: period ?? this.period,
    );
  }
}
