import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/checklist/view/widget/chart_user_state_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/backgraund_page.dart';
import '../../widgets/checklist_table_view.dart';
import '../../widgets/config_view_widget.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'checklist_details_page.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({Key? key}) : super(key: key);

  @override
  State createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late CheckListController controller;

  late ReactionDisposer rec;
  StreamSubscription? subscription;

  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = CheckListController(
      config: config,
      checklistTodays: app.checklistsOperationDay,
    );

    controller.setDateRangeChecklist(
        dateStart: controller.dateStartConfig,
        dateFinish: controller.dateFinishConfig);

    rec = autorun((_) {
      streamCheklist(
        start: controller.dateReferenceStart,
        end: controller.dateReferenceFinish,
      );
    });
  }

  Future<void> streamCheklist({
    required DateTime start,
    required DateTime end,
  }) async {
    controller.setLoading(true);
    await subscription?.cancel();

    subscription = controller
        .streamChecklistPeriod(
      referenceDateStart: start,
      referenceDateFinish: end,
    )
        .listen(
      (result) {
        controller.setChecklists(result);
        controller.setLoading(false);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    subscription?.cancel();
    rec();
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
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Column(
                          spacing: 5,
                          children: [
                            Observer(builder: (_) {
                              return SizedBox(
                                width: double.infinity,
                                child: ConfigViewWidget(
                                  dateStart: controller.dateStartConfig,
                                  dateFinish: controller.dateFinishConfig,
                                  onDateStart: controller.setDateStartConfig,
                                  onDateFinish: controller.setDateFinishConfig,
                                  onReset: () {
                                    controller.cleanExibitionConfig();

                                    controller.setDateRangeChecklist(
                                        dateStart: controller.dateStartConfig,
                                        dateFinish:
                                            controller.dateFinishConfig);
                                  },
                                  onChange: () {
                                    controller.setDateRangeChecklist(
                                        dateStart: controller.dateStartConfig,
                                        dateFinish:
                                            controller.dateFinishConfig);
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 450),
                        child: Column(
                          spacing: 5,
                          children: [
                            Card(
                              child: Container(
                                height: 200,
                                padding: const EdgeInsets.all(10),
                                child: Observer(builder: (_) {
                                  final checklists = List<ChecklistModel>.from(
                                    controller.checklists,
                                  );

                                  return UserStateChart(checklists: checklists);
                                }),
                              ),
                            )
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
                          ignoring: controller.checklists.isEmpty,
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
                app.modeMOBILE
                    ? const SizedBox(
                        height: 10,
                      )
                    : const Divider(),
                SizedBox(
                  width: double.infinity,
                  height: 450,
                  child: Observer(builder: (context) {
                    if (controller.loading) {
                      return const Center(child: LinearProgressIndicator());
                    } else if (controller.checklistsSort.isEmpty) {
                      return Text(
                        'Nenhum registro encontrado.',
                        style: Constants.titleHint,
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
                              'Exibindo ${controller.start} a ${controller.end} de ${controller.checklists.length} entradas',
                              style: Constants.subtitleHint,
                            ),
                            Expanded(
                              child: ChecklistTableWidget(
                                list: List<ChecklistModel>.from(
                                    controller.checklistsSort),
                                limit: controller.limit,
                                onDetails: (value) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ChecklistDetailsPage(
                                              checklist: value)));
                                },
                              ),
                            ),
                            Row(
                              children: [
                                LimitTableWidget(
                                  limit: controller.limit,
                                  onChange: controller.setLimit,
                                ),
                                const Spacer(),
                                Observer(builder: (context) {
                                  return PaginationWidget(
                                    limit: controller.limit,
                                    page: controller.page,
                                    length: controller.lengthSortings,
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
                color: controller.loading ? Colors.black54 : Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      controller.loading ? Colors.white : Colors.transparent),
                )),
              ),
            );
          }),
        ],
      ),
    );
  }
}
