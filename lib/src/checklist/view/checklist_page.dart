import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/check_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import 'checklist_register_page.dart';

class ChecklistPage extends StatefulWidget {
  final bool home;
  const ChecklistPage({Key? key, this.home = false}) : super(key: key);

  @override
  State createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final controller = GetIt.I.get<AppController>();

  late ReactionDisposer rec;

  @override
  void initState() {
    super.initState();
    controller.setCheckListVeicular(true);
  }

  @override
  void dispose() {
    super.dispose();
    rec.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        showDialog(
            context: context,
            builder: (context) => AlertMessage(
                title: '',
                message: 'Deseja realemente sair da conta ?',
                titleOK: 'Sair',
                cancel: true,
                onPressedCancel: () => Navigator.of(context).pop(),
                onPressedOK: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }));
      },
      child: Scaffold(
        body: Column(
          children: [
            AppBarCustom(
              page: 1,
              back: false,
              admin: controller.user.admin,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    LayoutBuilder(builder: (context, constrains) {
                      double width = constrains.maxWidth > 500
                          ? 500.0
                          : constrains.maxWidth;
                      double width1 = constrains.maxWidth > 500
                          ? constrains.maxWidth * 0.5
                          : constrains.maxWidth;
                      return Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            width: width1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChecklistRegisterPage()));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 2),
                                          child: Text(
                                            "NOVO",
                                            style: subtitle.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    const Spacer(),
                                    Observer(builder: (_) {
                                      return TextButton(
                                          style: TextButton.styleFrom(
                                              side: BorderSide(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                          onPressed: () async {
                                            showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2021),
                                                    lastDate: DateTime(2050))
                                                .then((value) {
                                              if (value != null) {
                                                controller
                                                    .setReferenceDate(value);
                                              }
                                            });
                                          },
                                          child: Text(
                                            formatDate(controller.date,
                                                outher: true,
                                                referenceDate: true),
                                            style: title.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ));
                                    }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                SizedBox(
                                  width: width,
                                  child: Observer(builder: (_) {
                                    return controller.checkLists.isEmpty
                                        ? Center(
                                            child: Text(
                                              "Ops ! Nenhum registro encontrado.",
                                              style: title,
                                            ),
                                          )
                                        : Column(
                                            children: List.generate(
                                                controller.checkLists.length,
                                                (index) {
                                              final checklist =
                                                  controller.checkLists[index];
                                              final delete = controller
                                                      .user.admin ||
                                                  (controller.user.id ==
                                                          checklist.user.id &&
                                                      checklist.enable);

                                              return CheckListCard(
                                                checkList: checklist,
                                                onDelete: delete
                                                    ? () async {
                                                        final result = await showDialog(
                                                            context: context,
                                                            builder: (context) => AlertMessage(
                                                                title:
                                                                    'Atenção',
                                                                message:
                                                                    'Deseja excluir esse checklist ?',
                                                                cancel: true,
                                                                onPressedCancel: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false),
                                                                onPressedOK: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true)));

                                                        if (result ?? false) {
                                                          await controller
                                                              .deleteChecklist(
                                                                  checkList:
                                                                      checklist);
                                                        }
                                                      }
                                                    : null,
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChecklistDetailsPage(
                                                                  checkListId: controller
                                                                      .checkLists[
                                                                          index]
                                                                      .id!)));
                                                },
                                              );
                                            }),
                                          );
                                  }),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                          ),
                          //   Container(
                          //     padding: const EdgeInsets.all(10.0),
                          //     width: width1,
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         const SizedBox(
                          //           height: 8.0,
                          //         ),
                          //         Text(
                          //           "ADMINISTRATIVO",
                          //           style: titleHint,
                          //         ),
                          //         const Divider(),
                          //         Center(
                          //           child: SizedBox(
                          //             width: width,
                          //             child: Observer(builder: (_) {
                          //               return controller.carsADM.isEmpty
                          //                   ? Center(
                          //                       child: Text(
                          //                         "Ops ! Nenhum registro encontrado.",
                          //                         style: title,
                          //                       ),
                          //                     )
                          //                   : Column(
                          //                       children: List.generate(
                          //                           controller.carsADM.length,
                          //                           (index) => CarCard(
                          //                                 car: controller
                          //                                     .carsADM[index],
                          //                                 onTap: () {},
                          //                               )),
                          //                     );
                          //             }),
                          //           ),
                          //         ),
                          //         const SizedBox(
                          //           height: 50.0,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                        ],
                      );
                    }),
                    Observer(builder: (_) {
                      return IgnorePointer(
                        ignoring: !controller.loading,
                        child: Container(
                          color: controller.loading
                              ? Colors.black54
                              : Colors.transparent,
                          child: Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                controller.loading
                                    ? Colors.white
                                    : Colors.transparent),
                          )),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
