import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckListModel {
  UserModel user;
  String pb;
  String alfa;
  String resgate;
  String kmInicial;
  String kmFinal;
  String id;
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
      this.alfa = "",
      this.resgate = "",
      this.kmInicial = "",
      this.kmFinal = "",
      this.id = "",
      this.enable = true,
      this.obs = ""});

  factory CheckListModel.from(Map<String, dynamic> json) => CheckListModel(
      id: json["id"],
      date: json["date"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate(),
      dateFinish: json["dateFinish"] == null ? null : (json["dateFinish"] is DateTime ? json["date"] : (json["date"] as Timestamp).toDate()),
      user: UserModel.fromResume(json["user"]),
      checkCar: CarCheckList.from(json["checkCar"]),
      supply: List<SupplyModel>.from(json["supply"].map((s) => SupplyModel.from(s))),
      pb: json["pb"],
      alfa: json["alfa"],
      resgate: json["resgate"],
      kmInicial: json["kmInicial"],
      kmFinal: json["kmFinal"],
      enable: json["enable"],
      obs: json["obs"]);

  factory CheckListModel.copy(CheckListModel checkList) => CheckListModel.from(checkList.toJson());

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "dateFinish": dateFinish,
        "pb": pb,
        "alfa": alfa,
        "resgate": resgate,
        "kmInicial": kmInicial,
        "kmFinal": kmFinal,
        "enable": enable,
        "obs": obs,
        "referenceDate": formatDate(date, referenceDate: true),
        "user": user.toJsonResume(),
        "checkCar": checkCar.toJson(),
        "supply": List<dynamic>.from(supply.map((e) => e.toJson()).toList()),
      };
}

class CarCheckList {
  CarModel car;
  double oleoMotor;
  double oleoHidra;
  double oleoFreio;
  double aguaRad;

  String obs;

  CarCheckList({required this.car, this.oleoMotor = 1.0, this.oleoHidra = 1.0, this.oleoFreio = 1.0, this.aguaRad = 1.0, this.obs = ""});

  factory CarCheckList.from(Map<String, dynamic> json) => CarCheckList(
      car: CarModel.fromResume(json["car"]),
      oleoFreio: json["oleoFreio"].toDouble(),
      oleoHidra: json["oleoHidra"].toDouble(),
      oleoMotor: json["oleoMotor"].toDouble(),
      aguaRad: json["aguaRad"].toDouble(),
      obs: json["obs"]);

  Map<String, dynamic> toJson() => {
        "car": car.toJsonResume(),
        "oleoMotor": oleoMotor,
        "oleoHidra": oleoHidra,
        "oleoFreio": oleoFreio,
        "aguaRad": aguaRad,
        "obs": obs,
      };
}
