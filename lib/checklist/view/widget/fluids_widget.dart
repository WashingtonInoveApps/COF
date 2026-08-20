// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
          required IconData icon,
          required Function(double) onChange}) =>
      Container(
        height: 200,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title.toUpperCase(),
                        style: Constants.subtitle.copyWith(color: Colors.grey),
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: -3,
                      child: Icon(
                        icon,
                        color: Colors.grey,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: SfSlider.vertical(
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
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      // width: double.infinity,
      // decoration: BoxDecoration(
      //     color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Scrollbar(
            thumbVisibility: true,
            trackVisibility: true,
            controller: scrollController,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: IntrinsicHeight(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      nivelContainer(
                          title: 'Óleo do motor',
                          color: Colors.brown,
                          icon: Icons.oil_barrel,
                          value: widget.oil,
                          onChange: (value) => widget.onOil?.call(value)),
                      nivelContainer(
                          title: 'Óleo hidraúlico',
                          color: Colors.red.shade700,
                          icon: MdiIcons.steering,
                          value: widget.hidra,
                          onChange: (value) => widget.onHidra?.call(value)),
                      nivelContainer(
                          title: 'Óleo de freio',
                          color: Colors.green.shade700,
                          icon: MdiIcons.carBrakeFluidLevel,
                          value: widget.fr,
                          onChange: (value) => widget.onFr?.call(value)),
                      nivelContainer(
                          title: 'Água do radiador',
                          color: Colors.blue.shade700,
                          icon: MdiIcons.carCoolantLevel,
                          value: widget.arref,
                          onChange: (value) => widget.onArref?.call(value)),
                    ]
                    //   .expand((widget) => [widget, const VerticalDivider()])
                    //   .toList()
                    // ..removeLast(),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
