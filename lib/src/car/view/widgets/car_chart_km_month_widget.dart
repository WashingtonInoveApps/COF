// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarChartKmByMonth extends StatelessWidget {
  final List<CheckListModel> checklists;
  const CarChartKmByMonth({Key? key, required this.checklists})
      : super(key: key);

  List<KmChartData> generateData(Map<String, double> data) {
    final lista = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<KmChartData> result =
        lista.map((e) => KmChartData(prefix: e.key, km: e.value)).toList();

    result.sort((a, b) => b.km.compareTo(a.km));
    return result.where((e) => e.km > 0).take(10).toList().reversed.toList();
  }

  double calcularMedia(Map<String, double> data) {
    return data.values.reduce((a, b) => a + b) / data.length;
  }

  Map<String, double> processCarsByKM(List<CheckListModel> checklists) {
    Map<String, List<CheckListModel>> carsKM = {};

    // Agrupar por viatura
    for (var check in checklists) {
      carsKM.putIfAbsent(check.prefix, () => []).add(check);
    }

    Map<String, double> result = {};

    for (var entry in carsKM.entries) {
      final carPrefix = entry.key;
      final list = entry.value;

      // Ordenar por data
      list.sort((a, b) => a.date.compareTo(b.date));

      double totalKm = 0;

      for (int i = 1; i < list.length; i++) {
        double atual = double.parse(list[i].startKM);
        double anterior = double.parse(list[i - 1].startKM);

        if (atual >= anterior) {
          totalKm += (atual - anterior);
        }
      }

      result[carPrefix] = totalKm;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final data = processCarsByKM(checklists);
    final dataChart = generateData(data);
    final media = calcularMedia(data);

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HISTÓRICO DE VEÍCULO X KM',
          style: Constants.subtitleHint,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SfCartesianChart(
              primaryXAxis: const CategoryAxis(),
              primaryYAxis: NumericAxis(
                plotBands: <PlotBand>[
                  PlotBand(
                    isVisible: true,
                    start: media,
                    end: media,
                    borderWidth: 1,
                    borderColor: Colors.red,
                    dashArray: const <double>[
                      6,
                      6
                    ], //linha tracejada, o modelo.
                    text: 'Média da frota',
                    textStyle: Constants.subtitle.copyWith(height: 1.5),
                    // horizontalTextAlignment: TextAnchor.middle,
                    horizontalTextAlignment: TextAnchor.start,
                    verticalTextAlignment: TextAnchor.middle,
                  )
                ],
              ),
              series: <CartesianSeries>[
                BarSeries<KmChartData, String>(
                  dataSource: dataChart,
                  width: 0.4, // 👈 espessura da barra (0 a 1)
                  spacing: 0.0, // 👈 espaço entre barras
                  xValueMapper: (data, _) => data.prefix,
                  yValueMapper: (data, _) => data.km,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true, textStyle: Constants.subtitle),
                  pointColorMapper: (data, _) {
                    if (data.km > media) return Colors.red;
                    if (data.km < media * 0.5) return Colors.orange;
                    return Colors.green;
                  },
                ),
              ],

              // 👇 Linha da média
              annotations: <CartesianChartAnnotation>[
                CartesianChartAnnotation(
                  widget: Container(
                    width: double.infinity,
                    height: 2,
                    color: Colors.red,
                  ),
                  coordinateUnit: CoordinateUnit.point,
                  x: dataChart.first.prefix,
                  y: media,
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.circle,
                    color: Colors.red,
                    size: 20,
                  ),
                  Text(
                    'Alto',
                    style: Constants.subtitle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.circle,
                    color: Colors.orange,
                    size: 20,
                  ),
                  Text(
                    'Médio',
                    style: Constants.subtitle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MdiIcons.circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  Text(
                    'Baixo',
                    style: Constants.subtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class KmChartData {
  final String prefix;
  final double km;

  KmChartData({
    required this.prefix,
    required this.km,
  });

  KmChartData copyWith({
    String? prefix,
    double? km,
  }) {
    return KmChartData(
      prefix: prefix ?? this.prefix,
      km: km ?? this.km,
    );
  }
}
