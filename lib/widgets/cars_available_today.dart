// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarsAvailabilityChart extends StatelessWidget {
  final List<CarModel> cars;

  /// Deve conter somente os checklists
  /// do dia operacional atual.
  final List<ChecklistModel> checklists;

  final bool legends;

  const CarsAvailabilityChart({
    Key? key,
    required this.cars,
    required this.checklists,
    this.legends = true,
  }) : super(key: key);

  // ===========================================================================
  // PROCESSAMENTO
  // ===========================================================================

  FleetAvailabilitySummary _processFleet() {
    final operatingCars = <CarModel>[];
    final reserveCars = <CarModel>[];
    final loweredCars = <CarModel>[];

    for (final car in cars) {
      if (!car.enable) {
        continue;
      }

      switch (car.state) {
        case StatusCar.operating:
          final hasChecklist = checklists.cast<ChecklistModel?>().firstWhere(
                (e) =>
                    e?.type == ChecklistType.vehicular &&
                    e?.vehicular?.car.id == car.id,
                orElse: () => null,
              );

          if (hasChecklist != null) {
            operatingCars.add(car);
          } else {
            reserveCars.add(car);
          }

          break;

        default:
          loweredCars.add(car);
          break;
      }
    }

    return FleetAvailabilitySummary(
      operating: operatingCars,
      reserve: reserveCars,
      lowered: loweredCars,
    );
  }

  // ===========================================================================
  // DADOS DO GRÁFICO
  // ===========================================================================

  List<_ChartData> _chartData(
    FleetAvailabilitySummary summary,
  ) {
    return [
      _ChartData(
        'Operando',
        summary.operating.length,
        Colors.green.shade700,
      ),
      _ChartData(
        'Reserva',
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

  // ===========================================================================
  // DIALOG
  // ===========================================================================

  void _showDetails(
    BuildContext context,
    FleetAvailabilitySummary summary,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return _CarsAvailabilityDialog(
          summary: summary,
          checklists: checklists,
        );
      },
    );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final summary = _processFleet();
    final data = _chartData(summary);

    final total = summary.total;

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
                  padding: const EdgeInsets.all(10),
                  child: ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: 0.5,
                      child: total == 0
                          ? const SizedBox(
                              height: 180,
                            )
                          : SfCircularChart(
                              margin: EdgeInsets.zero,
                              series: <CircularSeries>[
                                DoughnutSeries<_ChartData, String>(
                                  dataSource: data
                                      .where(
                                        (item) => item.value > 0,
                                      )
                                      .toList(),
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

                // ============================================================
                // TÍTULO + DETALHES
                // ============================================================

                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DISPONIBILIDADE DA FROTA (${Core.formatDate(DateTime.now())})',
                          style: Constants.subtitleHint,
                        ),
                      ),
                      if (cars.isNotEmpty)
                        IconButton(
                          onPressed: () => _showDetails(
                            context,
                            summary,
                          ),
                          tooltip: 'Detalhes',
                          icon: const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                // ============================================================
                // TOTAL
                // ============================================================

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        total.toString(),
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

            // ===============================================================
            // LEGENDA
            // ===============================================================

            if (legends)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.map((state) {
                  final percentage =
                      total == 0 ? 0.0 : (state.value / total) * 100;

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

// =============================================================================
// DIALOG
// =============================================================================

class _CarsAvailabilityDialog extends StatelessWidget {
  final FleetAvailabilitySummary summary;
  final List<ChecklistModel> checklists;

  const _CarsAvailabilityDialog({
    required this.summary,
    required this.checklists,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.fromLTRB(
        10,
        0,
        10,
        10,
      ),
      title: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Text(
              'DISPONIBILIDADE DA FROTA (${Core.formatDate(DateTime.now())})',
              style: Constants.subtitle.copyWith(
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
          maxWidth: 700,
          maxHeight: 650,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _summaryHeader(),
              // const SizedBox(height: 8),
              // const Divider(),
              // const SizedBox(height: 8),
              Text(
                'SITUAÇÃO ATUAL',
                style: Constants.subtitleHint.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _statusCard(
                label: 'Operando',
                description: 'Com checklist veicular realizado',
                value: summary.operating.length,
                color: Colors.green.shade700,
                percentage: summary.percentage(
                  summary.operating.length,
                ),
                icon: MdiIcons.car,
              ),
              _statusCard(
                label: 'Reserva',
                description: 'Operando sem checklist veicular',
                value: summary.reserve.length,
                color: Colors.orange.shade700,
                percentage: summary.percentage(
                  summary.reserve.length,
                ),
                icon: MdiIcons.carClock,
              ),
              _statusCard(
                label: 'Baixadas',
                description: 'VTR fora de operação',
                value: summary.lowered.length,
                color: Colors.red.shade700,
                percentage: summary.percentage(
                  summary.lowered.length,
                ),
                icon: MdiIcons.carOff,
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'VIATURAS',
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

  // ===========================================================================
  // STATUS
  // ===========================================================================

  Widget _statusCard({
    required String label,
    required String description,
    required int value,
    required Color color,
    required double percentage,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
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
              icon,
              size: 23,
              color: color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: Constants.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              value.toString(),
              style: Constants.title.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
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

  // ===========================================================================
  // LISTA DA FROTA (${Core.formatDate(DateTime.now())})
  // ===========================================================================

  List<Widget> _buildCarsList() {
    final widgets = <Widget>[];

    for (final car in summary.operating) {
      widgets.add(
        _carItem(
          car: car,
          status: 'Operando',
          description: 'Checklist realizado',
          color: Colors.green.shade700,
          icon: MdiIcons.car,
        ),
      );
    }

    for (final car in summary.reserve) {
      widgets.add(
        _carItem(
          car: car,
          status: 'Reserva',
          description: 'Checklist não realizado',
          color: Colors.orange.shade700,
          icon: MdiIcons.carClock,
        ),
      );
    }

    for (final car in summary.lowered) {
      widgets.add(
        _carItem(
          car: car,
          status: 'Baixada',
          description: 'Fora de operação',
          color: Colors.red.shade700,
          icon: MdiIcons.carOff,
        ),
      );
    }

    return widgets;
  }

  // ===========================================================================
  // ITEM DA VTR
  // ===========================================================================

  Widget _carItem({
    required CarModel car,
    required String status,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 9,
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
              icon,
              size: 21,
              color: color,
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
                  if (car.obm != null)
                    Text(
                      car.obm?.name ?? '',
                      style: Constants.subtitleHint,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// RESUMO
// =============================================================================

class FleetAvailabilitySummary {
  final List<CarModel> operating;
  final List<CarModel> reserve;
  final List<CarModel> lowered;

  const FleetAvailabilitySummary({
    required this.operating,
    required this.reserve,
    required this.lowered,
  });

  int get total => operating.length + reserve.length + lowered.length;

  int get available => operating.length + reserve.length;

  double get availability {
    if (total == 0) {
      return 0;
    }

    return (available / total) * 100;
  }

  double percentage(int value) {
    if (total == 0) {
      return 0;
    }

    return (value / total) * 100;
  }
}

// =============================================================================
// DADOS DO GRÁFICO
// =============================================================================

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
