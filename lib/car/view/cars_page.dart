import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/car/view/widgets/car_chats_problem_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/widgets/cars_available_today.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../widgets/backgraund_page.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'car_details_page.dart';
import 'widgets/car_availability_chart.dart';
import 'widgets/car_chart_km_month_widget.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  late CarController controller;
  late ReactionDisposer rec;
  late ReactionDisposer recDate;
  late ReactionDisposer recChecklistDate;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    controller = CarController(config: config, user: app.user);
    controller.setDateKmByMonth(DateTime.now());

    rec = autorun((_) {
      controller.setCars(List<CarModel>.from(app.carsUsers));
    });

    recDate = autorun(
      (_) {
        subscription?.cancel();
        subscription = controller
            .listenStatusGeral(date: controller.referenceDateDashboard)
            .listen((value) {
          controller.setStatusGeral(value);
        });
      },
    );

    recChecklistDate = autorun(
      (_) {
        controller
            .getCheckListByMonth(date: controller.dateKmByMonth)
            .then(controller.setChecklistKMByMonth);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    rec();
    recDate();
    recChecklistDate();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackgraundPage(
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Veículos',
                    style: Constants.title.copyWith(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await showYearPicker(
                      context: context,
                      initialDate: controller.referenceDateDashboard,
                      firstDate: DateTime(2026),
                      lastDate: DateTime(
                        DateTime.now().year + 1,
                      ),
                    ).then((value) {
                      if (value != null) {
                        controller.setReferenceDateDashboard(
                          DateTime(
                            value,
                            1,
                            1,
                          ),
                        );
                      }
                    });
                  },
                  tooltip: 'Alterar ano',
                  icon: const Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        childLeft: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 230,
                          child: Observer(builder: (_) {
                            final cars = List<CarModel>.from(controller.cars);
                            final types = List<String>.from(app.carsTypes);

                            return CarsAvailabilityChart(
                              cars: cars,
                              checklists: app.checklistsOperationDay,
                            );
                          }),
                        ),
                        Observer(builder: (context) {
                          return Card(
                            child: Container(
                              height: 328,
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: CarChartKmByMonth(
                                referenceDate: controller.dateKmByMonth,
                                checklists: controller.checklistKMByMonth,
                                onChangeDate: controller.setDateKmByMonth,
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Observer(builder: (_) {
                      return Column(
                        spacing: 5,
                        children: [
                          Card(
                            child: Container(
                              height: 275,
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: CarChartAvailability(
                                reference: controller.referenceDateDashboard,
                                status: controller.statusGeral,
                              ),
                            ),
                          ),
                          Card(
                            child: Container(
                              height: 275,
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: CarChartProblems(
                                reference: controller.referenceDateDashboard,
                                status: controller.statusGeral,
                                cars: controller.cars,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
                    'Registrados',
                    style: Constants.title.copyWith(fontSize: 18),
                  ),
                  Observer(builder: (_) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: app.modeMOBILE ? double.infinity : 350,
                      alignment: Alignment.centerRight,
                      child: FieldText(
                        search: true,
                        controller: searchController,
                        hint: 'Ex.: Digite algo para pesquisar',
                        onChange: controller.onChangeFilter,
                        onClear: () {
                          searchController.clear();
                          controller.onChangeFilter('');
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            app.modeMOBILE
                ? const SizedBox(
                    height: 10,
                  )
                : const Divider(),
            const SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              final cars = List<CarModel>.from(controller.carsSorts);

              return cars.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exibindo ${controller.start} a ${controller.end} de ${controller.cars.length} entradas',
                          style: Constants.subtitleHint,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 250),
                          child: AppDataTable<CarModel>(
                            limit: controller.limit,
                            data: cars,
                            columnMode: ColumnWidthMode.auto,
                            columns: [
                              AppColumn(
                                width: 50,
                                name: 'details',
                                builder: (car) {
                                  return InkWell(
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(
                                                  100)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.search,
                                            size: 20, color: Colors.green),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CarDetailsPage(
                                                    controller: controller,
                                                    carID: car.id ?? '',
                                                  )));
                                    },
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'obm',
                                label: 'OBM',
                                width: 100,
                                sortable: true,
                                sortValue: (car) {
                                  final obm = app.obms
                                      .firstWhere((e) => e.id == car.obmID);

                                  return obm.prefix;
                                },
                                builder: (car) {
                                  final obm = app.obms
                                      .firstWhere((e) => e.id == car.obmID);
                                  return Text(
                                    obm.prefix,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'prefix',
                                label: 'Prefixo',
                                sortValue: (car) => car.prefix,
                                sortable: true,
                                builder: (car) => Text(
                                  car.prefix,
                                  style: Constants.title,
                                ),
                              ),
                              AppColumn(
                                width: 220,
                                name: 'cia',
                                label: 'Companhia',
                                sortValue: (car) => car.cia?.name ?? '',
                                builder: (car) {
                                  return Text(
                                    car.cia?.name.toUpperCase() ?? '',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'state',
                                label: 'Status',
                                sortValue: (car) => car.km.toString(),
                                builder: (car) {
                                  return Center(
                                    child: Container(
                                      width: 150,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: car.state.color,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        spacing: 5,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(car.state.icon,
                                              color: Colors.white),
                                          Expanded(
                                            child: Text(
                                              car.state.label,
                                              style: Constants.title.copyWith(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              AppColumn(
                                width: 100,
                                name: 'plate',
                                label: 'Placa',
                                sortValue: (car) => car.plate,
                                builder: (car) {
                                  return Text(
                                    car.plate,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'type',
                                label: 'Tipo',
                                sortValue: (car) => car.type,
                                builder: (car) {
                                  return Text(
                                    car.type,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'function',
                                label: 'Função',
                                sortValue: (car) => car.function.label,
                                builder: (car) {
                                  return Text(
                                    car.function.label,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'km',
                                label: 'KM',
                                sortValue: (car) => car.km.toString(),
                                builder: (car) {
                                  return Text(
                                    car.km.toString(),
                                    style: Constants.title,
                                  );
                                },
                              ),
                            ],
                            rowId: (car) {
                              return car.id ?? 'err';
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            direction: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Observer(builder: (_) {
                                  return LimitTableWidget(
                                    limit: controller.limit,
                                    onChange: controller.setLimit,
                                  );
                                }),
                              ),
                              SizedBox(
                                width: 220,
                                child: Observer(builder: (context) {
                                  return PaginationWidget(
                                    limit: controller.limit,
                                    page: controller.page,
                                    length: controller.lengthSortings,
                                    onChange: controller.setPage,
                                  );
                                }),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Text(
                      'Nenhum registro encontrado.',
                      style: Constants.titleHint,
                    );
            }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
