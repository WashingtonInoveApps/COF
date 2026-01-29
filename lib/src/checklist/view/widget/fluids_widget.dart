// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:bsu_control/core/constants.dart';

class FluidsWidget extends StatelessWidget {
  final double oil;
  final double hidra;
  final double fr;
  final double arref;
  final Function(dynamic) onOil;
  final Function(dynamic) onHidra;
  final Function(dynamic) onFr;
  final Function(dynamic) onArref;

  const FluidsWidget({
    Key? key,
    required this.oil,
    required this.hidra,
    required this.fr,
    required this.arref,
    required this.onOil,
    required this.onHidra,
    required this.onFr,
    required this.onArref,
  }) : super(key: key);

  Widget nivelContainer(
          {required String title,
          required double value,
          required Color color,
          required Function(dynamic) onChange}) =>
      Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                title.toUpperCase(),
                style: Constants.subtitle,
              ),
            ),
            SfSlider.vertical(
              min: 1.0,
              max: 3.0,
              stepSize: 0.5,
              value: value,
              interval: 1,
              activeColor: color,
              inactiveColor: color.withOpacity(0.4),
              showTicks: true,
              minorTicksPerInterval: 1,
              onChanged: onChange,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            nivelContainer(
                title: 'Oléo do motor',
                color: Colors.brown,
                value: oil,
                onChange: onOil),
            nivelContainer(
                title: 'Oléo hidraúlico',
                color: Colors.red,
                value: hidra,
                onChange: onHidra),
            nivelContainer(
                title: 'Oléo de freio',
                color: Colors.grey,
                value: fr,
                onChange: onFr),
            nivelContainer(
                title: 'Água radiador',
                color: Colors.blue,
                value: arref,
                onChange: onArref),
          ],
        ),
      ),
    );
  }
}
