// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/details_cars_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarsChart extends StatelessWidget {
  final List<String> carsTypes;
  final List<CarModel> cars;
  final bool legends;
  final Function(List<DetailsCarsModel>)? onDetails;

  const CarsChart({
    Key? key,
    required this.carsTypes,
    required this.cars,
    this.legends = true,
    this.onDetails,
  }) : super(key: key);

  /// Processa toda a frota uma única vez.
  ///
  /// O mesmo resultado é utilizado pelo gráfico, legendas e detalhes.
  FleetSummary _processFleet() {
    final operatingCars = <CarModel>[];
    final reserveCars = <CarModel>[];
    final loweredCars = <CarModel>[];
    final waitingCars = <CarModel>[];
    final disabledCars = <CarModel>[];

    for (final car in cars) {
      if (!car.enable) {
        disabledCars.add(car);
      }

      switch (car.state) {
        case StatusCar.operating:
          operatingCars.add(car);
          break;

        // case StatusCar.reserva:
        //   reserveCars.add(car);
        //   break;

        case StatusCar.waiting:
          waitingCars.add(car);
          break;

        default:
          loweredCars.add(car);
          break;
      }
    }

    final details = <DetailsCarsModel>[];

    for (final type in carsTypes) {
      final typeCars = cars.where((car) => car.type == type).toList();

      if (typeCars.isEmpty) {
        continue;
      }

      int operating = 0;
      int reserve = 0;
      int lowered = 0;

      for (final car in typeCars) {
        switch (car.state) {
          case StatusCar.operating:
            operating++;
            break;

          // case StatusCar.reserva:
          //   reserve++;
          //   break;

          case StatusCar.waiting:
            break;

          default:
            lowered++;
            break;
        }
      }

      details.add(
        DetailsCarsModel(
          label: type,
          color: Core.corEscuraAleatoria(),
          operating: operating,
          reserve: reserve,
          lowered: lowered,
          cars: typeCars,
        ),
      );
    }

    return FleetSummary(
      total: cars.length,
      operating: operatingCars,
      reserve: reserveCars,
      lowered: loweredCars,
      waiting: waitingCars,
      disabled: disabledCars,
      details: details,
    );
  }

  List<_ChartData> _chartData(FleetSummary summary) {
    return [
      _ChartData(
        'Operando',
        summary.operating.length,
        Colors.green.shade700,
      ),
      _ChartData(
        'Reservas',
        summary.reserve.length,
        Colors.orange.shade700,
      ),
      _ChartData(
        'Baixadas',
        summary.lowered.length,
        Colors.red.shade700,
      ),
    ];
  }

  void _showFleetSummary(
    BuildContext context,
    FleetSummary summary,
  ) {
    onDetails?.call(summary.details);

    showDialog(
      context: context,
      builder: (context) {
        return _FleetSummaryDialog(summary: summary);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final summary = _processFleet();
    final data = _chartData(summary);

    final operationalTotal = summary.operating.length +
        summary.reserve.length +
        summary.lowered.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: SfCircularChart(
                        margin: EdgeInsets.zero,
                        series: <CircularSeries>[
                          DoughnutSeries<_ChartData, String>(
                            dataSource:
                                data.where((item) => item.value > 0).toList(),
                            xValueMapper: (item, _) => item.label,
                            yValueMapper: (item, _) => item.value,
                            pointColorMapper: (item, _) => item.color,
                            startAngle: -90,
                            endAngle: 90,
                            innerRadius: '65%',
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: Constants.title.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// Título + botão de detalhes
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DETALHES DA FROTA ',
                          style: Constants.subtitleHint,
                        ),
                      ),
                      if (!legends || cars.isEmpty)
                        IconButton(
                          onPressed: () => _showFleetSummary(
                            context,
                            summary,
                          ),
                          tooltip: 'Resumo da frota',
                          icon: const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                /// Total no centro do gráfico
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        operationalTotal.toString(),
                        style: Constants.title.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Viaturas',
                        style: Constants.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Legendas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.map((state) {
                final percentage = operationalTotal == 0
                    ? 0.0
                    : (state.value / operationalTotal) * 100;

                return Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.circle,
                        color: state.color,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: '${state.label} ',
                            children: [
                              TextSpan(
                                text: state.value == 0
                                    ? ''
                                    : '(${percentage.toStringAsFixed(0)}%)',
                                style: Constants.subtitleHint,
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                          style: Constants.subtitle,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// RESUMO DA FROTA
/// ---------------------------------------------------------------------------

class FleetSummary {
  final int total;
  final List<CarModel> operating;
  final List<CarModel> reserve;
  final List<CarModel> lowered;
  final List<CarModel> waiting;
  final List<CarModel> disabled;
  final List<DetailsCarsModel> details;

  const FleetSummary({
    required this.total,
    required this.operating,
    required this.reserve,
    required this.lowered,
    required this.waiting,
    required this.disabled,
    required this.details,
  });

  int get operationalTotal =>
      operating.length + reserve.length + lowered.length;

  int get availableTotal => operating.length + reserve.length;

  double percentage(int value) {
    if (operationalTotal == 0) {
      return 0;
    }

    return (value / operationalTotal) * 100;
  }
}

/// ---------------------------------------------------------------------------
/// DIALOG DE RESUMO
/// ---------------------------------------------------------------------------

class _FleetSummaryDialog extends StatelessWidget {
  final FleetSummary summary;

  const _FleetSummaryDialog({
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      title: Row(
        children: [
          Expanded(
            child: Text(
              'RESUMO DA FROTA',
              style: Constants.title.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 650,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryHeader(),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              Text(
                'SITUAÇÃO ATUAL',
                style: Constants.subtitleHint.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _statusCard(
                label: 'Operando',
                value: summary.operating.length,
                color: Colors.green.shade700,
                percentage: summary.percentage(
                  summary.operating.length,
                ),
              ),
              _statusCard(
                label: 'Reservas',
                value: summary.reserve.length,
                color: Colors.orange.shade700,
                percentage: summary.percentage(
                  summary.reserve.length,
                ),
              ),
              _statusCard(
                label: 'Baixadas',
                value: summary.lowered.length,
                color: Colors.red.shade700,
                percentage: summary.percentage(
                  summary.lowered.length,
                ),
              ),
              if (summary.waiting.isNotEmpty)
                _statusCard(
                  label: 'Aguardando',
                  value: summary.waiting.length,
                  color: Colors.grey.shade600,
                  percentage: summary.total == 0
                      ? 0
                      : (summary.waiting.length / summary.total) * 100,
                ),
              if (summary.disabled.isNotEmpty)
                _statusCard(
                  label: 'Desabilitadas',
                  value: summary.disabled.length,
                  color: Colors.black54,
                  percentage: summary.total == 0
                      ? 0
                      : (summary.disabled.length / summary.total) * 100,
                ),
              const SizedBox(height: 5),
              if (summary.details.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 5),
                Text(
                  'RESUMO POR TIPO',
                  style: Constants.subtitleHint.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ...summary.details.map(
                  (detail) => _typeSummary(detail),
                ),
              ],
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              Text(
                'VIATURAS ATUAIS',
                style: Constants.subtitleHint.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ..._buildCarsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryHeader() {
    return Row(
      children: [
        Expanded(
          child: _headerItem(
            'Total',
            summary.total,
            Colors.blueGrey.shade700,
          ),
        ),
        Expanded(
          child: _headerItem(
            'Operacionais',
            summary.operationalTotal,
            Colors.green.shade700,
          ),
        ),
        Expanded(
          child: _headerItem(
            'Disponíveis',
            summary.availableTotal,
            Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _headerItem(
    String label,
    int value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          MdiIcons.car,
          color: color,
          size: 25,
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: Constants.title.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Constants.subtitleHint,
        ),
      ],
    );
  }

  Widget _statusCard({
    required String label,
    required int value,
    required Color color,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 13,
              color: color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Constants.subtitle,
              ),
            ),
            Text(
              value.toString(),
              style: Constants.title.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 55,
              child: Text(
                '${percentage.toStringAsFixed(0)}%',
                textAlign: TextAlign.right,
                style: Constants.subtitleHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeSummary(DetailsCarsModel detail) {
    final total = detail.operating + detail.reserve + detail.lowered;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              detail.label.isEmpty ? 'Sem tipo' : detail.label,
              style: Constants.title.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _miniStatus(
            Icons.circle,
            Colors.green.shade700,
            detail.operating,
          ),
          _miniStatus(
            Icons.circle,
            Colors.orange.shade700,
            detail.reserve,
          ),
          _miniStatus(
            Icons.circle,
            Colors.red.shade700,
            detail.lowered,
          ),
          SizedBox(
            width: 40,
            child: Text(
              total.toString(),
              textAlign: TextAlign.right,
              style: Constants.title.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStatus(
    IconData icon,
    Color color,
    int value,
  ) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 11,
          ),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: Constants.subtitle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCarsList() {
    final widgets = <Widget>[];

    final allCars = [
      ...summary.operating,
      ...summary.reserve,
      ...summary.lowered,
      ...summary.waiting,
    ];

    for (final car in allCars) {
      widgets.add(
        _carItem(car),
      );
    }

    return widgets;
  }

  Widget _carItem(CarModel car) {
    // final color = _stateColor(car.state);
    // final label = _stateLabel(car.state);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              MdiIcons.car,
              size: 20,
              color: car.state.color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.prefix.isEmpty ? 'Sem prefixo' : car.prefix,
                    style: Constants.title.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (car.model.isNotEmpty)
                    Text(
                      [
                        if (car.model.isNotEmpty) car.model,
                        car.function.label,
                      ].join(' • '),
                      overflow: TextOverflow.ellipsis,
                      style: Constants.subtitleHint,
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  car.state.label,
                  style: Constants.subtitle.copyWith(
                    color: car.state.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (car.plate.isNotEmpty)
                  Text(
                    car.plate,
                    style: Constants.subtitleHint,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// DADOS DO GRÁFICO
/// ---------------------------------------------------------------------------

class _ChartData {
  final String label;
  final int value;
  final Color color;

  const _ChartData(
    this.label,
    this.value,
    this.color,
  );
}
