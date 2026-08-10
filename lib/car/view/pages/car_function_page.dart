import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/car/view/widgets/list_sections_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/validation.dart';
import '../../../widgets/car_changes_widget.dart';
import '../../../widgets/textfield_widget.dart';

class CarRegisterFunctionPage extends StatefulWidget {
  final CarRegisterController controller;
  const CarRegisterFunctionPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CarRegisterFunctionPage> createState() =>
      _CarRegisterFunctionPageState();
}

class _CarRegisterFunctionPageState extends State<CarRegisterFunctionPage> {
  late CarRegisterController register;

  final carTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    register = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
    carTypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          Container(
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
                    "DETALHES DO VEÍCULO",
                    style: Constants.titleButton,
                  ),
                ),
                Text(
                  "FUNÇÃO",
                  style: Constants.titleHint,
                ),
                Container(
                  height: 45.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Observer(builder: (_) {
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: register.function,
                        underline: Container(),
                        onChanged: (value) {
                          register.setFunction(value);
                          FocusScope.of(context).unfocus();
                        },
                        items: [
                          DropdownMenuItem(
                              value: null,
                              child: Text(
                                'Selecione',
                                style: Constants.title,
                              )),
                          ...Constants.carsFunctions
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(e.toUpperCase(),
                                          style: Constants.title),
                                    ),
                                  ))
                              .toList()
                        ]);
                  }),
                ),
                Text(
                  "TIPO DE VEÍCULO",
                  style: Constants.titleHint,
                ),
                Container(
                  height: 45.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Observer(builder: (_) {
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: register.type,
                        underline: Container(),
                        onChanged: (value) {
                          register.setType(value);
                          carTypeController.text = '';

                          FocusScope.of(context).unfocus();
                        },
                        items: [
                          DropdownMenuItem(
                              value: null,
                              child: Text(
                                'Selecione',
                                style: Constants.title,
                              )),
                          ...register.types
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(e.toUpperCase(),
                                          style: Constants.title),
                                    ),
                                  ))
                              .toList()
                        ]);
                  }),
                ),
                Observer(builder: (_) {
                  return register.fieldCarTypeVisible
                      ? FieldText(
                          controller: carTypeController,
                          hint: "TIPO DE VEÍCULO",
                          validation: Validation.validatorPreenchimento,
                        )
                      : Container();
                }),
                Center(
                  child: Observer(builder: (_) {
                    return CarChangesWidget(
                      car: register.car,
                      remove: true,
                      register: true,
                      user: register.user,
                      update: true,
                      onChange: register.onChanges,
                      onChangeImages: register.setImagens,
                    );
                  }),
                ),
              ],
            ),
          ),
          Container(
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
                    "ITENS OU ACESSÓRIOS",
                    style: Constants.titleButton,
                  ),
                ),
                Observer(builder: (context) {
                  return ListSectionsWidget(
                      list:
                          List<ItensChangesModel>.from(register.sectionsItens),
                      onAddSections: (value) {
                        print(value.toJson());
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
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
