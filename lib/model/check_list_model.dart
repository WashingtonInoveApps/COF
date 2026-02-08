// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';

class CheckListModel {
  UserModel user;
  String pb;
  String team;
  String prefix;
  String startKM;
  String endKM;
  String userID;
  String? id;
  String obs;
  String cia;
  String contact;
  String obmID;
  FileModel? signature;
  bool enable;
  DateTime date;
  DateTime? dateFinish;
  CarCheckList checkCar;
  List<SupplyModel> supply;
  List<CarChangeModel> changes;
  List<StatesChecklist> states;
  StateChecklist state;

  CheckListModel(
      {required this.user,
      required this.date,
      required this.checkCar,
      required this.supply,
      required this.changes,
      required this.states,
      this.signature,
      this.userID = '',
      this.pb = "",
      this.cia = '',
      this.contact = '',
      this.obmID = '',
      this.dateFinish,
      this.state = StateChecklist.inprogress,
      this.team = "",
      this.prefix = "",
      this.startKM = "",
      this.endKM = "",
      this.id,
      this.enable = true,
      this.obs = ""});

  Map<String, dynamic> toMap() {
    final reference = Core.getOperationalDay(date);
    return {
      'user': user.toMapResume(),
      'pb': pb,
      'signature': signature?.toMap(),
      'team': team,
      'cia': cia,
      'obmID': obmID,
      'contact': contact,
      'prefix': prefix,
      'startKM': startKM,
      'endKM': endKM,
      'id': id,
      'userID': userID,
      'state': state.name,
      'obs': obs,
      'enable': enable,
      'states': states.map((e) => e.toMap()).toList(),
      'date': date.millisecondsSinceEpoch,
      'dateFinish': dateFinish?.millisecondsSinceEpoch,
      'checkCar': checkCar.toMap(),
      'supply': supply.map((x) => x.toMap()).toList(),
      'changes': changes.map((x) => x.toMap()).toList(),
      'referenceDate': Core.formatDate(reference),
      //"${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
      'referenceMonth':
          "${reference.month.toString().padLeft(2, '0')}/${reference.year}"
    };
  }

  factory CheckListModel.fromMap(Map<String, dynamic> map) {
    return CheckListModel(
      user: UserModel.fromMapResume(map['user']),
      pb: map['pb'] ?? '',
      team: map['team'] ?? '',
      userID: map['userID'] ?? '',
      cia: map['cia'] ?? '',
      signature: (map['signature'] == null)
          ? null
          : FileModel.fromMap(map['signature']),
      obmID: map['obmID'] ?? '',
      contact: map['contact'] ?? '',
      prefix: map['prefix'] ?? '',
      startKM: map['startKM'] ?? '',
      endKM: map['endKM'] ?? '',
      id: map['id'],
      obs: map['obs'] ?? '',
      state: EnumCore.statusChecklistFromString(map['state'] as String),
      enable: map['enable'] ?? false,
      states: (map['states'] != null)
          ? List<StatesChecklist>.from(
              map['states']?.map((x) => StatesChecklist.fromMap(x)))
          : [],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      dateFinish: map['dateFinish'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateFinish'])
          : null,
      checkCar: CarCheckList.fromMap(map['checkCar']),
      supply: List<SupplyModel>.from(
          map['supply']?.map((x) => SupplyModel.fromMap(x))),
      changes: List<CarChangeModel>.from(
          map['changes']?.map((x) => CarChangeModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckListModel.fromJson(String source) =>
      CheckListModel.fromMap(json.decode(source));

  factory CheckListModel.copy({required CheckListModel checklist}) =>
      CheckListModel.fromJson(checklist.toJson());

  CheckListModel copyWith(
      {UserModel? user,
      String? pb,
      String? team,
      String? prefix,
      String? startKM,
      String? endKM,
      String? userID,
      String? id,
      String? obs,
      FileModel? signature,
      String? cia,
      String? contact,
      String? obmID,
      bool? enable,
      DateTime? date,
      DateTime? dateFinish,
      CarCheckList? checkCar,
      List<SupplyModel>? supply,
      StateChecklist? state,
      List<StatesChecklist>? states,
      List<CarChangeModel>? changes}) {
    return CheckListModel(
      user: user ?? this.user,
      pb: pb ?? this.pb,
      team: team ?? this.team,
      prefix: prefix ?? this.prefix,
      startKM: startKM ?? this.startKM,
      changes: changes ?? this.changes,
      endKM: endKM ?? this.endKM,
      userID: userID ?? this.userID,
      id: id ?? this.id,
      state: state ?? this.state,
      signature: signature ?? this.signature,
      states: states ?? this.states,
      obs: obs ?? this.obs,
      cia: cia ?? this.cia,
      contact: contact ?? this.contact,
      obmID: obmID ?? this.obmID,
      enable: enable ?? this.enable,
      date: date ?? this.date,
      dateFinish: dateFinish ?? this.dateFinish,
      checkCar: checkCar ?? this.checkCar,
      supply: supply ?? this.supply,
    );
  }
}

class StatesChecklist {
  final StateChecklist state;
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
      state: EnumCore.statusChecklistFromString(map['state'] as String),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatesChecklist.fromJson(String source) =>
      StatesChecklist.fromMap(json.decode(source) as Map<String, dynamic>);

  StatesChecklist copyWith({
    StateChecklist? state,
    DateTime? date,
  }) {
    return StatesChecklist(
      state: state ?? this.state,
      date: date ?? this.date,
    );
  }
}
