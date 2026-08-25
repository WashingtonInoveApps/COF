import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/materials/controller/materials_controller.dart';
import 'package:bsu_control/materials/controller/materials_register_controller.dart';
import 'package:bsu_control/materials/view/materials_page.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/material_checklist_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/widgets/container_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../model/cia_model.dart';
import '../../model/obm_model.dart';
import '../../model/outher_changes_model.dart';
import '../../model/team_model.dart';
import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/card_outhers_widget.dart';
import '../../widgets/image_change_widget.dart';
import '../../widgets/list_sections_widget.dart';

class MaterialChecklistRegisterPage extends StatefulWidget {
  final bool copied;
  final MaterialChecklistModel? material;
  // final MaterialsController controller;

  const MaterialChecklistRegisterPage({
    Key? key,
    this.material,
    // required this.controller,
    this.copied = false,
  }) : super(key: key);

  @override
  State createState() => _MaterialChecklistRegisterPageState();
}

class _MaterialChecklistRegisterPageState
    extends State<MaterialChecklistRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late MaterialsController controller;
  late MaterialsRegisterController register;

  List<ItemModel>? itens;
  late List<MaterialChecklistModel> materials;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    controller = MaterialsController(config: config, obmID: app.user.obmID);

    initialization().then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> initialization() async {
    controller.setLoading(true);
    itens = await controller.getMaterialsWarehouse();
    materials = await controller.getMaterialChecklist();

    register = MaterialsRegisterController(
      obms: app.obms,
      init: widget.material,
      user: app.user,
      checklists: materials,
    );

    controller.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.material != null && !widget.copied);

    return Stack(
      children: [
        BackgraundPage(
          menu: !update,
          onBack: !update ? null : () => Navigator.of(context).pop(),
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${update ? "Alteração" : "Registro"} de Checklist do Material',
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childLeft: loading
              ? const Center(
                  child: LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Constants.primary),
                  ),
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ContainerCustom(label: "INFORMAÇÕES BÁSICAS"),
                      Text(
                        "ORGANIZAÇÃO",
                        style: Constants.titleHint,
                      ),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Observer(builder: (_) {
                          return IgnorePointer(
                            ignoring: true,
                            child: DropdownButton<OBMModel>(
                                isExpanded: true,
                                value: register.obm,
                                underline: Container(),
                                onChanged: register.setOBM,
                                items: [
                                  DropdownMenuItem(
                                      value: null,
                                      child: Text(
                                        'Selecione',
                                        style: Constants.title,
                                      )),
                                  ...register.obms
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    e.prefix,
                                                    style: Constants.title,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    e.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Constants.subtitle
                                                        .copyWith(
                                                            color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ]),
                          );
                        }),
                      ),
                      Observer(builder: (context) {
                        return (register.obm?.cias.isNotEmpty ?? false)
                            ? Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "COMPANHIA",
                                    style: Constants.titleHint,
                                  ),
                                  Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: DropdownButton<CiaModel?>(
                                        isExpanded: true,
                                        value: register.cia,
                                        underline: Container(),
                                        onChanged: register.setCia,
                                        items: [
                                          DropdownMenuItem(
                                              value: null,
                                              child: Text(
                                                'Selecione',
                                                style: Constants.title,
                                              )),
                                          ...register.obm?.cias
                                                  .map((e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child: Text(
                                                              e.name
                                                                  .toUpperCase(),
                                                              style: Constants
                                                                  .title),
                                                        ),
                                                      ))
                                                  .toList() ??
                                              [],
                                        ]),
                                  ),
                                ],
                              )
                            : Container();
                      }),
                      Observer(builder: (context) {
                        return (register.teams.isNotEmpty)
                            ? Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "GUARNIÇÃO",
                                    style: Constants.titleHint,
                                  ),
                                  Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: DropdownButton<TeamModel?>(
                                        isExpanded: true,
                                        value: register.team,
                                        underline: Container(),
                                        onChanged: register.setTeam,
                                        items: [
                                          DropdownMenuItem(
                                              value: null,
                                              child: Text(
                                                'Selecione',
                                                style: Constants.title,
                                              )),
                                          ...register.teams
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                          e.name.toUpperCase(),
                                                          style:
                                                              Constants.title),
                                                    ),
                                                  ))
                                              .toList(),
                                        ]),
                                  ),
                                ],
                              )
                            : Container();
                      }),
                      const ContainerCustom(label: 'OUTRAS ALTERAÇÕES'),
                      Observer(builder: (context) {
                        return register.changes.isEmpty
                            ? Text(
                                'Nenhuma outra alteração encontrada',
                                style: Constants.titleHint,
                              )
                            : Column(
                                children: List.generate(register.changes.length,
                                        (index) {
                                  final other = register.changes[index];

                                  return CardOutherChange(
                                    admin: true,
                                    other: other,
                                    onDelete: () {
                                      // register.deletedFiles(other.image);
                                      register.deleteChange(index);
                                    },
                                  );
                                })
                                    .expand(
                                        (widget) => [widget, const Divider()])
                                    .toList()
                                  ..removeLast(),
                              );
                      }),
                      Center(
                        child: IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => ImageChangeWidget(
                                        aspectRatio: null,
                                        onSelect: (image, description) {
                                          register.addChange(
                                            OtherChangeModel(
                                              id: const Uuid().v4(),
                                              date: DateTime.now(),
                                              description: description,
                                              image: image,
                                              user: app.user,
                                            ),
                                          );
                                        },
                                      ));
                            },
                            style: IconButton.styleFrom(
                                backgroundColor: Constants.primary),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                    ],
                  ),
                ),
          childRight: loading
              ? null
              : Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ContainerCustom(label: "ITENS OU ACESSÓRIOS"),
                        Observer(builder: (context) {
                          return ListSectionsWidget(
                              obmID: app.user.obmID,
                              ciaID: app.user.ciaID,
                              list: List<SectionItensModel>.from(
                                  register.sectionsItens),
                              onAddSections: (value) {
                                register.addSections(
                                  list: register.sectionsItens,
                                  value: value,
                                );
                              },
                              onRemoveSection: (index) {
                                register.removeSections(
                                  list: register.sectionsItens,
                                  index: index,
                                );
                              },
                              onEditSection: (itens, index) {
                                register.editSections(
                                  list: register.sectionsItens,
                                  index: index,
                                  value: itens,
                                );
                              },
                              onExpansionSection: (index) {
                                register.expansionSections(
                                  list: register.sectionsItens,
                                  index: index,
                                );
                              },
                              onRemoveItens: (index, indexItem) {
                                register.removeItensSection(
                                  list: register.sectionsItens,
                                  index: index,
                                  indexItem: indexItem,
                                );
                              },
                              onEditItens: (item, index, indexItem) {
                                register.editItensSection(
                                  list: register.sectionsItens,
                                  index: index,
                                  indexItem: indexItem,
                                  value: item,
                                );
                              },
                              onAddItens: (item, index) {
                                register.addItensSection(
                                  list: register.sectionsItens,
                                  index: index,
                                  value: item,
                                );
                              },
                              onMoveItens: (index, indexItem, position) {
                                register.moveItensSection(
                                  list: register.sectionsItens,
                                  index: index,
                                  indexItem: indexItem,
                                  position: position,
                                );
                              });
                        }),
                        const ContainerCustom(label: "MATERIAIS"),
                        Observer(builder: (context) {
                          return ListSectionsWidget(
                              obmID: app.user.obmID,
                              ciaID: app.user.ciaID,
                              itensMaterials: itens,
                              list: List<SectionItensModel>.from(
                                  register.sectionsMaterials),
                              onAddSections: (value) {
                                register.addSections(
                                  list: register.sectionsMaterials,
                                  value: value,
                                );
                              },
                              onRemoveSection: (index) {
                                register.removeSections(
                                  list: register.sectionsMaterials,
                                  index: index,
                                );
                              },
                              onEditSection: (itens, index) {
                                register.editSections(
                                  list: register.sectionsMaterials,
                                  index: index,
                                  value: itens,
                                );
                              },
                              onExpansionSection: (index) {
                                register.expansionSections(
                                  list: register.sectionsMaterials,
                                  index: index,
                                );
                              },
                              onRemoveItens: (index, indexItem) {
                                register.removeItensSection(
                                  list: register.sectionsMaterials,
                                  index: index,
                                  indexItem: indexItem,
                                );
                              },
                              onEditItens: (item, index, indexItem) {
                                register.editItensSection(
                                  list: register.sectionsMaterials,
                                  index: index,
                                  indexItem: indexItem,
                                  value: item,
                                );
                              },
                              onAddItens: (item, index) {
                                register.addItensSection(
                                  list: register.sectionsMaterials,
                                  index: index,
                                  value: item,
                                );
                              },
                              onMoveItens: (index, indexItem, position) {
                                register.moveItensSection(
                                  list: register.sectionsMaterials,
                                  index: index,
                                  indexItem: indexItem,
                                  position: position,
                                );
                              });
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 45.0,
                              width: 120,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    'Cancelar',
                                    style: Constants.titleButton,
                                  )),
                            ),
                            SizedBox(
                              height: 45.0,
                              width: 120,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    final messagesValidation =
                                        register.validationForm();

                                    if (messagesValidation.isEmpty) {
                                      log('Salvar');
                                      controller
                                          .saveMaterialChecklist(
                                        material: register.material,
                                        others: register.changes,
                                        deletedFiles: register.deletFiles,
                                      )
                                          .then((_) {
                                        if (update || widget.copied) {
                                          Navigator.of(context).pop();
                                        } else {
                                          app.setRouter(7);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MaterialsPage()));
                                        }
                                      }).catchError((err) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertMessage(
                                                  title: 'Atenção',
                                                  message: err.toString(),
                                                  onPressedOK: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ));
                                      });
                                    } else {
                                      await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              AlertMultMessage(
                                                  messages:
                                                      messagesValidation));
                                    }
                                  },
                                  child: Text(
                                    update ? "Alterar" : "Salvar",
                                    style: Constants.titleButton,
                                  )),
                            ),
                          ],
                        )
                      ])),
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
