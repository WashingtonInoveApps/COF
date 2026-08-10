import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartChangesPeriodWidget extends StatelessWidget {
  final DateTime dateStart;
  final DateTime dateFinish;
  final List<ServiceModel> services;

  const ChartChangesPeriodWidget(
      {Key? key,
      required this.services,
      required this.dateStart,
      required this.dateFinish})
      : super(key: key);

  List<ServiceChangesData> buildChartData(List<ServiceModel> list) {
    Map<String, int> servicesByDay = {};
    Map<String, int> changesByDayCars = {};
    Map<String, int> changesByDayMaterials = {};

    for (var c in list) {
      final date = (c.date);
      final key =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";

      servicesByDay[key] = (servicesByDay[key] ?? 0) + 1;
      changesByDayCars[key] = (changesByDayCars[key] ?? 0) + c.changesCar;
      changesByDayMaterials[key] =
          (changesByDayMaterials[key] ?? 0) + c.changesMaterials;
    }

    return servicesByDay.keys.map((day) {
      final services = servicesByDay[day] ?? 0;
      final changesCar = changesByDayCars[day] ?? 0;
      final changesMaterials = changesByDayMaterials[day] ?? 0;

      return ServiceChangesData(
        day: day,
        services: services,
        changesCar: changesCar,
        changesMaterials: changesMaterials,
        avgCar: services == 0 ? 0 : changesCar / services,
        avgMaterials: services == 0 ? 0 : changesMaterials / services,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = List<ServiceModel>.from(services);
    list.sort((a, b) => a.date.compareTo(b.date));

    final data = buildChartData(list);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ALTERAÇÕES',
              style: Constants.subtitleHint,
            ),
            Text(
              ((dateStart.day == dateFinish.day) &&
                      (dateStart.month == dateFinish.month))
                  ? '( ${Core.formatDate(dateStart)} )'
                  : '( ${Core.formatDate(dateStart)} - ${Core.formatDate(dateFinish)} )',
              style: Constants.subtitleHint,
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
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
                series: <CartesianSeries>[
                  // /// ALTERAÇÕES
                  // ColumnSeries<ServiceChangesData, String>(
                  //   name: 'Viatura',
                  //   dataSource: data,
                  //   xValueMapper: (d, _) => d.day,
                  //   yValueMapper: (d, _) => d.changesCar,
                  //   width: 0.1,
                  // ),

                  // /// ALTERAÇÕES
                  // ColumnSeries<ServiceChangesData, String>(
                  //   name: 'Materiais',
                  //   dataSource: data,
                  //   xValueMapper: (d, _) => d.day,
                  //   yValueMapper: (d, _) => d.changesMaterials,
                  //   width: 0.1,
                  // ),

                  LineSeries<ServiceChangesData, String>(
                    name: 'Viaturas',
                    dataSource: data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.avgCar,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
                    color: Colors.red,
                    width: 3,
                  ),

                  LineSeries<ServiceChangesData, String>(
                    name: 'Materiais',
                    dataSource: data,
                    color: Colors.orange,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.avgMaterials,
                    markerSettings: const MarkerSettings(
                      isVisible: true,
                    ),
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

class ServiceChangesData {
  final String day;
  final int services;
  final int changesCar;
  final int changesMaterials;
  final double avgCar;
  final double avgMaterials;

  ServiceChangesData({
    required this.day,
    required this.services,
    required this.changesCar,
    required this.changesMaterials,
    required this.avgCar,
    required this.avgMaterials,
  });
}
