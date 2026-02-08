import 'package:bsu_control/model/car_model.dart';
import 'package:flutter/material.dart';

class DetailsCarsModel {
  final String label;
  final int operating;
  final int reserve;
  final int lowered;
  final Color color;
  final List<CarModel> cars;

  DetailsCarsModel(
      {required this.label,
      required this.color,
      required this.operating,
      required this.reserve,
      required this.lowered,
      required this.cars});
}
