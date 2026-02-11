import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/car/view/widgets/car_chats_problem_widget.dart';
import 'package:bsu_control/src/car/view/widgets/cars_table_view.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/cars_chart_widget.dart';
import 'package:bsu_control/src/widgets/images_changes_view_widget.dart';
import 'package:bsu_control/src/widgets/limit_table_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/pagination_widget.dart';
import 'car_details_page.dart';
import 'widgets/car_chart_km_month_widget.dart';
import 'widgets/chart_cars_tendencies_widget.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final controller = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  late CarController carController;
  late ReactionDisposer rec;

  @override
  void initState() {
    super.initState();
    carController = CarController(app: controller);
    carController.setDateKmByMonth(DateTime.now());

    rec = autorun((_) {
      carController.setCars(List<CarModel>.from(controller.carsUsers));
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    rec();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackgraundPage(
        childLeft: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: (controller.modeMOBILE
                        ? double.infinity
                        : controller.maxWidth * 0.45),
                    child: Column(
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 230,
                          child: Observer(builder: (_) {
                            final cars =
                                List<CarModel>.from(carController.cars);
                            final types =
                                List<String>.from(controller.carsTypes);

                            return CarsChart(
                              cars: cars,
                              carsTypes: types,
                              legends: false,
                            );
                          }),
                        ),
                        Observer(builder: (context) {
                          return Card(
                            child: Container(
                              height: 328,
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: FutureBuilder<List<CheckListModel>>(
                                  future: carController.getCheckListByMonth(
                                      date: carController.dateKmByMonth),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      final checklists = snapshot.data ?? [];

                                      return CarChartKmByMonth(
                                        referenceDate:
                                            carController.dateKmByMonth,
                                        checklists: checklists,
                                        onChangeDate:
                                            carController.setDateKmByMonth,
                                      );
                                    }
                                  }),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (controller.modeMOBILE
                        ? double.infinity
                        : controller.maxWidth * 0.45),
                    child: Column(
                      spacing: 5,
                      children: [
                        Card(
                          child: Container(
                            height: 290,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Observer(builder: (_) {
                              return StreamBuilder<List<CarStatusModel>>(
                                  stream: carController.listenStatusGeral(
                                      date: carController
                                          .referenceYearTendencies),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      final status = snapshot.data ?? [];
                                      return CarChartTendencies(
                                        reference: carController
                                            .referenceYearTendencies,
                                        status: status,
                                        onChangeDate: carController
                                            .setReferenceYearTendencies,
                                      );
                                    }
                                  });
                            }),
                          ),
                        ),
                        Card(
                          child: Container(
                            height: 260,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            child: Observer(builder: (_) {
                              return StreamBuilder<List<CarStatusModel>>(
                                  stream: carController.listenStatusGeral(
                                      date: carController.referenceYearProblem),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      final status = snapshot.data ?? [];
                                      return CarChartProblems(
                                        reference:
                                            carController.referenceYearProblem,
                                        status: status,
                                        onChangeDate: carController
                                            .setReferenceYearProblem,
                                      );
                                    }
                                  });
                            }),
                          ),
                        ),
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
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Text(
                    'Veículos registrados',
                    style: Constants.title,
                  ),
                  Observer(builder: (_) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: controller.modeMOBILE ? double.infinity : 350,
                      alignment: Alignment.centerRight,
                      child: FieldText(
                        search: true,
                        controller: searchController,
                        hint: 'Ex.: Digite algo para pesquisar',
                        onChange: carController.onChangeFilter,
                        onClear: () {
                          searchController.clear();
                          carController.onChangeFilter('');
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            controller.modeMOBILE ? Container() : const Divider(),
            const SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              return Text(
                'Exibindo 1 a ${carController.carsSorts.length} de ${carController.cars.length} entradas',
                style: Constants.subtitleHint,
              );
            }),
            const SizedBox(
              height: 5,
            ),
            Observer(builder: (_) {
              final cars = List<CarModel>.from(carController.carsSorts);
              return CarsTableView(
                values: cars,
                obms: controller.obms,
                onChanges: (changes) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(10),
                          content: ImagesChangesViewWidget(changes: changes),
                        );
                      });
                },
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
                Observer(builder: (_) {
                  return LimitTableWidget(
                      limit: carController.limit,
                      onChange: carController.setLimit);
                }),
                const Spacer(),
                Observer(builder: (context) {
                  return PaginationWidget(
                    limit: carController.limit,
                    page: carController.page,
                    length: carController.cars.length,
                    onChange: carController.setPage,
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
