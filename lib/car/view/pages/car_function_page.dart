import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/widgets/list_sections_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/validation.dart';
import '../../../enum/car_enum.dart';
import '../../../model/outher_changes_model.dart';
import '../../../widgets/car_changes_widget.dart';
import '../../../widgets/card_outhers_widget.dart';
import '../../../widgets/container_custom_widget.dart';
import '../../../widgets/image_change_widget.dart';
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
                const ContainerCustom(
                  label: "DETALHES DO VEÍCULO",
                ),
                Text(
                  "Função",
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
                    return DropdownButton<FunctionCar?>(
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
                          ...FunctionCar.values
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(e.label.toUpperCase(),
                                          style: Constants.title),
                                    ),
                                  ))
                              .toList()
                        ]);
                  }),
                ),
                Text(
                  "Tipo",
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
                  return register.otherTypeField
                      ? FieldText(
                          initValue: register.otherType,
                          hint: "TIPO DE VEÍCULO",
                          validation: Validation.validatorPreenchimento,
                          onChange: register.setOtherType,
                          textCase: FieldTextCase.upper,
                        )
                      : Container();
                }),
                Center(
                  child: Observer(builder: (_) {
                    return CarChangesWidget(
                      car: register.car,
                      changes: List<CarChangeModel>.from(register.changes),
                      remove: true,
                      register: true,
                      user: register.user,
                      update: true,
                      onChange: register.onChanges,
                      onChangeImages: register.setImagens,
                      onDelet: register.deletedFiles,
                    );
                  }),
                ),
                const SizedBox(
                  height: 5,
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
                const ContainerCustom(
                  label: "OUTRAS ALTERAÇÕES",
                ),
                Observer(builder: (context) {
                  return register.others.isEmpty
                      ? Text(
                          'Nenhuma outra alteração encontrada',
                          style: Constants.titleHint,
                        )
                      : Column(
                          children:
                              List.generate(register.others.length, (index) {
                            final other = register.others[index];

                            return CardOutherChange(
                              other: other,
                              onDelete: () {
                                register.deletedFiles(other.image);
                                register.deleteOtherChange(index);
                              },
                            );
                          })
                                  .expand((widget) => [widget, const Divider()])
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
                                      register.addOtherChange(
                                        OtherChangeModel(
                                          date: DateTime.now(),
                                          description: description,
                                          image: image,
                                          user: register.user,
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
                        ))),
                const ContainerCustom(
                  label: "ITENS OU ACESSÓRIOS",
                ),
                Observer(builder: (context) {
                  return ListSectionsWidget(
                      list:
                          List<SectionItensModel>.from(register.sectionsItens),
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
