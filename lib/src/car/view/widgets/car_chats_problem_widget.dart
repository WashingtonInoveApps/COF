// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_status_model.dart';

class CarChartProblems extends StatelessWidget {
  final List<CarStatusModel> status;
  const CarChartProblems({Key? key, required this.status}) : super(key: key);

  List<PieData> buildPieData(List<CarStatusModel> status) {
    List<PieData> data = [];

    for (final state in status) {
      final index = data.indexWhere((e) => e.label == state.type.label);

      if (index == -1) {
        data.add(PieData(
            label: state.type.label, count: 1, color: state.type.color));
      } else {
        final result = data[index];
        result.count = (result.count + 1);
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final data = buildPieData(status);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HISTÓRICO DE DEFEITOS',
          style: Constants.subtitleHint,
        ),
        Expanded(
          child: SfCircularChart(
            legend: const Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                orientation: LegendItemOrientation.horizontal),
            series: <CircularSeries>[
              PieSeries<PieData, String>(
                dataSource: data,
                xValueMapper: (PieData data, _) => data.label,
                yValueMapper: (PieData data, _) => data.count,
                pointColorMapper: (data, _) => data.color,
                dataLabelMapper: (data, _) =>
                    '${((data.count / status.length) * 100).toString()}%',
                legendIconType: LegendIconType.circle,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle:
                        Constants.subtitle.copyWith(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PieData {
  String label;
  int count;
  Color color;

  PieData({required this.label, required this.count, required this.color});

  PieData copyWith({
    String? label,
    int? count,
    Color? color,
  }) {
    return PieData(
      label: label ?? this.label,
      count: count ?? this.count,
      color: color ?? this.color,
    );
  }
}
