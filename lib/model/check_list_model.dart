import 'dart:convert';

import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';

class CheckListModel {
  UserModel user;
  String pb;
  String team;
  String prefix;
  String startKM;
  String endKM;
  String? id;
  String obs;
  bool enable;
  DateTime date;
  DateTime? dateFinish;
  CarCheckList checkCar;
  List<SupplyModel> supply;

  CheckListModel(
      {required this.user,
      required this.date,
      required this.checkCar,
      required this.supply,
      this.pb = "",
      this.dateFinish,
      this.team = "",
      this.prefix = "",
      this.startKM = "",
      this.endKM = "",
      this.id,
      this.enable = true,
      this.obs = ""});

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMapResume(),
      'pb': pb,
      'team': team,
      'prefix': prefix,
      'startKM': startKM,
      'endKM': endKM,
      'id': id,
      'obs': obs,
      'enable': enable,
      'date': date.millisecondsSinceEpoch,
      'dateFinish': dateFinish?.millisecondsSinceEpoch,
      'checkCar': checkCar.toMap(),
      'supply': supply.map((x) => x.toMap()).toList(),
      'referenceDate':
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
      'referenceMonth': "${date.month.toString().padLeft(2, '0')}/${date.year}"
    };
  }

  factory CheckListModel.fromMap(Map<String, dynamic> map) {
    return CheckListModel(
      user: UserModel.fromMapResume(map['user']),
      pb: map['pb'] ?? '',
      team: map['team'] ?? '',
      prefix: map['prefix'] ?? '',
      startKM: map['startKM'] ?? '',
      endKM: map['endKM'] ?? '',
      id: map['id'],
      obs: map['obs'] ?? '',
      enable: map['enable'] ?? false,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      dateFinish: map['dateFinish'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dateFinish'])
          : null,
      checkCar: CarCheckList.fromMap(map['checkCar']),
      supply: List<SupplyModel>.from(
          map['supply']?.map((x) => SupplyModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckListModel.fromJson(String source) =>
      CheckListModel.fromMap(json.decode(source));

  factory CheckListModel.copy({required CheckListModel checklist}) =>
      CheckListModel.fromJson(checklist.toJson());

  @override
  String toString() {
    return 'CheckListModel(user: $user, pb: $pb, team: $team, prefix: $prefix, startKM: $startKM, endKM: $endKM, id: $id, obs: $obs, enable: $enable, date: $date, dateFinish: $dateFinish, checkCar: $checkCar, supply: $supply)';
  }
}
