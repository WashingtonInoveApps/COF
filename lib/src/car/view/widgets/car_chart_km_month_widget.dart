// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarChartKmByMonth extends StatefulWidget {
  final DateTime referenceDate;
  final List<CheckListModel> checklists;
  final Function(DateTime)? onChangeDate;
  const CarChartKmByMonth(
      {Key? key,
      required this.checklists,
      this.onChangeDate,
      required this.referenceDate})
      : super(key: key);

  @override
  State<CarChartKmByMonth> createState() => _CarChartKmByMonthState();
}

class _CarChartKmByMonthState extends State<CarChartKmByMonth> {
  final scroll = ScrollController();

  List<KmChartData> dataChart = [];

  double media = 0.0;

  List<KmChartData> generateData(Map<String, double> data) {
    if (data.isEmpty) return [];

    final lista = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<KmChartData> result =
        lista.map((e) => KmChartData(prefix: e.key, km: e.value)).toList();

    result.sort((a, b) => b.km.compareTo(a.km));
    return result;
  }

  List<KmChartData> filterChart({required List<KmChartData> list}) {
    return list.where((e) => e.km > 0).take(8).toList().reversed.toList();
  }

  double calcularMedia({required List<KmChartData> list}) {
    if (list.isEmpty) return 0;

    return list.map((e) => e.km).reduce((a, b) => a + b) / list.length;
  }

  Map<String, double> processCarsByKM(List<CheckListModel> checklists) {
    if (checklists.isEmpty) return {};

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

  Color getColorByKM({required double km, required double media}) {
    if (km > media) return Colors.red;
    if (km > (media * 0.5) && km < media) return Colors.orange;
    return Colors.green;
  }

  @override
  void dispose() {
    super.dispose();
    scroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.checklists.isNotEmpty) {
      dataChart = generateData(processCarsByKM(widget.checklists));
      media = calcularMedia(list: dataChart);
    }

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RANKING DE VEÍCULO X KM ( ${Core.formatDate(widget.referenceDate, monthLarge: true)} )',
                    style: Constants.subtitleHint,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Média: ${media.toStringAsFixed(2)} Km',
                    style: Constants.subtitleHint,
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () async {
                  await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2026),
                          lastDate: DateTime(DateTime.now().year + 1))
                      .then((value) {
                    if (value != null) {
                      widget.onChangeDate?.call(value);
                    }
                  });
                },
                tooltip: 'Alterar mês',
                icon: const Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: Colors.grey,
                )),
            (widget.checklists.isEmpty)
                ? Container()
                : IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: const EdgeInsets.all(10),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.black45,
                                            child: Icon(
                                              MdiIcons.close,
                                              size: 20,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: List.generate(dataChart.length,
                                              (index) {
                                        final carData = dataChart[index];
                                        final barWidth =
                                            ((carData.km / dataChart.first.km) *
                                                250);

                                        return Row(
                                          spacing: 10,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Expanded(
                                                child: Column(
                                              spacing: 1,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  carData.prefix,
                                                  style: Constants.subtitleHint,
                                                ),
                                                Container(
                                                  width: barWidth,
                                                  height: 10,
                                                  color: getColorByKM(
                                                      km: carData.km,
                                                      media: media),
                                                ),
                                              ],
                                            )),
                                            Text(
                                              '${carData.km} KM',
                                              style: Constants.titleHint,
                                            )
                                          ],
                                        );
                                      })
                                          .expand((widget) => [
                                                widget,
                                                Divider(
                                                  color: Colors.grey.shade200,
                                                )
                                              ])
                                          .toList(),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    tooltip: 'Detalhes do ranking',
                    icon: const Icon(
                      Icons.info,
                      size: 20,
                      color: Colors.grey,
                    ))
          ],
        ),
        Expanded(
          child: dataChart.isEmpty
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
              : SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    plotBands: <PlotBand>[
                      PlotBand(
                        isVisible: true,
                        start: media,
                        end: media,
                        borderWidth: 1,
                        borderColor: Colors.yellow,
                        dashArray: const <double>[
                          6,
                          6
                        ], //linha tracejada, o modelo.
                        text: 'Média da frota',
                        textStyle: Constants.subtitle.copyWith(height: 1.5),
                        horizontalTextAlignment: TextAnchor.start,
                        verticalTextAlignment: TextAnchor.middle,
                      )
                    ],
                  ),
                  series: <CartesianSeries>[
                    BarSeries<KmChartData, String>(
                      dataSource: filterChart(list: dataChart),
                      width: 0.5, // 👈 espessura da barra (0 a 1)
                      spacing: 0.0, // 👈 espaço entre barras
                      xValueMapper: (data, _) => data.prefix,
                      yValueMapper: (data, _) => data.km,
                      dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.middle,
                          textStyle: Constants.subtitle.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      pointColorMapper: (data, _) {
                        return getColorByKM(km: data.km, media: media);
                      },
                    ),
                  ],

                  // 👇 Linha da média
                  annotations: <CartesianChartAnnotation>[
                    CartesianChartAnnotation(
                      widget: Container(
                        width: double.infinity,
                        height: 2,
                        color: Colors.yellow,
                      ),
                      coordinateUnit: CoordinateUnit.point,
                      x: filterChart(list: dataChart).first.prefix,
                      y: media,
                    ),
                  ],
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
