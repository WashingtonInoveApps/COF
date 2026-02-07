import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartPeriodWidget extends StatelessWidget {
  final DateTime dateStart;
  final DateTime dateFinish;
  final List<CheckListModel> checklists;

  const ChartPeriodWidget(
      {Key? key,
      required this.checklists,
      required this.dateStart,
      required this.dateFinish})
      : super(key: key);

  List<ChecklistChartData> buildChartData(List<CheckListModel> list) {
    Map<String, int> checklistsPorDia = {};
    Map<String, int> alteracoesPorDia = {};

    for (var c in list) {
      final date = (c.date);
      final key =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";

      checklistsPorDia[key] = (checklistsPorDia[key] ?? 0) + 1;
      alteracoesPorDia[key] = (alteracoesPorDia[key] ?? 0) + c.changes.length;
    }

    return checklistsPorDia.keys.map((day) {
      final checks = checklistsPorDia[day] ?? 0;
      final changes = alteracoesPorDia[day] ?? 0;

      return ChecklistChartData(
        day: day,
        checklists: checks,
        changes: changes,
        avg: checks == 0 ? 0 : changes / checks,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = List<CheckListModel>.from(checklists);
    list.sort((a, b) => a.date.compareTo(b.date));

    final data = buildChartData(list);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHECKLIST X ALTERAÇÕES X MÉDIA',
              style: Constants.subtitleHint,
            ),
            Text(
              '( ${Core.formatDate(dateStart)} - ${Core.formatDate(dateFinish)} )',
              style: Constants.subtitleHint,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 270,
              child: SfCartesianChart(
                legend: const Legend(
                    isVisible: true, position: LegendPosition.bottom),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: NumericAxis(
                    interval: 1,
                    decimalPlaces: 0,
                    title: AxisTitle(
                        text: 'Quantidade', textStyle: Constants.subtitle)),
                axes: <ChartAxis>[
                  NumericAxis(
                    name: 'avgAxis',
                    title: AxisTitle(
                      text: 'Média de alterações',
                      textStyle: Constants.subtitle,
                    ),
                    opposedPosition: true,
                    interval: 1,
                    decimalPlaces: 0,
                  ),
                ],
                series: <CartesianSeries>[
                  /// CHECKLISTS
                  ColumnSeries<ChecklistChartData, String>(
                    name: 'Checklists',
                    dataSource: data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.checklists,
                    width: 0.1,
                  ),

                  /// ALTERAÇÕES
                  ColumnSeries<ChecklistChartData, String>(
                    name: 'Alterações',
                    dataSource: data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.changes,
                    width: 0.1,
                  ),

                  /// MÉDIA
                  LineSeries<ChecklistChartData, String>(
                    name: 'Média por checklist',
                    dataSource: data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.avg,
                    yAxisName: 'avgAxis',
                    markerSettings: const MarkerSettings(isVisible: true),
                    width: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChecklistChartData {
  final String day;
  final int checklists;
  final int changes;
  final double avg;

  ChecklistChartData({
    required this.day,
    required this.checklists,
    required this.changes,
    required this.avg,
  });
}
