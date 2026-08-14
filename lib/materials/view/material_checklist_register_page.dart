import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/materials/controller/materials_controller.dart';
import 'package:bsu_control/materials/controller/materials_register_controller.dart';
import 'package:bsu_control/model/materials_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../model/cia_model.dart';
import '../../model/obm_model.dart';
import '../../model/team_model.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/list_sections_widget.dart';

class MaterialChecklistRegisterPage extends StatefulWidget {
  final MaterialsModel? material;
  const MaterialChecklistRegisterPage({Key? key, this.material})
      : super(key: key);

  @override
  State createState() => _MaterialChecklistRegisterPageState();
}

class _MaterialChecklistRegisterPageState
    extends State<MaterialChecklistRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late MaterialsController controller;
  late MaterialsRegisterController register;

  @override
  void initState() {
    super.initState();

    controller = MaterialsController(
      config: config,
      obmID: app.user.obmID,
    );

    register = MaterialsRegisterController(
      obms: app.obms,
      init: widget.material,
      user: app.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.material != null);

    // final pages = [
    //   MaterialRegisterInforPage(controller: register),
    //   // CarRegisterDetailsPage(controller: register),
    //   // CarRegisterFunctionPage(controller: register),
    // ];

    return Stack(
      children: [
        BackgraundPage(
          menu: (widget.material == null),
          onBack: (widget.material == null)
              ? null
              : () => Navigator.of(context).pop(),
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registro de material',
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childLeft: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "INFORMAÇÕES BÁSICAS",
                    style: Constants.titleButton,
                  ),
                ),
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              e.prefix,
                                              style: Constants.title,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              e.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Constants.subtitle
                                                  .copyWith(color: Colors.grey),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
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
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                        e.name.toUpperCase(),
                                                        style: Constants.title),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(
                                                    e.name.toUpperCase(),
                                                    style: Constants.title),
                                              ),
                                            ))
                                        .toList(),
                                  ]),
                            ),
                          ],
                        )
                      : Container();
                }),
              ],
            ),
          ),
          childRight: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                  spacing: 10,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.primary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "MATERIAIS",
                        style: Constants.titleButton,
                      ),
                    ),
                    Observer(builder: (context) {
                      return ListSectionsWidget(
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
