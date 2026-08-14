// import 'package:bsu_control/core/constants.dart';
// import 'package:bsu_control/core/core.dart';
// import 'package:bsu_control/model/check_list_model.dart';
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ChartChangesPeriodWidget extends StatelessWidget {
//   final DateTime date;
//   final List<ChecklistModel> checklists;

//   const ChartChangesPeriodWidget({
//     Key? key,
//     required this.checklists,
//     required this.date,
//   }) : super(key: key);

//   List<ServiceChangesData> buildChartData(List<ChecklistModel> list) {
//     Map<String, int> servicesByDay = {};
//     Map<String, int> changesByDayCars = {};
//     Map<String, int> changesByDayMaterials = {};

//     for (var c in list) {
//       final date = (c.date);
//       final key =
//           "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}";

//       servicesByDay[key] = (servicesByDay[key] ?? 0) + 1;
//       changesByDayCars[key] = (changesByDayCars[key] ?? 0) + c.changes.length;
//       changesByDayMaterials[key] =
//           (changesByDayMaterials[key] ?? 0) + c.changes.length;
//     }

//     return servicesByDay.keys.map((day) {
//       final checklists = servicesByDay[day] ?? 0;
//       final changesCar = changesByDayCars[day] ?? 0;
//       final changesMaterials = changesByDayMaterials[day] ?? 0;

//       return ServiceChangesData(
//         day: day,
//         checklists: checklists,
//         changesCar: changesCar,
//         changesMaterials: changesMaterials,
//         avgCar: checklists == 0 ? 0 : changesCar / checklists,
//         avgMaterials: checklists == 0 ? 0 : changesMaterials / checklists,
//       );
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final list = List<ChecklistModel>.from(checklists);
//     list.sort((a, b) => a.date.compareTo(b.date));

//     final data = buildChartData(list);
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'ALTERAÇÕES (${Core.formatDate(date)})',
//               style: Constants.subtitleHint,
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Expanded(
//               child: SfCartesianChart(
//                 legend: const Legend(
//                     isVisible: true, position: LegendPosition.bottom),
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 primaryXAxis: const CategoryAxis(),
//                 primaryYAxis: NumericAxis(
//                     interval: 1,
//                     decimalPlaces: 0,
//                     title: AxisTitle(
//                         text: 'Quantidade', textStyle: Constants.subtitle)),
//                 series: <CartesianSeries>[
//                   // /// ALTERAÇÕES
//                   // ColumnSeries<ServiceChangesData, String>(
//                   //   name: 'Viatura',
//                   //   dataSource: data,
//                   //   xValueMapper: (d, _) => d.day,
//                   //   yValueMapper: (d, _) => d.changesCar,
//                   //   width: 0.1,
//                   // ),

//                   // /// ALTERAÇÕES
//                   // ColumnSeries<ServiceChangesData, String>(
//                   //   name: 'Materiais',
//                   //   dataSource: data,
//                   //   xValueMapper: (d, _) => d.day,
//                   //   yValueMapper: (d, _) => d.changesMaterials,
//                   //   width: 0.1,
//                   // ),

//                   LineSeries<ServiceChangesData, String>(
//                     name: 'Viaturas',
//                     dataSource: data,
//                     xValueMapper: (d, _) => d.day,
//                     yValueMapper: (d, _) => d.avgCar,
//                     markerSettings: const MarkerSettings(
//                       isVisible: true,
//                     ),
//                     color: Colors.red,
//                     width: 3,
//                   ),

//                   LineSeries<ServiceChangesData, String>(
//                     name: 'Materiais',
//                     dataSource: data,
//                     color: Colors.orange,
//                     xValueMapper: (d, _) => d.day,
//                     yValueMapper: (d, _) => d.avgMaterials,
//                     markerSettings: const MarkerSettings(
//                       isVisible: true,
//                     ),
//                     width: 3,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ServiceChangesData {
//   final String day;
//   final int checklists;
//   final int changesCar;
//   final int changesMaterials;
//   final double avgCar;
//   final double avgMaterials;

//   ServiceChangesData({
//     required this.day,
//     required this.checklists,
//     required this.changesCar,
//     required this.changesMaterials,
//     required this.avgCar,
//     required this.avgMaterials,
//   });
// }
