import 'dart:convert';
import 'package:bsu_control/model/car_model.dart';

class CarCheckList {
  CarModel car;
  double oil;
  double hidra;
  double fr;
  double arref;
  String obs;

  CarCheckList({required this.car, this.oil = 1.0, this.hidra = 1.0, this.fr = 1.0, this.arref = 1.0, this.obs = ""});

  Map<String, dynamic> toMap() {
    return {
      'car': car.toMapResume(),
      'oil': oil,
      'hidra': hidra,
      'fr': fr,
      'arref': arref,
      'obs': obs,
    };
  }

  factory CarCheckList.fromMap(Map<String, dynamic> map) {
    return CarCheckList(
      car: CarModel.fromMapResume(map['car']),
      oil: map['oil']?.toDouble() ?? 0.0,
      hidra: map['hidra']?.toDouble() ?? 0.0,
      fr: map['fr']?.toDouble() ?? 0.0,
      arref: map['arref']?.toDouble() ?? 0.0,
      obs: map['obs'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarCheckList.fromJson(String source) => CarCheckList.fromMap(json.decode(source));
}