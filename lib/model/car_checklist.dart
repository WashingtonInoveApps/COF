// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/car_model.dart';

class CarCheckList {
  CarModel car;
  double oil;
  double hidra;
  double fr;
  double arref;
  double fuel;
  String obs;

  CarCheckList(
      {required this.car,
      this.oil = 0.0,
      this.hidra = 0.0,
      this.fr = 0.0,
      this.arref = 0.0,
      this.fuel = 0.0,
      this.obs = ""});

  Map<String, dynamic> toMap() {
    return {
      'car': car.toMapResume(),
      'oil': oil,
      'hidra': hidra,
      'fr': fr,
      'fuel': fuel,
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
      fuel: map['fuel']?.toDouble() ?? 0.0,
      obs: map['obs'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarCheckList.fromJson(String source) =>
      CarCheckList.fromMap(json.decode(source));

  CarCheckList copyWith({
    CarModel? car,
    double? oil,
    double? hidra,
    double? fr,
    double? arref,
    double? fuel,
    String? obs,
  }) {
    return CarCheckList(
      car: car ?? this.car,
      oil: oil ?? this.oil,
      hidra: hidra ?? this.hidra,
      fr: fr ?? this.fr,
      arref: arref ?? this.arref,
      fuel: fuel ?? this.fuel,
      obs: obs ?? this.obs,
    );
  }
}
