// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:bsu_control/core/constants.dart';

class FluidsWidget extends StatefulWidget {
  final double oil;
  final double hidra;
  final double fr;
  final double arref;
  final Function(double)? onOil;
  final Function(double)? onHidra;
  final Function(double)? onFr;
  final Function(double)? onArref;

  const FluidsWidget({
    Key? key,
    required this.oil,
    required this.hidra,
    required this.fr,
    required this.arref,
    this.onOil,
    this.onHidra,
    this.onFr,
    this.onArref,
  }) : super(key: key);

  @override
  State<FluidsWidget> createState() => _FluidsWidgetState();
}

class _FluidsWidgetState extends State<FluidsWidget> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget nivelContainer(
          {required String title,
          required double value,
          required Color color,
          required Function(double) onChange}) =>
      Card(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  title.toUpperCase(),
                  style: Constants.subtitle.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
              SfSlider.vertical(
                min: 0.0,
                max: 3.0,
                stepSize: 0.5,
                value: value,
                interval: 1,
                activeColor: color,
                inactiveColor: color.withValues(alpha: 0.4),
                showTicks: true,
                minorTicksPerInterval: 1,
                onChanged: (result) {
                  onChange(result as double);
                },
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                nivelContainer(
                    title: 'Óleo do motor',
                    color: Colors.brown,
                    value: widget.oil,
                    onChange: (value) => widget.onOil?.call(value)),
                nivelContainer(
                    title: 'Óleo hidraúlico',
                    color: Colors.red.shade700,
                    value: widget.hidra,
                    onChange: (value) => widget.onHidra?.call(value)),
                nivelContainer(
                    title: 'Óleo de freio',
                    color: Colors.green.shade700,
                    value: widget.fr,
                    onChange: (value) => widget.onFr?.call(value)),
                nivelContainer(
                    title: 'Água do radiador',
                    color: Colors.blue.shade700,
                    value: widget.arref,
                    onChange: (value) => widget.onArref?.call(value)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
