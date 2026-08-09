// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarChartProblems extends StatelessWidget {
  final DateTime reference;
  final Function(DateTime)? onChangeDate;
  final List<CarStatusModel> status;
  const CarChartProblems(
      {Key? key,
      required this.status,
      required this.reference,
      this.onChangeDate})
      : super(key: key);

  List<PieData> buildPieData(List<CarStatusModel> status) {
    List<PieData> data = [];

    for (final state in status) {
      final index = data.indexWhere((e) => e.label == state.type!.label);

      if (index == -1) {
        data.add(PieData(
            label: state.type!.label, count: 1, color: state.type!.color));
      } else {
        final result = data[index];
        result.count = (result.count + 1);
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final list = status.where((e) => e.state == StatusCar.baixado).toList();
    final data = buildPieData(list);

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: (status.isEmpty)
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 20,
                            color: Colors.grey,
                          ),
                          Text(
                            'Aguardando dados...',
                            style: Constants.subtitleHint,
                          ),
                        ],
                      ),
                    )
                  : SfCircularChart(
                      series: <CircularSeries>[
                        PieSeries<PieData, String>(
                          dataSource: data,
                          xValueMapper: (PieData data, _) => data.label,
                          yValueMapper: (PieData data, _) => data.count,
                          pointColorMapper: (data, _) => data.color,
                          dataLabelMapper: (data, _) =>
                              '${((data.count / status.length) * 100).toString()}%',
                          // legendIconType: LegendIconType.circle,
                          dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: Constants.subtitle
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        Positioned(
          right: 0,
          left: 0,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'HISTÓRICO DE DEFEITOS ( ${reference.year} )',
                  style: Constants.subtitleHint,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await showYearPicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2026),
                            lastDate: DateTime(DateTime.now().year + 1))
                        .then((value) {
                      if (value != null) {
                        onChangeDate
                            ?.call(DateTime.now().copyWith(year: value));
                      }
                    });
                  },
                  tooltip: 'Alterar ano',
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: Colors.grey,
                  )),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 20,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: data.map((legend) {
                  return Row(
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: legend.color,
                      ),
                      Text(
                        legend.label,
                        style: Constants.subtitle,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ))
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
