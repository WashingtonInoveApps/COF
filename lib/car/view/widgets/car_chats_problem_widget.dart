// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../model/car_model.dart';

class CarChartProblems extends StatelessWidget {
  final DateTime reference;
  final List<CarStatusModel> status;
  final List<CarModel> cars;

  const CarChartProblems({
    Key? key,
    required this.status,
    required this.reference,
    required this.cars,
  }) : super(key: key);

  /// Percentual mínimo para uma categoria aparecer
  /// individualmente no gráfico.
  ///
  /// Categorias abaixo disso serão agrupadas em "Outros".
  static const double percentageToGroup = 5.0;

  /// Cria os dados da pizza.
  List<PieData> buildPieData(
    List<CarStatusModel> status,
  ) {
    final Map<String, PieData> grouped = {};

    for (final item in status) {
      final type = item.type;

      if (type == null) {
        continue;
      }

      final label = type.label;

      if (grouped.containsKey(label)) {
        grouped[label]!.count++;

        grouped[label]!.statuses.add(item);
      } else {
        grouped[label] = PieData(
          label: label,
          count: 1,
          color: type.color,
          statuses: [item],
        );
      }
    }

    final data = grouped.values.toList();

    if (data.isEmpty) {
      return [];
    }

    final total = data.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );

    final principais = <PieData>[];
    final outrosStatuses = <CarStatusModel>[];

    for (final item in data) {
      final percentage = (item.count / total) * 100;

      if (percentage >= percentageToGroup) {
        principais.add(item);
      } else {
        outrosStatuses.addAll(
          item.statuses,
        );
      }
    }

    if (outrosStatuses.isNotEmpty) {
      principais.add(
        PieData(
          label: 'Outros',
          count: outrosStatuses.length,
          color: Colors.grey,
          statuses: outrosStatuses,
        ),
      );
    }

    /// Maior quantidade primeiro.
    principais.sort(
      (a, b) => b.count.compareTo(a.count),
    );

