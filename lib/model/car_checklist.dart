// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/outher_changes_model.dart';

class CarChecklistModel {
  CarModel car;
  List<CarChangeModel>? changes;
  List<OtherChangeModel>? others;
  double oil;
  double hidra;
  double fr;
  double arref;
  double fuel;
  String obs;

  CarChecklistModel({
    required this.car,
    this.others,
    this.changes,
    this.oil = 0.0,
    this.hidra = 0.0,
    this.fr = 0.0,
    this.arref = 0.0,
    this.fuel = 0.0,
    this.obs = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'car': car.toMapResume(),
      'changes': changes?.map((e) => e.toMap()).toList(),
      'others': others?.map((e) => e.toMap()).toList(),
      'oil': oil,
      'hidra': hidra,
      'fr': fr,
      'fuel': fuel,
      'arref': arref,
      'obs': obs,
    };
  }

  factory CarChecklistModel.fromMap(Map<String, dynamic> map) {
    return CarChecklistModel(
      car: CarModel.fromMapResume(map['car']),
      changes: map['changes'] != null
          ? List<CarChangeModel>.from(
              map['changes']?.map((x) => CarChangeModel.fromMap(x)))
          : null,
      others: (map['others'] != null)
          ? List<OtherChangeModel>.from(
              map['others']?.map((x) => OtherChangeModel.fromMap(x)))
          : [],
      oil: map['oil']?.toDouble() ?? 0.0,
      hidra: map['hidra']?.toDouble() ?? 0.0,
      fr: map['fr']?.toDouble() ?? 0.0,
      arref: map['arref']?.toDouble() ?? 0.0,
      fuel: map['fuel']?.toDouble() ?? 0.0,
      obs: map['obs'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarChecklistModel.fromJson(String source) =>
      CarChecklistModel.fromMap(json.decode(source));

  CarChecklistModel copyWith({
    CarModel? car,
    List<CarChangeModel>? changes,
    List<OtherChangeModel>? others,
    double? oil,
    double? hidra,
    double? fr,
    double? arref,
    double? fuel,
    String? obs,
  }) {
    return CarChecklistModel(
      car: car ?? this.car,
      changes: changes ?? this.changes,
      others: others ?? this.others,
      oil: oil ?? this.oil,
      hidra: hidra ?? this.hidra,
      fr: fr ?? this.fr,
      arref: arref ?? this.arref,
      fuel: fuel ?? this.fuel,
      obs: obs ?? this.obs,
    );
  }
}
