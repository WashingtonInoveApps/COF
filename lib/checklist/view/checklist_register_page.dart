import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/view/pages/checklist_car_page.dart';
import 'package:bsu_control/checklist/view/pages/checklist_infor_page.dart';
import 'package:bsu_control/checklist/view/pages/checklist_section_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../home/home_page.dart';
import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import '../../widgets/backgraund_page.dart';
import '../controller/checklist_controller.dart';

class ChecklistRegisterPage extends StatefulWidget {
  final ChecklistModel? checklist;
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
      init: widget.checklist,
      config: config,
      update: (widget.checklist != null),
      cars: app.cars,
      checklistTodays: app.checklistsOperationDay,
    );
  }

  double processWidth(double value) {
    if (value <= 500) return value;

    return value * 0.48;
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.checklist != null);

    final pages = [
      CheckListInforPage(
        obms: app.obms,
        user: app.user,
        controller: controller,
      ),
      ChecklistCarPage(
        user: app.user,
        width: processWidth(app.width),
        controller: controller,
      ),
      Observer(builder: (context) {
        return ChecklistSectionPage(
          key: ValueKey(
              "itens${controller.step}"), //flutter entende que é outro widget e reconstroi.
          width: processWidth(app.width),
          title: 'ITENS OU ACESSÓRIOS',
          // sections: controller.car?.itens ?? [],
          list: controller.itens,
          onChangeItem: (value, indexSection, indexItem) {
            controller.changeList(
                list: controller.itens,
                value: value,
                indexSection: indexSection,
                indexItem: indexItem);
          },
          onChangeOBS: (obs, index) {
            controller.changeOBS(
                list: controller.itens, obs: obs, indexSection: index);
          },
        );
      }),
      Observer(builder: (context) {
        return ChecklistSectionPage(
          key: ValueKey("materials${controller.step}"),
          width: processWidth(app.width),
          title: 'MATERIAIS PERMANENTES',
          // sections: controller.car?.materials ?? [],
          list: controller.materials,
          onChangeItem: (value, indexSection, indexItem) {
            controller.changeList(
                list: controller.materials,
                value: value,
                indexSection: indexSection,
                indexItem: indexItem);
          },
          onChangeOBS: (obs, index) {
            controller.changeOBS(
                list: controller.materials, obs: obs, indexSection: index);
          },
        );
      }),
      Observer(builder: (context) {
        return ChecklistSectionPage(
          key: ValueKey("consumable${controller.step}"),
          width: processWidth(app.width),
          title: 'MATERIAIS DE CONSUMO',
          // sections: controller.car?.materialsConsumable ?? [],
          list: controller.materialsConsumable,
          onChangeItem: (value, indexSection, indexItem) {
            controller.changeList(
                list: controller.materialsConsumable,
                value: value,
                indexSection: indexSection,
                indexItem: indexItem);
          },
          onChangeOBS: (obs, index) {
            controller.changeOBS(
                list: controller.materialsConsumable,
                obs: obs,
                indexSection: index);
          },
        );
      }),
    ];

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
                              controller.save(user: app.user).then((_) {
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
                            onPressed: () async {
                              if (controller.validationForm()) {
                                controller.processStep(true);
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertMultMessage(
                                        messages: controller.messagesErros));
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
                child: pages[controller.step],
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