    return principais;
  }

  /// Abre o detalhamento da categoria selecionada.
  void showProblemDetails(
    BuildContext context,
    PieData data,
  ) {
    final statuses = [...data.statuses]..sort(
        (a, b) => b.date.compareTo(a.date),
      );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(
            20,
            20,
            10,
            10,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            10,
          ),
          title: Row(
            children: [
              Icon(
                Icons.build_circle_outlined,
                color: data.color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 550,
            height: 450,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.count} ocorrência'
                  '${data.count == 1 ? '' : 's'}',
                  style: Constants.title,
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: statuses.isEmpty
                      ? Center(
                          child: Text(
                            'Nenhum registro encontrado.',
                            style: Constants.subtitleHint,
                          ),
                        )
                      : ListView.separated(
                          itemCount: statuses.length,
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            final item = statuses[index];

                            final car = cars.cast<CarModel?>().firstWhere(
                                (e) => e?.id == item.carID,
                                orElse: () => null);

                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: data.color.withValues(
                                  alpha: 0.15,
                                ),
                                child: Icon(
                                  Icons.directions_car,
                                  color: data.color,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                car?.prefix ?? 'VTR não encontrada.',
                                style: Constants.title
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.description.isNotEmpty)
                                    Text(
                                      item.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Constants.title,
                                    ),
                                  if (item.local.isNotEmpty)
                                    Text(
                                      item.local,
                                      style: Constants.subtitleHint,
                                    ),
                                  Text(
                                    Core.formatDate(item.date,
                                        largeDayHour: true),
                                    style: Constants.subtitleHint,
                                  ),
                                ],
                              ),
                              // trailing: const Icon(
                              //   Icons.chevron_right,
                              //   color: Colors.grey,
                              // ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Somente baixas do ano selecionado.
    final list = status
        .where(
          (e) => e.state == StatusCar.broken && e.date.year == reference.year,
        )
        .toList();

    final data = buildPieData(list);

    final totalWithType = list.where((e) => e.type != null).length;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Expanded(
                flex: 1,
                child: list.isEmpty || data.isEmpty
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
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          SfCircularChart(
                            margin: EdgeInsets.zero,
                            series: <CircularSeries>[
                              DoughnutSeries<PieData, String>(
                                dataSource: data,

                                xValueMapper: (
                                  PieData data,
                                  _,
                                ) =>
                                    data.label,

                                yValueMapper: (
                                  PieData data,
                                  _,
                                ) =>
                                    data.count,

                                pointColorMapper: (
                                  PieData data,
                                  _,
                                ) =>
                                    data.color,

                                innerRadius: '62%',

                                radius: '90%',

                                dataLabelMapper: (
                                  PieData data,
                                  _,
                                ) {
                                  final percentage = totalWithType == 0
                                      ? 0
                                      : (data.count / totalWithType) * 100;

                                  return '${percentage.toStringAsFixed(1)}%';
                                },

                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: Constants.subtitle.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                enableTooltip: true,

                                /// Clique na fatia.
                                onPointTap: (ChartPointDetails details) {
                                  final index = details.pointIndex;

                                  if (index == null ||
                                      index < 0 ||
                                      index >= data.length) {
                                    return;
                                  }

                                  final selected = data[index];

                                  showProblemDetails(
                                    context,
                                    selected,
                                  );
                                },
                              ),
                            ],
                          ),

                          /// Centro da pizza.
                          IgnorePointer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$totalWithType',
                                  style: Constants.title.copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Baixas',
                                  style: Constants.subtitleHint,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),

        /// CABEÇALHO
        Positioned(
          right: 0,
          left: 0,
          child: Text(
            'BAIXAS POR TIPO DE DEFEITO ( ${reference.year} )',
            style: Constants.subtitleHint,
          ),
        ),

        /// LEGENDA
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 20,
            child: data.isEmpty
                ? const SizedBox()
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: data.map(
                      (legend) {
                        final percentage = totalWithType == 0
                            ? 0
                            : (legend.count / totalWithType) * 100;

                        return Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 13,
                                color: legend.color,
                              ),
                              Text(
                                '${legend.label} '
                                '(${legend.count} - '
                                '${percentage.toStringAsFixed(1)}%)',
                                style: Constants.subtitle,
                              ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

class PieData {
  String label;
  int count;
  Color color;

  List<CarStatusModel> statuses;

  PieData({
    required this.label,
    required this.count,
    required this.color,
    this.statuses = const [],
  });

  PieData copyWith({
    String? label,
    int? count,
    Color? color,
    List<CarStatusModel>? statuses,
  }) {
    return PieData(
      label: label ?? this.label,
      count: count ?? this.count,
      color: color ?? this.color,
      statuses: statuses ?? this.statuses,
    );
  }
}
// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bsu_control/core/constants.dart';
// import 'package:bsu_control/enum/car_enum.dart';
// import 'package:bsu_control/model/car_status_model.dart';
// import 'package:flutter/material.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class CarChartProblems extends StatelessWidget {
//   final DateTime reference;
//   final Function(DateTime)? onChangeDate;
//   final List<CarStatusModel> status;
//   const CarChartProblems(
//       {Key? key,
//       required this.status,
//       required this.reference,
//       this.onChangeDate})
//       : super(key: key);

//   List<PieData> buildPieData(List<CarStatusModel> status) {
//     List<PieData> data = [];

//     for (final state in status) {
//       final index = data.indexWhere((e) => e.label == state.type!.label);

//       if (index == -1) {
//         data.add(PieData(
//             label: state.type!.label, count: 1, color: state.type!.color));
//       } else {
//         final result = data[index];
//         result.count = (result.count + 1);
//       }
//     }

//     return data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final list = status.where((e) => e.state == StatusCar.baixado).toList();
//     final data = buildPieData(list);

//     return Stack(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               flex: 1,
//               child: (list.isEmpty)
//                   ? Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         spacing: 5,
//                         children: [
//                           const Icon(
//                             Icons.access_time_rounded,
//                             size: 20,
//                             color: Colors.grey,
//                           ),
//                           Text(
//                             'Aguardando dados...',
//                             style: Constants.subtitleHint,
//                           ),
//                         ],
//                       ),
//                     )
//                   : SfCircularChart(
//                       series: <CircularSeries>[
//                         PieSeries<PieData, String>(
//                           dataSource: data,
//                           xValueMapper: (PieData data, _) => data.label,
//                           yValueMapper: (PieData data, _) => data.count,
//                           pointColorMapper: (data, _) => data.color,
//                           dataLabelMapper: (data, _) =>
//                               '${((data.count / status.length) * 100).toString()}%',
//                           // legendIconType: LegendIconType.circle,
//                           dataLabelSettings: DataLabelSettings(
//                               isVisible: true,
//                               textStyle: Constants.subtitle
//                                   .copyWith(color: Colors.white)),
//                         ),
//                       ],
//                     ),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//           ],
//         ),
//         Positioned(
//           right: 0,
//           left: 0,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   'HISTÓRICO DE DEFEITOS ( ${reference.year} )',
//                   style: Constants.subtitleHint,
//                 ),
//               ),
//               IconButton(
//                   onPressed: () async {
//                     await showYearPicker(
//                             context: context,
//                             initialDate: DateTime.now(),
//                             firstDate: DateTime(2026),
//                             lastDate: DateTime(DateTime.now().year + 1))
//                         .then((value) {
//                       if (value != null) {
//                         onChangeDate
//                             ?.call(DateTime.now().copyWith(year: value));
//                       }
//                     });
//                   },
//                   tooltip: 'Alterar ano',
//                   icon: const Icon(
//                     Icons.calendar_month,
//                     size: 20,
//                     color: Colors.grey,
//                   )),
//             ],
//           ),
//         ),
//         Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: 20,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: data.map((legend) {
//                   return Row(
//                     spacing: 5,
//                     children: [
//                       Icon(
//                         Icons.circle,
//                         size: 15,
//                         color: legend.color,
//                       ),
//                       Text(
//                         legend.label,
//                         style: Constants.subtitle,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ))
//       ],
//     );
//   }
// }

// class PieData {
//   String label;
//   int count;
//   Color color;

//   PieData({required this.label, required this.count, required this.color});

//   PieData copyWith({
//     String? label,
//     int? count,
//     Color? color,
//   }) {
//     return PieData(
//       label: label ?? this.label,
//       count: count ?? this.count,
//       color: color ?? this.color,
//     );
//   }
// }
