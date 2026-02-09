import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/car/view/widgets/car_chats_problem_widget.dart';
import 'package:bsu_control/src/car/view/widgets/cars_table_view.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/cars_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/pagination_widget.dart';
import 'car_details_page.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final controller = GetIt.I.get<AppController>();
  late CarController carController;
  late ReactionDisposer rec;

  List<CarModel> cars = [];

  @override
  void initState() {
    super.initState();
    carController = CarController(app: controller);

    rec = autorun((_) {
      setState(() {
        if (controller.user.adminFull) {
          cars
            ..clear()
            ..addAll(List<CarModel>.from(controller.cars));
        } else {
          cars
            ..clear()
            ..addAll(controller.cars
                .where((e) => e.obmID == controller.user.obmID)
                .toList());
        }

        carController.setCars(cars);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackgraundPage(
        childLeft: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: controller.maxWidth * 0.45,
                    child: Column(
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 305,
                          child: CarsChart(
                            cars: cars,
                            carsTypes: controller.carsTypes,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: controller.maxWidth * 0.46,
                    child: Column(
                      spacing: 5,
                      children: [
                        StreamBuilder<List<CarStatusModel>>(
                            stream: carController.listenStatusGeral(),
                            builder: (context, snapshort) {
                              if (!snapshort.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                final status = snapshort.data ?? [];
                                return SizedBox(
                                    height: 305,
                                    width: double.infinity,
                                    child: CarChartProblems(status: status));
                              }
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Veículos registrados',
                    style: Constants.title,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Observer(builder: (_) {
                    return Text(
                      'Exibindo 1 a ${carController.limit} de ${cars.length} entradas',
                      style: Constants.subtitleHint,
                    );
                  }),
                  Observer(builder: (_) {
                    final cars = carController.carsSorts;
                    return CarsTableView(
                      values: cars,
                      obms: controller.obms,
                      onDetails: (id) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CarDetailsPage(
                                  carID: id,
                                )));
                      },
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Mostrar',
                        style: Constants.subtitleHint,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 40.0,
                        width: 65,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Observer(builder: (_) {
                          return DropdownButton<int>(
                              isExpanded: true,
                              value: carController.limit,
                              underline: Container(),
                              onChanged: carController.setLimit,
                              items: [10, 25, 50, 75, 100]
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            e.toString(),
                                            style: Constants.subtitle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ))
                                  .toList());
                        }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'entradas',
                        style: Constants.subtitleHint,
                      ),
                      const Spacer(),
                      Observer(builder: (context) {
                        return PaginationWidget(
                          limit: carController.limit,
                          page: carController.page,
                          length: cars.length,
                          onChange: carController.setPage,
                        );
                      }),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
