import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../core/constants.dart';
import '../../../core/core.dart';
import '../../../model/checklist_model.dart';

class CarKMModel {
  final String prefix;
  final double km;

  CarKMModel({
    required this.prefix,
    required this.km,
  });
}

class CarChartKmByMonth extends StatefulWidget {
  final DateTime referenceDate;
  final List<ChecklistModel> checklists;
  final Function(DateTime)? onChangeDate;

  const CarChartKmByMonth({
    Key? key,
    required this.checklists,
    required this.referenceDate,
    this.onChangeDate,
  }) : super(key: key);

  @override
  State<CarChartKmByMonth> createState() => _CarChartKmByMonthState();
}

class _CarChartKmByMonthState extends State<CarChartKmByMonth> {
  List<CarKMModel> dataChart = [];
  List<CarKMModel> chartList = [];
  double media = 0;

  @override
  void initState() {
    super.initState();
    processData();
  }

  @override
  void didUpdateWidget(covariant CarChartKmByMonth oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.checklists != widget.checklists) {
      processData();
    }
  }

  void processData() {
    dataChart = processCarsByKM(widget.checklists);

    media = calcularMedia(
      list: dataChart,
    );

    chartList = filterChart(
      list: dataChart,
    );
  }

  // ============================================================
  // PROCESSAMENTO DOS CHECKLISTS
  // ============================================================

  List<CarKMModel> processCarsByKM(
    List<ChecklistModel> checklists,
  ) {
    final Map<String, List<ChecklistModel>> grouped = {};

    // ----------------------------------------------------------
    // 1. Agrupa os checklists por VTR
    // ----------------------------------------------------------

    for (final checklist in checklists) {
      final carID = checklist.vehicular?.car.id;

      if (carID == null || carID.isEmpty) {
        continue;
      }

      grouped
          .putIfAbsent(
            carID,
            () => <ChecklistModel>[],
          )
          .add(checklist);
    }

    final List<CarKMModel> result = [];

    // ----------------------------------------------------------
    // 2. Processa cada VTR individualmente
    // ----------------------------------------------------------

    for (final entry in grouped.entries) {
      final List<ChecklistModel> list = List<ChecklistModel>.from(entry.value);

      // Precisamos de pelo menos duas leituras
      // para calcular a quilometragem do período.
      if (list.length < 2) {
        continue;
      }

      // --------------------------------------------------------
      // 3. Ordena cronologicamente
      // --------------------------------------------------------

      list.sort(
        (a, b) => a.date.compareTo(b.date),
      );

      final ChecklistModel first = list.first;
      final ChecklistModel last = list.last;

      // --------------------------------------------------------
      // 4. Obtém o primeiro KM
      // --------------------------------------------------------

      final double? firstKM = parseKM(
        first.startKM,
      );

      // --------------------------------------------------------
      // 5. Obtém o último KM
      // --------------------------------------------------------

      final double? lastKM = parseKM(
        last.startKM,
      );

      // Não conseguimos calcular.
      if (firstKM == null || lastKM == null) {
        continue;
      }

      // --------------------------------------------------------
      // 6. Valida o hodômetro
      // --------------------------------------------------------

      if (lastKM < firstKM) {
        debugPrint(
          'KM inválido para a VTR ${last.vehicular?.car.prefix}: '
          '$firstKM → $lastKM',
        );

        continue;
      }

      // --------------------------------------------------------
      // 7. Calcula KM do período
      // --------------------------------------------------------

      final double km = lastKM - firstKM;

      // Se não houve deslocamento, não entra no ranking.
      if (km <= 0) {
        continue;
      }

      // --------------------------------------------------------
      // 8. Adiciona ao resultado
      // --------------------------------------------------------

      result.add(
        CarKMModel(
          prefix: last.vehicular?.car.prefix ?? '',
          km: km,
        ),
      );
    }

    // ----------------------------------------------------------
    // 9. Ordena do maior para o menor KM
    // ----------------------------------------------------------

    result.sort(
      (a, b) => b.km.compareTo(a.km),
    );

    return result;
  }

  // ============================================================
  // CONVERSÃO SEGURA DO KM
  // ============================================================

  double? parseKM(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    final String text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text);
  }

  // ============================================================
  // MÉDIA
  // ============================================================

  double calcularMedia({
    required List<CarKMModel> list,
  }) {
    if (list.isEmpty) {
      return 0;
    }

    final double total = list.fold<double>(
      0,
      (sum, item) => sum + item.km,
    );

    return total / list.length;
  }

  // ============================================================
  // FILTRO DO GRÁFICO
  // ============================================================

  List<CarKMModel> filterChart({
    required List<CarKMModel> list,
  }) {
    return list
        .where(
          (item) => item.km > 0,
        )
        .take(8)
        .toList()
        .reversed
        .toList();
  }

  // ============================================================
  // CLASSIFICAÇÃO DA VTR
  // ============================================================

  Color getColor({
    required double km,
    required double media,
  }) {
    if (media <= 0) {
      return Colors.grey;
    }

    if (km > media) {
      return Colors.red;
    }

    if (km >= media * 0.5) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String getClassification({
    required double km,
    required double media,
  }) {
    if (media <= 0) {
      return 'Sem média';
    }

    if (km > media) {
      return 'Alto';
    }

    if (km >= media * 0.5) {
      return 'Médio';
    }

    return 'Baixo';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final double maximum = _getMaximum();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'VEÍCULO X KM ( ${Core.formatDate(widget.referenceDate, monthLarge: true)} )',
                style: Constants.subtitleHint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
          ],
        ),
        Expanded(
          child: chartList.isEmpty
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
                  primaryXAxis: const CategoryAxis(
                    labelRotation: -45,
                    majorGridLines: MajorGridLines(
                      width: 0,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: maximum,
                    interval: _getInterval(maximum),
                    numberFormat: NumberFormat.decimalPattern('pt_BR'),
                    plotBands: [
                      if (media > 0)
                        PlotBand(
                          isVisible: true,
                          start: media,
                          end: media,
                          borderWidth: 2,
                          borderColor: Colors.yellow.shade700,
                          dashArray: const <double>[
                            8,
                            4,
                          ],
                          text: 'Média',
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          horizontalTextAlignment: TextAnchor.end,
                        ),
                    ],
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    format: 'point.x : point.y km',
                  ),
                  series: <CartesianSeries<CarKMModel, String>>[
                    ColumnSeries<CarKMModel, String>(
                      dataSource: chartList,
                      xValueMapper: (
                        CarKMModel data,
                        _,
                      ) =>
                          data.prefix,
                      yValueMapper: (
                        CarKMModel data,
                        _,
                      ) =>
                          data.km,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      pointColorMapper: (
                        CarKMModel data,
                        _,
                      ) =>
                          getColor(
                        km: data.km,
                        media: media,
                      ),
                      width: 0.7,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // ============================================================
  // MÁXIMO DO EIXO Y
  // ============================================================

  double _getMaximum() {
    double maximum = 0;

    for (final item in chartList) {
      if (item.km > maximum) {
        maximum = item.km;
      }
    }

    if (media > maximum) {
      maximum = media;
    }

    if (maximum <= 0) {
      return 100;
    }

    // Adiciona uma margem para o maior valor
    return maximum * 1.15;
  }

  // ============================================================
  // INTERVALO DO EIXO Y
  // ============================================================

  double _getInterval(
    double maximum,
  ) {
    if (maximum <= 100) {
      return 20;
    }

    if (maximum <= 500) {
      return 100;
    }

    if (maximum <= 1000) {
      return 200;
    }

    if (maximum <= 5000) {
      return 1000;
    }

    if (maximum <= 10000) {
      return 2000;
    }

    return 5000;
  }
}
// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bsu_control/core/constants.dart';
// import 'package:bsu_control/core/core.dart';
// import 'package:bsu_control/model/checklist_model.dart';
// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CarChartKmByMonth extends StatefulWidget {
//   final DateTime referenceDate;
//   final List<ChecklistModel> checklists;
//   final Function(DateTime)? onChangeDate;
//   const CarChartKmByMonth(
//       {Key? key,
//       required this.checklists,
//       this.onChangeDate,
//       required this.referenceDate})
//       : super(key: key);

//   @override
//   State<CarChartKmByMonth> createState() => _CarChartKmByMonthState();
// }

// class _CarChartKmByMonthState extends State<CarChartKmByMonth> {
//   final scroll = ScrollController();

//   List<KmChartData> dataChart = [];

//   double media = 0.0;

//   List<KmChartData> generateData(Map<String, double> data) {
//     if (data.isEmpty) return [];

//     final lista = data.entries.toList()
//       ..sort((a, b) => b.value.compareTo(a.value));

//     List<KmChartData> result =
//         lista.map((e) => KmChartData(prefix: e.key, km: e.value)).toList();

//     result.sort((a, b) => b.km.compareTo(a.km));
//     return result;
//   }

//   List<KmChartData> filterChart({required List<KmChartData> list}) {
//     return list.where((e) => e.km > 0).take(8).toList().reversed.toList();
//   }

//   double calcularMedia({required List<KmChartData> list}) {
//     if (list.isEmpty) return 0;

//     return list.map((e) => e.km).reduce((a, b) => a + b) / list.length;
//   }

//   Map<String, double> processCarsByKM(List<ChecklistModel> checklists) {
//     if (checklists.isEmpty) return {};

//     Map<String, List<ChecklistModel>> carsKM = {};

//     // Agrupar por viatura
//     for (var check in checklists) {
//       carsKM.putIfAbsent(check.prefix, () => []).add(check);
//     }

//     Map<String, double> result = {};

//     for (var entry in carsKM.entries) {
//       final carPrefix = entry.key;
//       final list = entry.value;

//       // Ordenar por data
//       list.sort((a, b) => a.date.compareTo(b.date));

//       double totalKm = 0;

//       for (int i = 1; i < list.length; i++) {
//         double atual = double.parse(list[i].startKM.toString());
//         double anterior = double.parse(list[i - 1].startKM.toString());

//         if (atual >= anterior) {
//           totalKm += (atual - anterior);
//         }
//       }

//       result[carPrefix] = totalKm;
//     }

//     return result;
//   }

//   Color getColorByKM({required double km, required double media}) {
//     if (km > media) return Colors.red;
//     if (km >= media * 0.5) return Colors.orange;
//     return Colors.green;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     scroll.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.checklists.isNotEmpty) {
//       dataChart = generateData(processCarsByKM(widget.checklists));
//       media = calcularMedia(list: dataChart);
//     }

//     final list = filterChart(list: dataChart);

//     return Column(
//       spacing: 10,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'VEÍCULO X KM ( ${Core.formatDate(widget.referenceDate, monthLarge: true)} )',
//                     style: Constants.subtitleHint,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     'Média: ${media.toStringAsFixed(2)} Km',
//                     style: Constants.subtitleHint,
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//                 onPressed: () async {
//                   await showMonthPicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2026),
//                           lastDate: DateTime(DateTime.now().year + 1))
//                       .then((value) {
//                     if (value != null) {
//                       widget.onChangeDate?.call(value);
//                     }
//                   });
//                 },
//                 tooltip: 'Alterar mês',
//                 icon: const Icon(
//                   Icons.calendar_month,
//                   size: 20,
//                   color: Colors.grey,
//                 )),
//             (list.isEmpty)
//                 ? Container()
//                 : IconButton(
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               contentPadding: const EdgeInsets.all(10),
//                               content: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerRight,
//                                       child: InkWell(
//                                         onTap: () =>
//                                             Navigator.of(context).pop(),
//                                         child: CircleAvatar(
//                                             radius: 15,
//                                             backgroundColor: Colors.black45,
//                                             child: Icon(
//                                               MdiIcons.close,
//                                               size: 20,
//                                               color: Colors.white,
//                                             )),
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     Column(
//                                       children: List.generate(dataChart.length,
//                                               (index) {
//                                         final carData = dataChart[index];
//                                         final barWidth =
//                                             ((carData.km / dataChart.first.km) *
//                                                 250);

//                                         return Row(
//                                           spacing: 10,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: [
//                                             Expanded(
//                                                 child: Column(
//                                               spacing: 1,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   carData.prefix,
//                                                   style: Constants.subtitleHint,
//                                                 ),
//                                                 Container(
//                                                   width: barWidth,
//                                                   height: 10,
//                                                   color: getColorByKM(
//                                                       km: carData.km,
//                                                       media: media),
//                                                 ),
//                                               ],
//                                             )),
//                                             Text(
//                                               '${carData.km} KM',
//                                               style: Constants.titleHint,
//                                             )
//                                           ],
//                                         );
//                                       })
//                                           .expand((widget) => [
//                                                 widget,
//                                                 Divider(
//                                                   color: Colors.grey.shade200,
//                                                 )
//                                               ])
//                                           .toList(),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             );
//                           });
//                     },
//                     tooltip: 'Detalhes do ranking',
//                     icon: const Icon(
//                       Icons.info,
//                       size: 20,
//                       color: Colors.grey,
//                     ))
//           ],
//         ),
//         Expanded(
//           child: list.isEmpty
//               ? Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     spacing: 5,
//                     children: [
//                       const Icon(
//                         Icons.access_time_rounded,
//                         size: 20,
//                         color: Colors.grey,
//                       ),
//                       Text(
//                         'Aguardando dados...',
//                         style: Constants.subtitleHint,
//                       ),
//                     ],
//                   ),
//                 )
//               : SfCartesianChart(
//                   primaryXAxis: const CategoryAxis(),
//                   primaryYAxis: NumericAxis(
//                     plotBands: <PlotBand>[
//                       PlotBand(
//                         isVisible: true,
//                         start: media,
//                         end: media,
//                         borderWidth: 1,
//                         borderColor: Colors.yellow,
//                         dashArray: const <double>[
//                           6,
//                           6
//                         ], //linha tracejada, o modelo.
//                         text: 'Média da frota',
//                         textStyle: Constants.subtitle.copyWith(height: 1.5),
//                         horizontalTextAlignment: TextAnchor.start,
//                         verticalTextAlignment: TextAnchor.middle,
//                       )
//                     ],
//                   ),
//                   series: <CartesianSeries>[
//                     BarSeries<KmChartData, String>(
//                       dataSource: list,
//                       width: 0.5, // 👈 espessura da barra (0 a 1)
//                       spacing: 0.0, // 👈 espaço entre barras
//                       xValueMapper: (data, _) => data.prefix,
//                       yValueMapper: (data, _) => data.km,
//                       dataLabelSettings: DataLabelSettings(
//                           isVisible: true,
//                           labelAlignment: ChartDataLabelAlignment.middle,
//                           textStyle: Constants.subtitle.copyWith(
//                               fontSize: 10,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white)),
//                       pointColorMapper: (data, _) {
//                         return getColorByKM(km: data.km, media: media);
//                       },
//                     ),
//                   ],

//                   // // 👇 Linha da média
//                   // annotations: <CartesianChartAnnotation>[
//                   //   CartesianChartAnnotation(
//                   //     widget: Container(
//                   //       width: double.infinity,
//                   //       height: 2,
//                   //       color: Colors.yellow,
//                   //     ),
//                   //     coordinateUnit: CoordinateUnit.point,
//                   //     x: list.isEmpty ? '' : list.first.prefix,
//                   //     y: media,
//                   //   ),
//                   // ],
//                 ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Expanded(
//               child: Row(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     MdiIcons.circle,
//                     color: Colors.red,
//                     size: 20,
//                   ),
//                   Text(
//                     'Alto',
//                     style: Constants.subtitle,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     MdiIcons.circle,
//                     color: Colors.orange,
//                     size: 20,
//                   ),
//                   Text(
//                     'Médio',
//                     style: Constants.subtitle,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 spacing: 10,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     MdiIcons.circle,
//                     color: Colors.green,
//                     size: 20,
//                   ),
//                   Text(
//                     'Baixo',
//                     style: Constants.subtitle,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class KmChartData {
//   final String prefix;
//   final double km;

//   KmChartData({
//     required this.prefix,
//     required this.km,
//   });

//   KmChartData copyWith({
//     String? prefix,
//     double? km,
//   }) {
//     return KmChartData(
//       prefix: prefix ?? this.prefix,
//       km: km ?? this.km,
//     );
//   }

//   @override
//   String toString() => 'KmChartData(prefix: $prefix, km: $km)';
// }
