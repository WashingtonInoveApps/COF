// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/model/checklist_car_model.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/checklist_material_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/team_model.dart';
import 'package:bsu_control/model/user_model.dart';

class ChecklistModel {
  String? id;
  String pb;
  String prefix;
  int startKM;
  int endKM;
  String userID;
  String obs;
  OBMModel obm;
  String obmID;
  UserModel user;
  DateTime date;
  DateTime? dateFinish;
  TeamModel? team;
  CiaModel? cia;
  FileModel? signature;
  bool enable;
  ChecklistCarModel? vehicular;
  ChecklistMaterialModel? material;
  List<SupplyModel>? supply;
  List<StatesChecklist> states;

  ChecklistType type;
  StateProgress state;

  ChecklistModel({
    required this.user,
    required this.date,
    required this.states,
    required this.obm,
    this.id,
    this.cia,
    this.supply,
    this.vehicular,
    this.material,
    this.signature,
    this.userID = '',
    this.pb = "",
    this.obmID = '',
    this.dateFinish,
    this.type = ChecklistType.vehicular,
    this.state = StateProgress.inprogress,
    this.team,
    this.prefix = "",
    this.startKM = 0,
    this.endKM = 0,
    this.enable = true,
    this.obs = "",
  });

  Map<String, dynamic> toMap() {
    final reference = Core.getOperationalDay(date);

    return {
      'user': user.toMapResume(),
      'pb': pb,
      'signature': signature?.toMap(),
      'team': team?.toMap(),
      'cia': cia?.toMap(),
      'obmID': obmID,
      'prefix': prefix,
      'startKM': startKM,
      'endKM': endKM,
      'obm': obm.toMapResume(),
      'id': id,
      'type': type.name,
      'userID': userID,
      'state': state.name,
      'obs': obs,
      'enable': enable,
      'states': states.map((e) => e.toMap()).toList(),
      'date': date.millisecondsSinceEpoch,
      'dateFinish': dateFinish?.millisecondsSinceEpoch,
      'vehicular': vehicular?.toMap(),
      'supply': supply?.map((x) => x.toMap()).toList(),
      'referenceDate': Core.formatDate(reference),
      'referenceYear': reference.year.toString(),
      'referenceMonth':
          "${reference.month.toString().padLeft(2, '0')}/${reference.year}"
    };
  }

  factory ChecklistModel.fromMap(Map<String, dynamic> map) {
    return ChecklistModel(
      pb: map['pb'] ?? '',
      team: map['team'] != null ? TeamModel.fromMap(map['team']) : null,
      userID: map['userID'] ?? '',
      cia: map['cia'] != null ? CiaModel.fromMap(map['cia']) : null,
      obm: OBMModel.fromMapResume(map['obm']),
      signature: (map['signature'] == null)
          ? null
          : FileModel.fromMap(map['signature']),
      obmID: map['obmID'] ?? '',
      prefix: map['prefix'] ?? '',
      startKM: map['startKM']?.toInt() ?? 0,
      endKM: map['endKM']?.toInt() ?? 0,
      id: map['id'],
      obs: map['obs'] ?? '',
      type: ChecklistEnumCore.checklistTypeFromString(map['type']),
      state: StateProgressEnumCore.stateProgressFromString(map['state']),
      enable: map['enable'] ?? false,
      user: UserModel.fromMapResume(map['user'] as Map<String, dynamic>),
      states: (map['states'] != null)
          ? List<StatesChecklist>.from(
              map['states']?.map((x) => StatesChecklist.fromMap(x)))
          : [],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      dateFinish: map['dateFinish'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateFinish'])
          : null,
      vehicular: map['vehicular'] != null
          ? ChecklistCarModel.fromMap(map['vehicular'])
          : null,
      supply: List<SupplyModel>.from(
          map['supply']?.map((x) => SupplyModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChecklistModel.fromJson(String source) =>
      ChecklistModel.fromMap(json.decode(source));

  factory ChecklistModel.copy({required ChecklistModel checklist}) =>
      ChecklistModel.fromJson(checklist.toJson());

  ChecklistModel copyWith({
    UserModel? user,
    String? pb,
    TeamModel? team,
    String? prefix,
    int? startKM,
    int? endKM,
    String? userID,
    String? id,
    String? obs,
    OBMModel? obm,
    FileModel? signature,
    CiaModel? cia,
    String? obmID,
    bool? enable,
    DateTime? date,
    DateTime? dateFinish,
    ChecklistCarModel? vehicular,
    List<SupplyModel>? supply,
    ChecklistType? type,
    StateProgress? state,
    List<StatesChecklist>? states,
  }) {
    return ChecklistModel(
      user: user ?? this.user,
      pb: pb ?? this.pb,
      team: team ?? this.team,
      prefix: prefix ?? this.prefix,
      startKM: startKM ?? this.startKM,
      endKM: endKM ?? this.endKM,
      userID: userID ?? this.userID,
      id: id ?? this.id,
      obm: obm ?? this.obm,
      state: state ?? this.state,
      signature: signature ?? this.signature,
      states: states ?? this.states,
      type: type ?? this.type,
      obs: obs ?? this.obs,
      cia: cia ?? this.cia,
      obmID: obmID ?? this.obmID,
      enable: enable ?? this.enable,
      date: date ?? this.date,
      dateFinish: dateFinish ?? this.dateFinish,
      vehicular: vehicular ?? this.vehicular,
      supply: supply ?? this.supply,
    );
  }
}

class StatesChecklist {
  final StateProgress state;
  final DateTime date;

  StatesChecklist({required this.state, required this.date});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'state': state.name,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory StatesChecklist.fromMap(Map<String, dynamic> map) {
    return StatesChecklist(
      state:
          StateProgressEnumCore.stateProgressFromString(map['state'] as String),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatesChecklist.fromJson(String source) =>
      StatesChecklist.fromMap(json.decode(source) as Map<String, dynamic>);

  StatesChecklist copyWith({
    StateProgress? state,
    DateTime? date,
  }) {
    return StatesChecklist(
      state: state ?? this.state,
      date: date ?? this.date,
    );
  }
}
