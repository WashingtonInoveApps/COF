// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class UserStateChart extends StatelessWidget {
  final List<ChecklistModel> checklists;
  const UserStateChart({Key? key, required this.checklists}) : super(key: key);

  List<StatusChartData> processStates(List<ChecklistModel> list) {
    List<StatusChartData> result = [];
    for (final state in StateChecklist.values) {
      final checklists = list.where((e) => e.state == state).toList();

      result.add(StatusChartData(state: state, value: checklists.length));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    double taxa = 0;

    final data = processStates(checklists);
    final completed =
        data.where((e) => e.state == StateChecklist.completed).toList();

    if (completed.isNotEmpty) {
      final value =
          completed.map((e) => e.value).reduce((value, next) => value + next);
      taxa = (value * 100) / checklists.length;
    }

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAXA DE CONCLUSÃO DE REGISTROS',
          style: Constants.subtitleHint,
        ),
        Expanded(
            child: checklists.isEmpty
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
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Spacer(),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    'Crítico',
                                    style: Constants.subtitle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.circle,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    'Atenção',
                                    style: Constants.subtitle,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  MdiIcons.circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    'Excelente',
                                    style: Constants.subtitle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              showTicks: true,
                              showLabels: true,
                              interval: 20,
                              axisLineStyle: const AxisLineStyle(
                                thickness: 0.15,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              ranges: <GaugeRange>[
                                GaugeRange(
                                  startValue: 0,
                                  endValue: 50,
                                  color: Colors.red,
                                ),
                                GaugeRange(
                                  startValue: 50,
                                  endValue: 80,
                                  color: Colors.orange,
                                ),
                                GaugeRange(
                                  startValue: 80,
                                  endValue: 100,
                                  color: Colors.green,
                                ),
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: taxa,
                                  needleLength: 0.7,
                                  needleStartWidth: 1, // largura na base
                                  needleEndWidth: 3, // largura na ponta
                                  needleColor: Colors.black,
                                  knobStyle: const KnobStyle(
                                    color: Colors.black,
                                    knobRadius:
                                        0.06, //Circulo central do ponteiro
                                  ),
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  widget: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${taxa.toStringAsFixed(0)}%',
                                        style: Constants.title.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Conclusão',
                                        style: Constants.title,
                                      ),
                                    ],
                                  ),
                                  angle: 90,
                                  positionFactor: 0.8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
      ],
    );
  }
}

class StatusChartData {
  final StateChecklist state;
  final int value;
  StatusChartData({required this.state, required this.value});
}
