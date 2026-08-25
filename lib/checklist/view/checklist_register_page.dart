import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/controller/checklist_register_controller.dart';
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

import '../../enum/checklist_enum.dart';
import '../../home/view/home_page.dart';
import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import '../../widgets/backgraund_page.dart';
import '../controller/checklist_controller.dart';
import 'pages/checklist_others_page.dart';

class ChecklistRegisterPage extends StatefulWidget {
  final ChecklistType type;
  final ChecklistModel? checklist;

  const ChecklistRegisterPage({
    Key? key,
    this.checklist,
    required this.type,
  }) : super(key: key);

  @override
  State createState() => _ChecklistRegisterPageState();
}

class _ChecklistRegisterPageState extends State<ChecklistRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late CheckListController controller;
  late ChecklistRegisterController register;

  @override
  void initState() {
    super.initState();

    controller = CheckListController(
      config: config,
      checklistTodays: app.checklistsOperationDay,
    );

    register = ChecklistRegisterController(
      init: widget.checklist,
      obms: app.obms,
      cars: app.cars,
      type: widget.type,
      user: app.user,
      checklistTodays: app.checklistsOperationDay,
    );

    if (widget.checklist?.type == ChecklistType.materials) {
      controller
          .getMaterialChecklist(teamID: widget.checklist!.team!.id)
          .then(register.setChecklistMaterial);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    return register.processStep(controller.step)
                        ? ElevatedButton(
                            onPressed: () {
                              log(register.checklist.toJson());
                              controller
                                  .save(checklist: register.checklist)
                                  .then((_) {
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
                              final messages =
                                  register.validationForm(controller.step);
                              if (messages.isEmpty) {
                                if (controller.step == 0 &&
                                    (register.material == null) &&
                                    (widget.type == ChecklistType.materials)) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                            message:
                                                'Ops ! Não foi localizado checklist de material para essa guarnição. Entre em contato com o administrador.',
                                            onPressedOK: () =>
                                                Navigator.of(context).pop(),
                                          ));
                                } else {
                                  controller.processStep(true);
                                }
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertMultMessage(
                                          messages: messages,
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
                  update
                      ? 'Alteração de CHECKLIST ${widget.type.label.toUpperCase()}'
                      : 'Registro de CHECKLIST ${widget.type.label.toUpperCase()}',
                  style: Constants.title.copyWith(fontSize: 16),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            childLeft: Observer(builder: (_) {
              final pages = [
                CheckListInforPage(
                  obms: app.obms,
                  user: app.user,
                  controller: register,
                  changeTeam: (team) async {
                    log('Team: ${team?.toJson() ?? 'null'}');

                    if (widget.type == ChecklistType.materials) {
                      final value = await controller.getMaterialChecklist(
                          teamID: team?.id);
                      register.setChecklistMaterial(value);
                    }

                    register.setTeam(team);
                  },
                ),
                if (widget.type == ChecklistType.vehicular)
                  ChecklistCarPage(
                    user: app.user,
                    controller: register,
                  ),
                if (register.itens.isNotEmpty)
                  ChecklistSectionPage(
                    key: ValueKey(
                        "itens${controller.step}"), //flutter entende que é outro widget e reconstroi.
                    title: 'ITENS OU ACESSÓRIOS',
                    list: register.itens,
                    onChangeItem: (value, indexSection, indexItem) {
                      register.changeList(
                        list: register.itens,
                        value: value,
                        indexSection: indexSection,
                        indexItem: indexItem,
                      );
                    },
                    onChangeOBS: (obs, index) {
                      register.changeOBSListItens(
                        list: register.itens,
                        obs: obs,
                        indexSection: index,
                      );
                    },
                  ),
                if (register.materials.isNotEmpty)
                  ChecklistSectionPage(
                    key: ValueKey(
                        "materials${controller.step}"), //flutter entende que é outro widget e reconstroi.
                    title: 'MATERIAIS',
                    list: register.materials,
                    onChangeItem: (value, indexSection, indexItem) {
                      register.changeList(
                        list: register.materials,
                        value: value,
                        indexSection: indexSection,
                        indexItem: indexItem,
                      );
                    },
                    onChangeOBS: (obs, index) {
                      register.changeOBSListItens(
                        list: register.materials,
                        obs: obs,
                        indexSection: index,
                      );
                    },
                  ),
                CheckListOthersPage(
                  controller: register,
                  user: app.user,
                )
              ];

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
