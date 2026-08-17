// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarChartAvailability extends StatelessWidget {
  final DateTime reference;
  final List<CarStatusModel> status;

  const CarChartAvailability({
    Key? key,
    required this.status,
    required this.reference,
  }) : super(key: key);

  List<AvailabilityChartData> processAvailabilityData({
    required List<CarStatusModel> status,
    required int referenceYear,
  }) {
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
      'Dez',
    ];

    /// Ordena todo o histórico.
    final history = [...status]..sort((a, b) => a.date.compareTo(b.date));

    /// Agrupa os status por VTR.
    final Map<String, List<CarStatusModel>> statusByCar = {};

    for (final item in history) {
      if (item.carID.isEmpty) continue;

      statusByCar
          .putIfAbsent(
            item.carID,
            () => [],
          )
          .add(item);
    }

    final result = <AvailabilityChartData>[];

    for (int month = 1; month <= 12; month++) {
      final endOfMonth = DateTime(
        referenceYear,
        month + 1,
        0,
        23,
        59,
        59,
      );

      int available = 0;
      int unavailable = 0;
      int waiting = 0;

      /// Analisa cada VTR individualmente.
      for (final carHistory in statusByCar.values) {
        CarStatusModel? lastStatus;

        /// Pega o último status conhecido dessa VTR
        /// até o final do mês.
        for (final item in carHistory) {
          if (item.date.isAfter(endOfMonth)) {
            break;
          }

          lastStatus = item;
        }

        if (lastStatus == null) {
          continue;
        }

        switch (lastStatus.state) {
          case StatusCar.operating:
            available++;
            break;

          case StatusCar.broken:
            unavailable++;
            break;

          case StatusCar.waiting:
            waiting++;
            break;
        }
      }

      /// Waiting não participa da disponibilidade.
      final fleetCount = available + unavailable;

      final availability =
          fleetCount == 0 ? 0.0 : (available / fleetCount) * 100;

      result.add(
        AvailabilityChartData(
          month: months[month],
          availability: availability,
          available: available,
          unavailable: unavailable,
          waiting: waiting,
        ),
      );
    }

    return result;
  }

  double calcularMedia(List<double> valores) {
    final valoresValidos = valores.where((e) => e > 0).toList();

    if (valoresValidos.isEmpty) {
      return 0;
    }

    return valoresValidos.reduce(
          (a, b) => a + b,
        ) /
        valoresValidos.length;
  }

  String calcularTendencia(List<double> valores) {
    final valoresValidos = valores.where((e) => e > 0).toList();

    if (valoresValidos.length < 6) {
      return 'estavel';
    }

    final inicio = valoresValidos.take(3).reduce((a, b) => a + b) / 3;

    final fim =
        valoresValidos.skip(valoresValidos.length - 3).reduce((a, b) => a + b) /
            3;

    /// Evita que pequenas variações sejam consideradas
    /// uma mudança real de tendência.
    const margem = 1.0;

    if (fim > inicio + margem) {
      return 'subindo';
    }

    if (fim < inicio - margem) {
      return 'descendo';
    }

    return 'estavel';
  }

  @override
  Widget build(BuildContext context) {
    final data = processAvailabilityData(
      status: status,
      referenceYear: reference.year,
    );

    final disponibilidade = data.map((e) => e.availability).toList();

    final media = calcularMedia(disponibilidade);

    final tendencia = calcularTendencia(
      disponibilidade,
    );

    /// Último mês com dados.
    final mesesComDados =
        data.where((e) => e.available + e.unavailable > 0).toList();

    final atual = mesesComDados.isEmpty ? 0.0 : mesesComDados.last.availability;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'DISPONIBILIDADE DA FROTA ( ${reference.year} )',
                style: Constants.subtitleHint,
              ),
            ),
            if (status.isNotEmpty)
              PopupMenuButton(
                tooltip: 'Indicador de disponibilidade',
                child: const Icon(
                  Icons.info,
                  size: 20,
                  color: Colors.grey,
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 0,
                      enabled: false,
                      child: indicadorDisponibilidade(
                        atual: atual,
                        media: media,
                        tendencia: tendencia,
                      ),
                    ),
                  ];
                },
              ),
          ],
        ),
        Expanded(
          flex: 2,
          child: status.isEmpty
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
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                  ),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 100,
                    interval: 20,
                    axisLabelFormatter: (details) {
                      return ChartAxisLabel(
                        '${details.value.toInt()}%',
                        details.textStyle,
                      );
                    },
                  ),
                  series: <CartesianSeries>[
                    SplineSeries<AvailabilityChartData, String>(
                      name: 'Disponibilidade',
                      color: Colors.green.shade700,
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => d.availability,

                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                      ),

                      /// Tooltip personalizado.
                      enableTooltip: true,
                    ),

                    /// LINHA DA MÉDIA
                    LineSeries<AvailabilityChartData, String>(
                      name: 'Média',
                      color: Colors.green.withValues(alpha: 0.3),
                      dashArray: const [5, 5],
                      dataSource: data,
                      xValueMapper: (d, _) => d.month,
                      yValueMapper: (d, _) => media,
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
                    Icons.circle,
                    color: Colors.green.shade700,
                    size: 20,
                  ),
                  Text(
                    'Disponibilidade',
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
                    Icons.remove,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  Text(
                    'Média anual',
                    overflow: TextOverflow.ellipsis,
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

Widget indicadorDisponibilidade({
  required double atual,
  required double media,
  required String tendencia,
}) {
  IconData icone;
  String texto;
  Color cor;

  switch (tendencia) {
    case 'subindo':
      icone = Icons.trending_up;
      texto = 'Subindo';
      cor = Colors.green;
      break;

    case 'descendo':
      icone = Icons.trending_down;
      texto = 'Descendo';
      cor = Colors.red;
      break;

    default:
      icone = Icons.trending_flat;
      texto = 'Estável';
      cor = Colors.grey;
  }

  return IntrinsicHeight(
    child: Row(
      spacing: 8,
      children: [
        Container(
          height: 70,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: cor,
          ),
          child: Icon(
            icone,
            color: Colors.white,
            size: 22,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Disponibilidade',
              style: Constants.title,
            ),
            Text(
              'Atual: ${atual.toStringAsFixed(1)}%',
              style: Constants.subtitleHint,
            ),
            Text(
              'Média: ${media.toStringAsFixed(1)}%',
              style: Constants.subtitleHint,
            ),
            Text(
              texto,
              style: Constants.subtitleHint,
            ),
          ],
        ),
      ],
    ),
  );
}

class AvailabilityChartData {
  final String month;
  final double availability;

  /// Quantidade de VTRs disponíveis.
  final int available;

  /// Quantidade de VTRs baixadas.
  final int unavailable;

  /// Quantidade de VTRs aguardando incorporação.
  final int waiting;

  AvailabilityChartData({
    required this.month,
    required this.availability,
    required this.available,
    required this.unavailable,
    required this.waiting,
  });

  @override
  String toString() {
    return 'AvailabilityChartData('
        'month: $month, '
        'availability: $availability, '
        'available: $available, '
        'unavailable: $unavailable, '
        'waiting: $waiting'
        ')';
  }
}
