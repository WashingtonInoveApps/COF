import 'dart:async';
import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/car/view/car_service_details_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_service_model.dart';
import 'package:bsu_control/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/core.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';

class CarServicesPage extends StatefulWidget {
  const CarServicesPage({Key? key}) : super(key: key);

  @override
  State<CarServicesPage> createState() => _CarServicesPageState();
}

class _CarServicesPageState extends State<CarServicesPage> {
  late CarController controller;
  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    controller = CarController(
      config: config,
      user: app.user,
    );

    controller.setLoading(true);
    subscription =
        controller.listenCarServices(obmID: app.user.obmID).listen((value) {
      controller.setCarServices(value);
      controller.setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
            Text(
              'Serviços',
              style: Constants.title.copyWith(fontSize: 18),
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
                crossAxisAlignment: WrapCrossAlignment.end,
                alignment: WrapAlignment.spaceBetween,
                direction: Axis.horizontal,
                children: [
                  Text(
                    'Registros',
                    style: Constants.title.copyWith(fontSize: 18),
                  ),
                  Observer(builder: (_) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: app.modeMOBILE ? double.infinity : 400,
                      alignment: Alignment.centerRight,
                      child: IgnorePointer(
                        ignoring: controller.services.isEmpty,
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
              height: 5,
            ),
            Observer(builder: (_) {
              final services =
                  List<CarServiceModel>.from(controller.servicesSorts);
              return services.isEmpty
                  ? Text(
                      'Nenhum registro encontrado.',
                      style: Constants.titleHint,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exibindo ${controller.startServices} a ${controller.endServices} de ${controller.servicesSorts.length} entradas',
                          style: Constants.subtitleHint,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: AppDataTable<CarServiceModel>(
                            limit: controller.limit,
                            data: services,
                            columnMode: ColumnWidthMode.auto,
                            columns: [
                              AppColumn(
                                width: 50,
                                name: 'details',
                                builder: (service) {
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
                                                  CarServiceDetailsPage(
                                                    controller: controller,
                                                    serviceID: service.id!,
                                                  )));
                                    },
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'date',
                                label: 'Data',
                                builder: (service) {
                                  return Text(
                                    Core.formatDate(service.date),
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'obm',
                                label: 'OBM',
                                width: 120,
                                builder: (service) {
                                  return Text(
                                    service.car?.obm?.prefix ?? '-',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'cia',
                                label: 'Companhia',
                                builder: (service) {
                                  return Text(
                                    service.car?.cia?.name ?? '-',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'prefix',
                                label: 'Prefixo',
                                builder: (service) {
                                  return Text(
                                    service.car?.prefix ?? '-',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'problem',
                                label: 'Problema',
                                sortValue: (service) => service.problem.label,
                                builder: (service) => TagWidget(
                                  label: service.problem.label,
                                  color: service.problem.color,
                                  icon: service.problem.icon,
                                ),
                              ),
                              AppColumn(
                                name: 'local',
                                label: 'Local',
                                builder: (service) {
                                  return Text(
                                    service.local,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'expired',
                                label: 'Garantia',
                                builder: (service) {
                                  return Text(
                                    (service.expired == null)
                                        ? 'Sem garantia'
                                        : Core.formatDate(
                                            service.expired!,
                                          ),
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'responsable',
                                label: 'Responsável',
                                builder: (service) {
                                  return Core.boldFirstName(
                                      name: service.user.name,
                                      fullName: service.user.fullname,
                                      style: Constants.title,
                                      graduation: service.user.graduation,
                                      over: TextOverflow.ellipsis);
                                },
                              ),
                            ],
                            rowId: (material) {
                              return material.id ?? 'err';
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
                                child: LimitTableWidget(
                                  limit: controller.limit,
                                  onChange: controller.setLimit,
                                ),
                              ),
                              SizedBox(
                                width: 220,
                                child: PaginationWidget(
                                  limit: controller.limit,
                                  page: controller.page,
                                  length: controller.lengthServicesSortings,
                                  onChange: controller.setPage,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
            }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
