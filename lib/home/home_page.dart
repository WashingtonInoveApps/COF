import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/checklist/view/my_checklist_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/home/controller/home_controller.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:universal_html/html.dart' as html;
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/backgraund_page.dart';
import '../widgets/card_infor_widget.dart';
import '../widgets/cars_chart_widget.dart';
import '../widgets/config_view_widget.dart';
import '../widgets/limit_table_widget.dart';
import '../widgets/pagination_widget.dart';
import '../widgets/table_widget.dart';
import '../widgets/tag_widget.dart';
import '../widgets/textfield_widget.dart';
import 'view/widgets/period_chart_widget.dart';

const versionCodeSystem = 10;

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
    controller = HomeController(config: config);

    controller.setDateRange(
        dateStart: app.dateStartConfig, dateFinish: app.dateFinishConfig);

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      controller.setDate(DateTime.now());
    });

    rec = autorun((_) {
      controller.setLoading(true);
      subscription = controller
          .listenServices(
              dateStart: controller.dateReferenceStart,
              dateFinish: controller.dateReferenceFinish)
          .listen((result) {
        controller.setServicesPeriod(result);
        controller.setLoading(false);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec();

    timer.cancel();
    subscription.cancel();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final expires = Core.verifyExpiresChecklist();
    final refresh = (app.version > versionCodeSystem);

    return PopScope(
        canPop: false,
        child: Stack(
          children: [
            BackgraundPage(
              menu: !refresh,
              childLeft: refresh
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Center(
                        child: kIsWeb
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ops ! Sua plataforma está desatualizada. Recarregue a página para atualizar sua plataforma.',
                                    style: Constants.title,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          html.window.location.reload();
                                        },
                                        child: Text(
                                          "Recarregar página",
                                          style: Constants.titleButton,
                                        )),
                                  )
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Ops ! Seu aplicativo está desatualizado. Atualize para uma versão mais recente na loja de aplicativos.',
                                    style: Constants.title,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          // await launchUrlString(
                                          //     'https://play.google.com/store/apps/details?id=br.com.inove.monkey_catalog&pli=1',
                                          //     mode: LaunchMode
                                          //         .externalApplication);
                                        },
                                        child: Text(
                                          "Atualizar aplicativo",
                                          style: Constants.titleButton,
                                        )),
                                  )
                                ],
                              ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            direction: Axis.horizontal,
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
                                      child: Container(
                                        width: double.infinity,
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
                                                      Core.formatDate(
                                                          controller.date,
                                                          largeDayHour: true),
                                                      style:
                                                          Constants.titleHint,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Observer(
                                                        builder: (context) {
                                                      return CardInfoWidget(
                                                          label:
                                                              'Checklist realizados',
                                                          icon:
                                                              MdiIcons.checkAll,
                                                          color: Colors
                                                              .green.shade700,
                                                          value: app
                                                              .checklistsToday
                                                              .length
                                                              .toDouble());
                                                    }),
                                                  ),
                                                  Expanded(
                                                    child: Observer(
                                                        builder: (context) {
                                                      return CardInfoWidget(
                                                          label:
                                                              'Checklist pendentes',
                                                          icon: MdiIcons.check,
                                                          color: Colors
                                                              .blue.shade700,
                                                          value: app
                                                              .checklistTodayPendent
                                                              .toDouble());
                                                    }),
                                                  ),
                                                  Expanded(
                                                    child: Observer(
                                                        builder: (context) {
                                                      return CardInfoWidget(
                                                          label:
                                                              'Novas alterações',
                                                          icon: MdiIcons
                                                              .informationOutline,
                                                          color: Colors
                                                              .red.shade700,
                                                          value: app
                                                              .checklistTodayChanges
                                                              .toDouble());
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
                                                  Expanded(
                                                    child: Observer(
                                                        builder: (context) {
                                                      return app.newRegister
                                                          ? btCustom(
                                                              label:
                                                                  'Novo Serviço',
                                                              icon: Icons.add,
                                                              color: Colors.blue
                                                                  .shade800,
                                                              onTap: () {
                                                                // if (expires) {
                                                                //   showDialog(
                                                                //       context:
                                                                //           context,
                                                                //       builder: (context) => AlertMessage(
                                                                //           title:
                                                                //               'Atenção',
                                                                //           message:
                                                                //               'Ops ! Horário para realizar um novo registro expirado, espere um novo período.',
                                                                //           onPressedOK: () =>
                                                                //               Navigator.of(context).pop()));
                                                                // } else {
                                                                app.setRouter(
                                                                    2);
                                                                Navigator.of(
                                                                        context)
                                                                    .pushReplacement(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                const ChecklistRegisterPage()));
                                                                // }
                                                              })
                                                          : btCustom(
                                                              label:
                                                                  'Ver registro',
                                                              icon:
                                                                  Icons.search,
                                                              color: Colors
                                                                  .deepPurple
                                                                  .shade800,
                                                              onTap: () async {
                                                                await Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                ChecklistDetailsPage(checklist: app.checklistUser!)));
                                                              });
                                                    }),
                                                  ),
                                                  Expanded(
                                                    child: btCustom(
                                                        label:
                                                            'Novo abastecimento',
                                                        icon:
                                                            MdiIcons.gasStation,
                                                        color: Colors
                                                            .orange.shade700,
                                                        onTap: null),
                                                  ),
                                                  Expanded(
                                                    child: btCustom(
                                                        label: 'Meus registros',
                                                        icon: MdiIcons.viewList,
                                                        color: Colors
                                                            .green.shade700,
                                                        onTap: () {
                                                          app.setRouter(1);
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const MyChecklistPage()));
                                                        }),
                                                  ),
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
                                        width: double.infinity,
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
                                    Observer(builder: (_) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: ConfigViewWidget(
                                          dateStart: app.dateStartConfig,
                                          dateFinish: app.dateFinishConfig,
                                          onDateStart: app.setDateStartConfig,
                                          onDateFinish: app.setDateFinishConfig,
                                          onReset: () {
                                            app.cleanExibitionConfig();

                                            controller.setDateRange(
                                                dateStart: app.dateStartConfig,
                                                dateFinish:
                                                    app.dateFinishConfig);
                                          },
                                          onChange: () {
                                            controller.setDateRange(
                                                dateStart: app.dateStartConfig,
                                                dateFinish:
                                                    app.dateFinishConfig);
                                          },
                                        ),
                                      );
                                    }),
                                    Observer(builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: ChartChangesPeriodWidget(
                                          dateStart:
                                              controller.dateReferenceStart,
                                          dateFinish:
                                              controller.dateReferenceFinish,
                                          services: List<ServiceModel>.from(
                                              controller.servicesPeriod),
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
                              Observer(builder: (_) {
                                return Text.rich(
                                  TextSpan(text: 'Registros ', children: [
                                    TextSpan(
                                        text:
                                            '${Core.formatDate(controller.dateReferenceStart)} - ${Core.formatDate(controller.dateReferenceFinish)}',
                                        style: Constants.subtitleHint)
                                  ]),
                                  style: Constants.title.copyWith(fontSize: 18),
                                );
                              }),
                              Observer(builder: (_) {
                                return IgnorePointer(
                                  ignoring:
                                      controller.servicesPeriodSort.isEmpty,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width:
                                        app.modeMOBILE ? double.infinity : 350,
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
                              return const Center(
                                  child: LinearProgressIndicator());
                            } else if (controller.servicesPeriodSort.isEmpty) {
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
                                      'Exibindo 1 a ${controller.servicesPeriodSort.length} de ${controller.servicesPeriod.length} entradas',
                                      style: Constants.subtitleHint,
                                    ),
                                    Expanded(
                                      child: AppDataTable<ServiceModel>(
                                        data: List<ServiceModel>.from(
                                            controller.servicesPeriodSort),
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
                                                          BorderRadiusGeometry
                                                              .circular(100)),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(5.0),
                                                    child: Icon(Icons.search,
                                                        size: 20,
                                                        color: Colors.green),
                                                  ),
                                                ),
                                                onTap: () {
                                                  //     await Navigator.of(context).push(
                                                  //         MaterialPageRoute(
                                                  //             builder: (context) =>
                                                  //                 ChecklistDetailsPage(
                                                  //                     checklist:
                                                  //                         checklist)));
                                                },
                                              );
                                            },
                                          ),
                                          AppColumn(
                                            width: 120,
                                            name: 'date',
                                            label: 'Data',
                                            sortValue: (service) =>
                                                service.date,
                                            builder: (service) => Text(
                                              Core.formatDate(service.date),
                                              style: Constants.title,
                                            ),
                                          ),
                                          AppColumn(
                                            width: 100,
                                            name: 'obm',
                                            label: 'OBM',
                                            sortable: true,
                                            alignment: Alignment.center,
                                            sortValue: (service) =>
                                                service.obm.prefix,
                                            builder: (service) => Text(
                                                service.obm.prefix,
                                                style: Constants.title),
                                          ),
                                          AppColumn(
                                            name: 'team',
                                            label: 'Guarnição',
                                            sortable: true,
                                            alignment: Alignment.centerLeft,
                                            sortValue: (service) =>
                                                service.team ?? '-',
                                            builder: (service) => Text(
                                              service.team ?? '-',
                                              style: Constants.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          AppColumn(
                                            name: 'responsable',
                                            label: 'Responsável',
                                            sortable: true,
                                            alignment: Alignment.center,
                                            sortValue: (service) =>
                                                '${service.responsable.graduation} ${service.responsable.name}',
                                            builder: (service) => Text(
                                              '${service.responsable.graduation} ${service.responsable.name}',
                                              style: Constants.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          AppColumn(
                                            width: 120,
                                            name: 'changesCar',
                                            label: 'Alt. Viaturas',
                                            headColor: Colors.red,
                                            sortable: true,
                                            alignment: Alignment.center,
                                            sortValue: (service) =>
                                                service.changesCar.toString(),
                                            builder: (service) => Text(
                                                service.changesCar
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: Constants.title),
                                          ),
                                          AppColumn(
                                            width: 120,
                                            headColor: Colors.orange,
                                            name: 'changesMaterials',
                                            label: 'Alt. Materiais',
                                            sortable: true,
                                            alignment: Alignment.center,
                                            sortValue: (service) => service
                                                .changesMaterials
                                                .toString(),
                                            builder: (service) => Text(
                                                service.changesMaterials
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: Constants.title),
                                          ),
                                          AppColumn(
                                            name: 'state',
                                            label: 'Status',
                                            sortable: true,
                                            alignment: Alignment.center,
                                            sortValue: (service) =>
                                                service.state.label,
                                            builder: (service) {
                                              final state = service.state;

                                              return TagWidget(
                                                icon: state.icon,
                                                label: state.label,
                                                color: state.color,
                                              );
                                            },
                                          ),
                                          AppColumn(
                                            name: 'contact',
                                            label: 'Contato',
                                            sortValue: (service) =>
                                                service.contact,
                                            builder: (service) {
                                              return InkWell(
                                                child: Card(
                                                  margin: EdgeInsets.zero,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      spacing: 5,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(MdiIcons.whatsapp,
                                                            color:
                                                                Colors.green),
                                                        Expanded(
                                                          child: Text(
                                                            service.contact,
                                                            style: Constants
                                                                .subtitle,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  final contact = service
                                                      .contact
                                                      .replaceAll(' ', '')
                                                      .replaceAll('(', '')
                                                      .replaceAll(')', '')
                                                      .replaceAll('-', '');

                                                  final path = kIsWeb
                                                      ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                                                      : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                                                  await launchUrlString(path,
                                                      mode: LaunchMode
                                                          .externalApplication);
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                        rowId: (service) {
                                          return service.id ?? 'err';
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        direction: Axis.horizontal,
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: LimitTableWidget(
                                              limit: controller.limit,
                                              onChange: controller.setLimit,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 250,
                                            child: Observer(builder: (context) {
                                              return PaginationWidget(
                                                limit: controller.limit,
                                                page: controller.page,
                                                length: controller
                                                    .servicesPeriodSort.length,
                                                onChange: controller.setPage,
                                              );
                                            }),
                                          ),
                                        ],
                                      ),
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
                    overflow: TextOverflow.ellipsis,
                  ))
              .toList()
        ],
      ),
    ),
  );
}
