import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/details_cars_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CarsChart extends StatefulWidget {
  final List<String> carsTypes;
  final List<CarModel> cars;
  final Function(List<DetailsCarsModel>)? onDetails;

  const CarsChart(
      {Key? key, required this.cars, required this.carsTypes, this.onDetails})
      : super(key: key);

  @override
  State<CarsChart> createState() => _CarsChartState();
}

class _CarsChartState extends State<CarsChart> {
  final scrollController = ScrollController();

  List<DetailsCarsModel> inforsCars = [];
  List<_ChartData> data = [];

  void processCharts() {
    int operating = 0;
    int reserve = 0;
    int lowered = 0;

    if (widget.cars.isNotEmpty) {
      for (final car in widget.cars) {
        if (car.state == StatusCar.operando) {
          operating++;
        } else if (car.state == StatusCar.reserva) {
          reserve++;
        } else {
          lowered++;
        }

        // if (!types.contains(car.type)) types.add(car.type);
      }

      inforsCars.clear();
      for (final type in widget.carsTypes) {
        final cars = widget.cars.where((e) => e.type == type).toList();

        int operatingType = 0;
        int reserveType = 0;
        int loweredType = 0;

        for (final car in cars) {
          if (car.state == StatusCar.operando) {
            operatingType++;
          } else if (car.state == StatusCar.reserva) {
            reserveType++;
          } else {
            loweredType++;
          }
        }

        if (cars.isNotEmpty) {
          inforsCars.add(DetailsCarsModel(
              label: type,
              color: Core.corEscuraAleatoria(),
              operating: operatingType,
              lowered: loweredType,
              reserve: reserveType,
              cars: cars));
        }
      }
    }

    data
      ..clear()
      ..addAll([
        _ChartData('Operando', operating, Colors.green.shade700),
        _ChartData('Reservas', reserve, Colors.orange.shade700),
        _ChartData('Baixadas', lowered, Colors.red.shade700)
      ]);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    processCharts();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: 0.5,
                    child: SizedBox(
                      height: 272,
                      child: SfCircularChart(
                        series: <CircularSeries>[
                          DoughnutSeries<_ChartData, String>(
                            dataSource:
                                data.where((e) => (e.value > 0)).toList(),
                            xValueMapper: (d, _) => d.label,
                            yValueMapper: (d, _) => d.value,
                            pointColorMapper: (d, _) => d.color,
                            startAngle: -90, // 🔥 COMEÇA EMBAIXO
                            endAngle: 90, // 🔥 TERMINA EM CIMA (180°)
                            innerRadius: '65%',
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                textStyle: Constants.title.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'DETALHES DA FROTA ( ${Core.formatDate(DateTime.now(), largeDay: true)} )',
                          style: Constants.subtitleHint,
                        ),
                      ),
                      (widget.onDetails == null)
                          ? Container()
                          : IconButton(
                              onPressed: () =>
                                  widget.onDetails?.call(inforsCars),
                              icon: const Icon(
                                Icons.info,
                                color: Colors.grey,
                                size: 25,
                              ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data
                            .map((e) => e.value)
                            .reduce((value, next) => value + next)
                            .toString(),
                        style: Constants.title.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Viaturas',
                        style: Constants.subtitle,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.map((state) {
                return Row(
                  spacing: 10,
                  children: [
                    Icon(
                      MdiIcons.circle,
                      color: state.color,
                      size: 20,
                    ),
                    Text(
                      state.label,
                      style: Constants.subtitle,
                    )
                  ],
                );
              }).toList(),
            ),
            const Divider(),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 10,
                controller: scrollController,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: inforsCars.map((infor) {
                        return Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                infor.label,
                                style: Constants.title,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                spacing: 5,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.green.shade700,
                                    size: 15,
                                  ),
                                  Text(
                                    infor.operating.toString(),
                                    style: Constants.title,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.orange.shade700,
                                    size: 15,
                                  ),
                                  Text(
                                    infor.reserve.toString(),
                                    style: Constants.title,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red.shade700,
                                    size: 15,
                                  ),
                                  Text(
                                    infor.lowered.toString(),
                                    style: Constants.title,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  String label;
  int value;
  Color color;

  _ChartData(this.label, this.value, this.color);
}
