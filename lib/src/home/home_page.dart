import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/src/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/home/controller/home_controller.dart';
import 'package:bsu_control/src/home/view/widgets/checklist_table_view.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/cars_chart_widget.dart';
import 'package:bsu_control/src/widgets/images_changes_view_widget.dart';
import 'package:bsu_control/src/widgets/limit_table_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
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
  final searchController = TextEditingController();

  late ReactionDisposer rec;
  late StreamSubscription subscription;

  late HomeController controller;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    controller = HomeController(app: app);

    controller.setDateRangeChecklist(
        dateStart: app.dateStartConfig, dateFinish: app.dateFinishConfig);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      controller.setDate(DateTime.now());
    });

    rec = autorun((_) {
      controller.setLoading(true);
      subscription = controller
          .listenChecklistPeriod(
              dateStart: controller.dateReferenceStart,
              dateFinish: controller.dateReferenceFinish)
          .listen((result) {
        controller.setChecklistPeriod(result);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    rec();
    subscription.cancel();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Stack(
          children: [
            BackgraundPage(
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
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              child:
                                                  Observer(builder: (context) {
                                                return cardInfor(
                                                    label:
                                                        'Checklist realizados',
                                                    icon: MdiIcons.checkAll,
                                                    color:
                                                        Colors.green.shade700,
                                                    value: app.checklistsToday
                                                        .length);
                                              }),
                                            ),
                                            Expanded(
                                              child:
                                                  Observer(builder: (context) {
                                                return cardInfor(
                                                    label:
                                                        'Checklist pendentes',
                                                    icon: MdiIcons.check,
                                                    color: Colors.blue.shade700,
                                                    value: app
                                                        .checklistTodayPendent);
                                              }),
                                            ),
                                            Expanded(
                                              child:
                                                  Observer(builder: (context) {
                                                return cardInfor(
                                                    label: 'Novas alterações',
                                                    icon: MdiIcons
                                                        .informationOutline,
                                                    color: Colors.red.shade700,
                                                    value: app
                                                        .checklistTodayChanges);
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
                                                      color:
                                                          Colors.blue.shade800,
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
                                                        await Navigator.of(
                                                                context)
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
                                return SizedBox(
                                  height: 245,
                                  child: CarsChart(
                                    cars: app.carsUsers,
                                    carsTypes: app.carsTypes,
                                    legends: false,
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: (app.modeMOBILE
                              ? double.infinity
                              : app.maxWidth * 0.46),
                          child: Column(
                            spacing: 5,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: controller
                                                      .dateReferenceStart,
                                                  firstDate: DateTime.now()
                                                      .subtract(const Duration(
                                                          days: 10)),
                                                  lastDate: DateTime.now())
                                              .then(app.setDateStartConfig);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
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
                                                      app.dateStartConfig,
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
                                                      .subtract(const Duration(
                                                          days: 10)),
                                                  lastDate: DateTime.now())
                                              .then(app.setDateFinishConfig);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
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
                                                      app.dateFinishConfig,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 35,
                                            child: ElevatedButton.icon(
                                                onPressed: () {
                                                  app.cleanExibitionConfig();

                                                  controller
                                                      .setDateRangeChecklist(
                                                          dateStart: app
                                                              .dateStartConfig,
                                                          dateFinish: app
                                                              .dateFinishConfig);
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
                                                  controller
                                                      .setDateRangeChecklist(
                                                          dateStart: app
                                                              .dateStartConfig,
                                                          dateFinish: app
                                                              .dateFinishConfig);
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
                                final list = List<CheckListModel>.from(
                                    controller.checklistsPeriod);
                                return SizedBox(
                                  height: 300,
                                  child: ChartPeriodWidget(
                                    dateStart: controller.dateReferenceStart,
                                    dateFinish: controller.dateReferenceFinish,
                                    checklists: list,
                                  ),
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
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      alignment: WrapAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Text.rich(
                          TextSpan(text: 'Registros ', children: [
                            TextSpan(
                                text:
                                    '${Core.formatDate(controller.dateReferenceStart)} - ${Core.formatDate(controller.dateReferenceFinish)}',
                                style: Constants.subtitleHint)
                          ]),
                          style: Constants.title.copyWith(fontSize: 18),
                        ),
                        Observer(builder: (_) {
                          return IgnorePointer(
                            ignoring: controller.checklistPeriodSort.isEmpty,
                            child: Container(
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
                  SizedBox(
                    width: double.infinity,
                    height: 450,
                    child: Observer(builder: (context) {
                      if (controller.loading) {
                        return const LinearProgressIndicator();
                      } else if (controller.checklistPeriodSort.isEmpty) {
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
                                'Exibindo 1 a ${controller.checklistPeriodSort.length} de ${controller.checklistsPeriod.length} entradas',
                                style: Constants.subtitleHint,
                              ),
                              Expanded(
                                child: ChecklistTableView(
                                  values: controller.checklistPeriodSort,
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
                                  onChanges: (changes) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            content: ImagesChangesViewWidget(
                                                changes: changes),
                                          );
                                        });
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  LimitTableWidget(
                                      limit: controller.limit,
                                      onChange: controller.setLimit),
                                  const Spacer(),
                                  Observer(builder: (context) {
                                    return PaginationWidget(
                                      limit: controller.limit,
                                      page: controller.page,
                                      length:
                                          controller.checklistsPeriod.length,
                                      onChange: controller.setPage,
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
            ),
            Observer(builder: (_) {
              return IgnorePointer(
                ignoring: !controller.loading,
                child: Container(
                  color:
                      controller.loading ? Colors.black54 : Colors.transparent,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        controller.loading ? Colors.white : Colors.transparent),
                  )),
                ),
              );
            })
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
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
