import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/src/home/controller/home_controller.dart';
import 'package:bsu_control/src/home/view/widgets/cars_chart_widget.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    Widget btCustom(
        {required String label,
        required IconData icon,
        required Color color,
        required Function()? onTap}) {
      return InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              const SizedBox(
                height: 5,
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

    Widget cardInfor(
        {required String label,
        required IconData icon,
        required Color color,
        required int value}) {
      return SizedBox(
        width: 140,
        child: Card(
          child: IntrinsicHeight(
            child: Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 24),
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
                                style: Constants.subtitle
                                    .copyWith(color: Colors.grey),
                              ))
                          .toList(),
                      const Spacer(),
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
          ),
        ),
      );
    }

    return PopScope(
        canPop: false,
        child: BackgraundPage(
          childLeft: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: app.maxWidth * 0.48,
                      child: Column(
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        btCustom(
                                            label: 'Registro',
                                            icon: Icons.add,
                                            color: Colors.blue.shade800,
                                            onTap: () {}),
                                        btCustom(
                                            label: 'Novo abastecimento',
                                            icon: MdiIcons.gasStation,
                                            color: Colors.orange.shade700,
                                            onTap: () {}),
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
                                            onPressed: () {},
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
                                            onPressed: () {},
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
                        ],
                      ),
                    ),
                    SizedBox(
                      width: app.maxWidth * 0.48,
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardInfor(
                                    label: 'Checklist realizados',
                                    icon: MdiIcons.checkAll,
                                    color: Core.corEscuraAleatoria(),
                                    value: 10),
                                cardInfor(
                                    label: 'Checklist pendentes',
                                    icon: MdiIcons.check,
                                    color: Core.corEscuraAleatoria(),
                                    value: 5),
                                cardInfor(
                                    label: 'Novas alterações',
                                    icon: MdiIcons.informationOutline,
                                    color: Core.corEscuraAleatoria(),
                                    value: 10),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Observer(builder: (_) {
                            return CarsChart(
                              cars: app.cars,
                            );
                          })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
