import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/src/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/src/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/checklist_table_view.dart';
import 'package:bsu_control/src/widgets/images_changes_view_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';

class MyChecklistPage extends StatefulWidget {
  const MyChecklistPage({Key? key}) : super(key: key);

  @override
  State createState() => _MyChecklistPageState();
}

class _MyChecklistPageState extends State<MyChecklistPage> {
  late CheckListController controller;

  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = CheckListController(init: null, app: app);
  }

  @override
  void dispose() {
    super.dispose();
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
                    crossAxisAlignment: WrapCrossAlignment.end,
                    alignment: WrapAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        'Meus Registros ',
                        style: Constants.title.copyWith(fontSize: 18),
                      ),
                      Observer(builder: (_) {
                        return IgnorePointer(
                          ignoring: controller.myChecklistUser.isEmpty,
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
                SizedBox(
                  width: double.infinity,
                  height: 450,
                  child: StreamBuilder<List<CheckListModel>>(
                      stream:
                          controller.streamChecklistUser(userID: app.user.id!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: LinearProgressIndicator());
                        } else {
                          final cheklists = snapshot.data ?? [];
                          controller.setMyChecklistUser(cheklists);

                          if (cheklists.isEmpty) {
                            return Text(
                              'Ops ! Nenhum registro encontrado.',
                              style: Constants.subtitleHint,
                            );
                          } else {
                            return Observer(builder: (_) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Exibindo 1 a ${controller.myChecklistUserSort.length} de ${controller.myChecklistUser.length} entradas',
                                      style: Constants.subtitleHint,
                                    ),
                                    Expanded(
                                      child: ChecklistTableView(
                                        values: controller.myChecklistUserSort,
                                        obms: app.obms,
                                        onContact: (contact) async {
                                          final path = kIsWeb
                                              ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                                              : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                                          await launchUrlString(path,
                                              mode: LaunchMode
                                                  .externalApplication);
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
                                                  content:
                                                      ImagesChangesViewWidget(
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
                                            length: controller
                                                .myChecklistUser.length,
                                            onChange: controller.setPage,
                                          );
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                          }
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
