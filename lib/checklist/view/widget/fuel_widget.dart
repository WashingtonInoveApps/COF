// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:bsu_control/core/constants.dart';

class FuelWidget extends StatefulWidget {
  final double fuel;
  final Function(double)? onChange;

  const FuelWidget({
    Key? key,
    required this.fuel,
    this.onChange,
  }) : super(key: key);

  @override
  State<FuelWidget> createState() => _FuelWidgetState();
}

class _FuelWidgetState extends State<FuelWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COMBUSTÍVEL',
                  style: Constants.subtitle.copyWith(color: Colors.grey),
                ),
                SfSlider(
                  min: 0.0,
                  max: 4.0,
                  stepSize: 0.5,
                  value: widget.fuel,
                  interval: 1,
                  activeColor: Colors.deepOrange,
                  inactiveColor: Colors.deepOrange.withValues(alpha: 0.4),
                  showTicks: true,
                  minorTicksPerInterval: 1,
                  onChanged: (result) {
                    widget.onChange?.call(result as double);
                  },
                ),
              ],
            ),
            Positioned(
                left: 0,
                right: 0,
                child: Icon(
                  MdiIcons.gasStation,
                  color: Colors.grey,
                  size: 20,
                ))
          ],
        ),
      ),
    );
  }
}
