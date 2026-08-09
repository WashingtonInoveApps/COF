// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarChartTendencies extends StatelessWidget {
  final DateTime reference;
  final Function(DateTime)? onChangeDate;
  final List<CarStatusModel> status;
  const CarChartTendencies(
      {Key? key,
      required this.status,
      required this.reference,
      this.onChangeDate})
      : super(key: key);

  List<TendenciesChartData> processTendenciesData(
      {required List<CarStatusModel> status, required int referenceYear}) {
    final lows = status
        .where((e) => e.state == StatusCar.baixado)
        .map((e) => e.date)
        .toList();

    final operatings = status
        .where((e) =>
            (e.state != StatusCar.baixado) && (e.state != StatusCar.waiting))
        .map((e) => e.date)
        .toList();

    final Map<int, int> lowMonth = {for (int i = 1; i <= 12; i++) i: 0};
    final Map<int, int> operatingMonth = {for (int i = 1; i <= 12; i++) i: 0};

    for (var low in lows) {
      if (low.year == referenceYear) {
        lowMonth[low.month] = (lowMonth[low.month] ?? 0) + 1;
      }
    }

    for (var opera in operatings) {
      if (opera.year == referenceYear) {
        operatingMonth[opera.month] = (operatingMonth[opera.month] ?? 0) + 1;
      }
    }

    const months = [
      '',
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    return List.generate(12, (i) {
      final month = i + 1;
      return TendenciesChartData(
        month: months[month],
        lowering: lowMonth[month] ?? 0,
        operating: operatingMonth[month] ?? 0,
      );
    });
  }

  double calcularMedia(List<int> valores) {
    if (valores.isEmpty) return 0;
    return valores.reduce((a, b) => a + b) / valores.length;
  }

  /// tendência baseada nos últimos 3 meses vs primeiros 3
  String calcularTendencia(List<int> valores) {
    if (valores.length < 6) return 'estavel';

    final inicio = valores.take(3).reduce((a, b) => a + b);
    final fim = valores.skip(valores.length - 3).reduce((a, b) => a + b);

    if (fim > inicio) return 'subindo';
    if (fim < inicio) return 'descendo';
    return 'estavel';
  }

  @override
  Widget build(BuildContext context) {
    final data =
        processTendenciesData(status: status, referenceYear: reference.year);

    final listaBaixas = data.map((e) => e.lowering).toList();
    final listaRetornos = data.map((e) => e.operating).toList();

    final mediaBaixas = calcularMedia(listaBaixas);
    final mediaRetornos = calcularMedia(listaRetornos);

    final tendenciaBaixas = calcularTendencia(listaBaixas);
    final tendenciaRetornos = calcularTendencia(listaRetornos);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'TENDÊNCIAS DE FUNCIONAMENTO ( ${reference.year} )',
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
                      onChangeDate?.call(DateTime.now().copyWith(year: value));
                    }
                  });
                },
                tooltip: 'Alterar ano',
                icon: const Icon(
                  Icons.calendar_month,
                  size: 20,
                  color: Colors.grey,
                )),
            (status.isEmpty)
                ? Container()
                : PopupMenuButton(
                    onSelected: null,
                    tooltip: 'Indicadores de tendência',
                    child: const Icon(
                      Icons.info,
                      size: 20,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 0,
                          onTap: null,
                          // enabled: false,
                          mouseCursor: MouseCursor.uncontrolled,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: indicador('Baixas', mediaBaixas,
                                    tendenciaBaixas, Colors.red),
                              ),
                              Expanded(
                                child: indicador('Retornos', mediaRetornos,
                                    tendenciaRetornos, Colors.green),
                              ),
                            ],
                          ),
                        )
                      ];
                    }),
          ],
        ),
        Expanded(
          flex: 2,
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
              : SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: const CategoryAxis(),
                  series: <CartesianSeries>[
                    SplineSeries<TendenciesChartData, String>(
                      name: 'Baixas',
                      color: Colors.red.shade700,
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => d.lowering,
                      markerSettings: const MarkerSettings(
                          isVisible: true, shape: DataMarkerType.verticalLine),
                    ),
                    SplineSeries<TendenciesChartData, String>(
                      name: 'Retornos',
                      color: Colors.green.shade700,
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => d.operating,
                      markerSettings: const MarkerSettings(
                          isVisible: true, shape: DataMarkerType.verticalLine),
                    ),

                    /// 🔵 LINHA MÉDIA BAIXAS
                    LineSeries<TendenciesChartData, String>(
                      name: 'Média Baixas',
                      color: Colors.red.withValues(alpha: 0.3),
                      dashArray: const [5, 5],
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => mediaBaixas,
                    ),

                    /// 🟢 LINHA MÉDIA RETORNOS
                    LineSeries<TendenciesChartData, String>(
                      name: 'Média Retornos',
                      color: Colors.green.withValues(alpha: 0.3),
                      dashArray: const [5, 5],
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => mediaRetornos,
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
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  Text(
                    'Retorno',
                    overflow: TextOverflow.ellipsis,
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
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  Text(
                    'Baixas',
                    overflow: TextOverflow.ellipsis,
                    style: Constants.subtitle,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

Widget indicador(String titulo, double media, String tendencia, Color cor) {
  IconData icone;
  String texto;

  switch (tendencia) {
    case 'subindo':
      icone = Icons.trending_up;
      texto = 'Subindo';
      break;
    case 'descendo':
      icone = Icons.trending_down;
      texto = 'Descendo';
      break;
    default:
      icone = Icons.trending_flat;
      texto = 'Estável';
  }

  return IntrinsicHeight(
    child: Row(
      spacing: 5,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.all(2),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(5), color: cor),
          child: Icon(
            icone,
            color: Colors.white,
            size: 20,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: Constants.title),
            Text('Média: ${media.toStringAsFixed(1)}',
                style: Constants.subtitleHint),
            Text(texto, style: Constants.subtitleHint),
          ],
        ),
      ],
    ),
  );
}

class TendenciesChartData {
  final String month;
  final int operating;
  final int lowering;

  TendenciesChartData(
      {required this.month, required this.operating, required this.lowering});

  @override
  String toString() =>
      'TendenciesChartData(month: $month, operating: $operating, lowering: $lowering)';
}
