import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/materials/controller/materials_controller.dart';
import 'package:bsu_control/materials/view/material_checklist_register_page.dart';
import 'package:bsu_control/model/material_checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/card_outhers_widget.dart';
import '../../widgets/container_custom_widget.dart';
import '../../widgets/list_itens_view_widget.dart';

class MaterialsDetailsPage extends StatefulWidget {
  final MaterialsController controller;
  final String checklistID;

  const MaterialsDetailsPage(
      {Key? key, required this.controller, required this.checklistID})
      : super(key: key);

  @override
  State createState() => _MaterialsDetailsPageState();
}

class _MaterialsDetailsPageState extends State<MaterialsDetailsPage> {
  late MaterialChecklistModel checklist;
  late ReactionDisposer rec;
  late MaterialsController controller;

  final app = GetIt.I.get<AppController>();

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

    rec = autorun((_) {
      setState(() {
        checklist = controller.materialsChecklist
            .firstWhere((e) => e.id == widget.checklistID);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgraundPage(
          menu: false,
          onBack: () => Navigator.of(context).pop(),
          wrapAlign: WrapAlignment.spaceBetween,
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                checklist.team?.name.toUpperCase() ?? '',
                style: Constants.title
                    .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(
                label: 'INFORMAÇÕES BÁSICAS',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Organização",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                checklist.obm.name,
                style: Constants.title,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "Companhia",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                checklist.cia?.name ?? '-',
                style: Constants.title,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Guarnição",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                checklist.team?.name ?? '-',
                style: Constants.title,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Responsável",
                style: Constants.subtitleHint,
              ),
              Core.boldFirstName(
                  name: checklist.user.name,
                  fullName: checklist.user.fullname,
                  style: Constants.title),
              const SizedBox(
                height: 10,
              ),
              // const ContainerCustom(
              //   label: 'ÚLTIMOS MATERIAIS USADOS',
              // ),
              // const SizedBox(
              //   height: 10.0,
              // ),
              // (checklist.lastMaterialsConsumed?.isEmpty ?? true)
              //     ? Text(
              //         'Nenhuma registro encontrado.',
              //         style: Constants.titleHint,
              //       )
              //     : Column(
              //         children: List.generate(
              //             checklist.lastMaterialsConsumed!.length, (index) {
              //           final material =
              //               checklist.lastMaterialsConsumed![index];

              //           return Column();
              //         }).expand((widget) => [widget, const Divider()]).toList()
              //           ..removeLast(),
              //       ),
              const SizedBox(
                height: 10.0,
              ),
              const ContainerCustom(
                label: 'ALTERAÇÕES',
              ),
              const SizedBox(
                height: 10.0,
              ),
              (checklist.others?.isEmpty ?? true)
                  ? Text(
                      'Nenhuma outra alteração encontrada',
                      style: Constants.title,
                    )
                  : Column(
                      children:
                          List.generate(checklist.others!.length, (index) {
                        final outher = checklist.others![index];

                        return CardOutherChange(
                          other: outher,
                        );
                      }).expand((widget) => [widget, const Divider()]).toList()
                            ..removeLast(),
                    ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
          childRight: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(
                label: 'ITENS OU ACESSÓRIOS',
              ),
              (checklist.itens?.isEmpty ?? true)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : ListItensViewWidget(
                      categories: checklist.itens!,
                    ),
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(
                label: 'MATERIAIS',
              ),
              (checklist.materials?.isEmpty ?? true)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : ListItensViewWidget(
                      categories: checklist.materials!,
                    ),
              const SizedBox(
                height: 10,
              ),
              if (app.user.admin || app.user.managerMaterials)
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertMessage(
                                    title: 'Atenção',
                                    message:
                                        'Deseja deletar o registro desse checklist ?',
                                    cancel: true,
                                    titleOK: 'Sim',
                                    onPressedOK: () =>
                                        Navigator.of(context).pop(true),
                                    onPressedCancel: () =>
                                        Navigator.of(context).pop(false),
                                  )).then((value) {
                            if (value ?? false) {
                              controller
                                  .deleteMaterialChecklist(material: checklist)
                                  .then((value) {
                                Navigator.of(context).pop();
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
                            }
                          });
                        },
                        child: Text(
                          "Excluir",
                          style: Constants.titleButton,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertMessage(
                                    title: '',
                                    message:
                                        'Deseja criar uma copia atual desse checklist ?',
                                    cancel: true,
                                    titleOK: 'Sim',
                                    onPressedOK: () =>
                                        Navigator.of(context).pop(true),
                                    onPressedCancel: () =>
                                        Navigator.of(context).pop(false),
                                  )).then((value) async {
                            if (value ?? false) {
                              await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MaterialChecklistRegisterPage(
                                            copied: true,
                                            // controller: controller,
                                            material: MaterialChecklistModel(
                                              user: app.user,
                                              obm: checklist.obm,
                                              obmID: checklist.obmID,
                                              team: null,
                                              cia: checklist.cia,
                                              ciaID: checklist.ciaID,
                                              itens: checklist.itens,
                                              materials: checklist.materials,
                                            ),
                                          )));
                            }
                          });
                        },
                        child: Text(
                          "Copiar",
                          style: Constants.titleButton,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MaterialChecklistRegisterPage(
                                    // controller: controller,
                                    material: checklist,
                                  )));
                        },
                        child: Text(
                          "Editar",
                          style: Constants.titleButton,
                        )),
                  ],
                ),
              const SizedBox(
                height: 50.0,
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
        })
      ],
    );
  }
}
