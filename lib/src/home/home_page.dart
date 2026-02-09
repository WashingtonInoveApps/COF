import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/src/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/home/controller/home_controller.dart';
import 'package:bsu_control/src/home/view/widgets/checklist_table_view.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/cars_chart_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/pagination_widget.dart';
import 'view/widgets/period_chart_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = GetIt.I.get<AppController>();
  late HomeController controller;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    controller = HomeController(app: app);

    controller.setDateStart(app.dateReferenceStart);
    controller.setDateFinish(app.dateReferenceFinish);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      controller.setDate(DateTime.now());
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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
                      width: app.maxWidth * 0.45,
                      child: Column(
                        spacing: 5,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      Expanded(
                                        child: Observer(builder: (_) {
                                          return Text(
                                            Core.formatDate(controller.date,
                                                largeDayHour: true),
                                            style: Constants.titleHint,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  IntrinsicHeight(
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Observer(builder: (context) {
                                            return cardInfor(
                                                label: 'Checklist realizados',
                                                icon: MdiIcons.checkAll,
                                                color: Colors.green.shade700,
                                                value:
                                                    app.checklistsToday.length);
                                          }),
                                        ),
                                        Expanded(
                                          child: Observer(builder: (context) {
                                            return cardInfor(
                                                label: 'Checklist pendentes',
                                                icon: MdiIcons.check,
                                                color: Colors.blue.shade700,
                                                value:
                                                    app.checklistTodayPendent);
                                          }),
                                        ),
                                        Expanded(
                                          child: Observer(builder: (context) {
                                            return cardInfor(
                                                label: 'Novas alterações',
                                                icon:
                                                    MdiIcons.informationOutline,
                                                color: Colors.red.shade700,
                                                value:
                                                    app.checklistTodayChanges);
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Observer(builder: (context) {
                                          return app.newRegister
                                              ? btCustom(
                                                  label: 'Novo Registro',
                                                  icon: Icons.add,
                                                  color: Colors.blue.shade800,
                                                  onTap: () {
                                                    app.setRouter(2);
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const ChecklistRegisterPage()));
                                                  })
                                              : btCustom(
                                                  label: 'Ver registro',
                                                  icon: Icons.search,
                                                  color: Colors
                                                      .deepPurple.shade800,
                                                  onTap: () async {
                                                    await Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChecklistDetailsPage(
                                                                    checklistID: app
                                                                        .checklistUser!
                                                                        .id!)));
                                                  });
                                        }),
                                        btCustom(
                                            label: 'Novo abastecimento',
                                            icon: MdiIcons.gasStation,
                                            color: Colors.orange.shade700,
                                            onTap: null),
                                        btCustom(
                                            label: 'Meus registros',
                                            icon: MdiIcons.viewList,
                                            color: Colors.green.shade700,
                                            onTap: () {}),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Observer(builder: (_) {
                            return CarsChart(
                              cars: app.cars,
                              carsTypes: app.carsTypes,
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: app.maxWidth * 0.46,
                      child: Column(
                        spacing: 5,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      const Icon(
                                        Icons.settings,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Configuração de exibição',
                                          style: Constants.titleHint,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate:
                                                  controller.dateReferenceStart,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 10)),
                                              lastDate: DateTime.now())
                                          .then(controller.setDateStart);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Data inicial',
                                            style: Constants.subtitleHint,
                                          ),
                                          Observer(builder: (_) {
                                            return Text(
                                              Core.formatDate(
                                                  controller.dateReferenceStart,
                                                  largeDay: true),
                                              style: Constants.title,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: controller
                                                  .dateReferenceFinish,
                                              firstDate: DateTime.now()
                                                  .subtract(
                                                      const Duration(days: 10)),
                                              lastDate: DateTime.now())
                                          .then(controller.setDateFinish);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Data final',
                                            style: Constants.subtitleHint,
                                          ),
                                          Observer(builder: (_) {
                                            return Text(
                                              Core.formatDate(
                                                  controller
                                                      .dateReferenceFinish,
                                                  largeDay: true),
                                              style: Constants.title,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        child: ElevatedButton.icon(
                                            onPressed: () {
                                              final date = DateTime.now();

                                              controller.setDateStart(date);
                                              controller.setDateFinish(date);

                                              app.setDateRangeChecklist(
                                                  dateStart: controller
                                                      .dateReferenceStart,
                                                  dateFinish: controller
                                                      .dateReferenceFinish);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey.shade400),
                                            icon: Icon(
                                              MdiIcons.delete,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Limpar',
                                              style: Constants.titleButton,
                                            )),
                                      ),
                                      SizedBox(
                                        height: 35,
                                        child: ElevatedButton.icon(
                                            onPressed: () {
                                              app.setDateRangeChecklist(
                                                  dateStart: controller
                                                      .dateReferenceStart,
                                                  dateFinish: controller
                                                      .dateReferenceFinish);
                                            },
                                            icon: Icon(
                                              MdiIcons.filter,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            label: Text(
                                              'Aplicar',
                                              style: Constants.titleButton,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Observer(builder: (context) {
                            return ChartPeriodWidget(
                              key: ValueKey(
                                  app.checklistsPeriod.length.toString() +
                                      app.dateReferenceStart.toString() +
                                      app.dateReferenceFinish.toString()),
                              dateStart: app.dateReferenceStart,
                              dateFinish: app.dateReferenceFinish,
                              checklists: app.checklistsPeriod,
                            );
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
              Text.rich(
                TextSpan(text: 'Registros ', children: [
                  TextSpan(
                      text:
                          '${Core.formatDate(app.dateReferenceStart)} - ${Core.formatDate(app.dateReferenceFinish)}',
                      style: Constants.subtitleHint)
                ]),
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                height: 450,
                child: Observer(builder: (context) {
                  if (app.loadingCheklist) {
                    return const LinearProgressIndicator();
                  } else if (app.checklistsPeriod.isEmpty) {
                    return Text(
                      'Ops ! Nenhum registro encontrado.',
                      style: Constants.subtitleHint,
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 5,
                      ),
                      child: Column(
                        spacing: 5,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exibindo 1 a ${app.limit} de ${app.checklistsPeriod.length} entradas',
                            style: Constants.subtitleHint,
                          ),
                          Expanded(
                            child: ChecklistTableView(
                              values: app.checklistPeriodSort,
                              obms: app.obms,
                              onContact: (contact) async {
                                final path = kIsWeb
                                    ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                                    : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                                await launchUrlString(path,
                                    mode: LaunchMode.externalApplication);
                              },
                              onDetails: (id) async {
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChecklistDetailsPage(
                                                checklistID: id)));
                              },
                            ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Observer(builder: (_) {
                                  return DropdownButton<int>(
                                      isExpanded: true,
                                      value: app.limit,
                                      underline: Container(),
                                      onChanged: app.setLimit,
                                      items: [10, 25, 50, 75, 100]
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    e.toString(),
                                                    style: Constants.subtitle,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                  limit: app.limit,
                                  page: app.page,
                                  length: app.checklistsPeriod.length,
                                  onChange: app.setPage,
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ));
  }
}

Widget cardInfor(
    {required String label,
    required IconData icon,
    required Color color,
    required int value}) {
  return IntrinsicHeight(
    child: Row(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: color),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              ...label
                  .split(' ')
                  .map((e) => Text(
                        e.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: Constants.subtitle.copyWith(color: Colors.grey),
                      ))
                  .toList(),
              Text(
                value.toString().padLeft(2, '0'),
                style: Constants.title.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget btCustom(
    {required String label,
    required IconData icon,
    required Color color,
    required Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (onTap == null) ? Colors.grey.shade300 : color),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 25,
            color: Colors.white,
          ),
          ...label
              .split(' ')
              .map((e) => Text(
                    e,
                    textAlign: TextAlign.center,
                    style: Constants.title.copyWith(color: Colors.white),
                  ))
              .toList()
        ],
      ),
    ),
  );
}
