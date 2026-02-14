import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/src/checklist/view/pages/checklist_car_page.dart';
import 'package:bsu_control/src/checklist/view/pages/checklist_infor_page.dart';
import 'package:bsu_control/src/checklist/view/pages/checklist_itens_page.dart';
import 'package:bsu_control/src/checklist/view/pages/checklist_materials_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../home/home_page.dart';
import '../controller/checklist_controller.dart';

class ChecklistRegisterPage extends StatefulWidget {
  final CheckListModel? checklist;
  const ChecklistRegisterPage({Key? key, this.checklist}) : super(key: key);

  @override
  State createState() => _ChecklistRegisterPageState();
}

class _ChecklistRegisterPageState extends State<ChecklistRegisterPage> {
  final app = GetIt.I.get<AppController>();
  late CheckListController controller;

  @override
  void initState() {
    super.initState();

    controller = CheckListController(
        init: widget.checklist, app: app, update: (widget.checklist != null));
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      CheckListInforPage(
        controller: controller,
      ),
      ChecklistCarPage(controller: controller),
      ChecklistItensPage(controller: controller),
      ChecklistMaterialsPage(controller: controller)
    ];

    final update = (widget.checklist != null);
    return Scaffold(
      body: Stack(
        children: [
          BackgraundPage(
            menu: !update,
            onBack: update ? () => Navigator.of(context).pop() : null,
            contentBottom: Center(
              child: Row(
                spacing: 50,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Observer(builder: (_) {
                    return (update && controller.step == 0)
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text(
                              'Cancelar',
                              style: Constants.titleButton,
                            ))
                        : ElevatedButton(
                            onPressed: (controller.step > 0)
                                ? () {
                                    controller.processStep(false);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text(
                              'Voltar',
                              style: Constants.titleButton,
                            ));
                  }),
                  Observer(builder: (_) {
                    return controller.btFinish
                        ? ElevatedButton(
                            onPressed: () {
                              controller.save().then((_) {
                                if (update) {
                                  Navigator.of(context).pop();
                                } else {
                                  app.setRouter(0);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage()));
                                }
                              }).catchError((err) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertMessage(
                                          title: 'Atenção',
                                          message: err.toString(),
                                          onPressedOK: () =>
                                              Navigator.of(context).pop(),
                                        ));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primary),
                            child: Text(
                              update ? 'Alterar' : 'Salvar',
                              style: Constants.titleButton,
                            ))
                        : ElevatedButton(
                            onPressed: () {
                              if (controller.validationForm()) {
                                controller.processStep(true);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          content: Column(
                                            spacing: 10,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                  onTap: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  )),
                                              Column(
                                                spacing: 10,
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: controller
                                                    .messagesErros
                                                    .map((err) {
                                                  return Row(
                                                    spacing: 10,
                                                    children: [
                                                      const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          err,
                                                          style:
                                                              Constants.title,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ),
                                        ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primary),
                            child: Text(
                              'Próximo',
                              style: Constants.titleButton,
                            ));
                  }),
                ],
              ),
            ),
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update ? 'Alteração de CHECKLIST' : 'Registro de CHECKLIST',
                  style: Constants.title.copyWith(fontSize: 18),
                ),
                const Divider(),
              ],
            ),
            childLeft: Observer(builder: (_) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: steps[controller.step],
              );
            }),
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
          })
        ],
      ),
    );
  }
}

Widget itemWidget(
    {required ItemModel item, required Function(bool value) onSelect}) {
  bool result = item.value;
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        Checkbox(
            value: result,
            onChanged: (value) {
              setState(() {
                result = value ?? result;
                onSelect(result);
              });
            }),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          item.description,
          style: Constants.subtitle,
        )
      ],
    );
  });
}
