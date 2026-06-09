import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/car/view/widgets/car_chats_problem_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/enum.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/cars_chart_widget.dart';
import '../../widgets/images_changes_view_widget.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'car_details_page.dart';
import 'widgets/car_chart_km_month_widget.dart';
import 'widgets/chart_cars_tendencies_widget.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  late CarController carController;
  late ReactionDisposer rec;

  @override
  void initState() {
    super.initState();
    carController = CarController(config: config, user: app.user);
    carController.setDateKmByMonth(DateTime.now());

    rec = autorun((_) {
      carController.setCars(List<CarModel>.from(app.carsUsers));
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
                    width: (app.modeMOBILE
                        ? double.infinity
                        : app.maxWidth * 0.45),
                    child: Column(
                      spacing: 5,
                      children: [
                        SizedBox(
                          height: 230,
                          child: Observer(builder: (_) {
                            final cars =
                                List<CarModel>.from(carController.cars);
                            final types = List<String>.from(app.carsTypes);

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
                              child: FutureBuilder<List<ChecklistModel>>(
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
                    width: (app.modeMOBILE
                        ? double.infinity
                        : app.maxWidth * 0.45),
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
                      width: app.modeMOBILE ? double.infinity : 350,
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
            app.modeMOBILE ? Container() : const Divider(),
            const SizedBox(
              height: 10,
            ),
            Observer(builder: (_) {
              return Text(
                'Exibindo ${carController.start} a ${carController.end} de ${carController.cars.length} entradas',
                style: Constants.subtitleHint,
              );
            }),
            const SizedBox(
              height: 5,
            ),
            Observer(builder: (_) {
              final cars = List<CarModel>.from(carController.carsSorts);

              return Container(
                width: double.infinity,
                height: Core.calculateTableHeight(cars.length),
                constraints: const BoxConstraints(minHeight: 250),
                child: AppDataTable<CarModel>(
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
                                    BorderRadiusGeometry.circular(100)),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(Icons.search,
                                  size: 20, color: Colors.green),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CarDetailsPage(
                                      carID: car.id ?? '',
                                    )));
                          },
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
                        style: Constants.subtitle,
                      ),
                    ),
                    AppColumn(
                      name: 'obm',
                      label: 'OBM',
                      width: 100,
                      sortable: true,
                      sortValue: (car) {
                        final obm =
                            app.obms.firstWhere((e) => e.id == car.obmID);

                        return obm.prefix;
                      },
                      builder: (car) {
                        final obm =
                            app.obms.firstWhere((e) => e.id == car.obmID);
                        return Text(
                          obm.prefix,
                          style: Constants.subtitle,
                        );
                      },
                    ),
                    AppColumn(
                      width: 220,
                      name: 'cia',
                      label: 'Companhia',
                      sortValue: (car) => car.cia,
                      builder: (car) {
                        return Text(
                          car.cia.toUpperCase(),
                          style: Constants.subtitle,
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
                          style: Constants.subtitle,
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
                          style: Constants.subtitle,
                        );
                      },
                    ),
                    AppColumn(
                      name: 'function',
                      label: 'Função',
                      sortValue: (car) => car.function,
                      builder: (car) {
                        return Text(
                          car.function,
                          style: Constants.subtitle,
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
                          style: Constants.subtitle,
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
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(car.state.icon, color: Colors.white),
                                Expanded(
                                  child: Text(
                                    car.state.label,
                                    style: Constants.subtitle
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    AppColumn(
                      name: 'changes',
                      label: 'Alterações',
                      builder: (car) {
                        return Row(
                          spacing: 5,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  car.changes.length.toString().padLeft(2, '0'),
                                  style: Constants.subtitle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: InkWell(
                                  onTap: (car.changes.isNotEmpty)
                                      ? () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  content:
                                                      ImagesChangesViewWidget(
                                                          changes: car.changes),
                                                );
                                              });
                                        }
                                      : null,
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(100)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.list_alt_rounded,
                                        size: 20,
                                        color: Constants.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                  rowId: (car) {
                    return car.id ?? 'err';
                  },
                ),
              );
            }),
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
                        limit: carController.limit,
                        onChange: carController.setLimit,
                      );
                    }),
                  ),
                  SizedBox(
                    width: 220,
                    child: Observer(builder: (context) {
                      return PaginationWidget(
                        limit: carController.limit,
                        page: carController.page,
                        length: carController.cars.length,
                        onChange: carController.setPage,
                      );
                    }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
