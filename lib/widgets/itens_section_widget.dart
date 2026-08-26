import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/enum/core_enum.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:uuid/uuid.dart';

import 'textfield_widget.dart';

class ItensSectionWidget extends StatefulWidget {
  final List<ItemModel>? itensMaterials;
  final ItemModel? item;
  final bool material;
  final String obmID;
  final String ciaID;
  final Function(ItemModel) onChange;

  const ItensSectionWidget({
    Key? key,
    this.item,
    required this.onChange,
    this.material = false,
    this.itensMaterials,
    required this.obmID,
    required this.ciaID,
  }) : super(key: key);

  @override
  State<ItensSectionWidget> createState() => _ItensSectionWidgetState();
}

class _ItensSectionWidgetState extends State<ItensSectionWidget> {
  final formKEY = GlobalKey<FormState>();
  final formKEYQuantity = GlobalKey<FormState>();

  final uid = const Uuid();
  final controllerQuantity = TextEditingController();

  late ItemModel item;

  @override
  void initState() {
    super.initState();

    if (widget.itensMaterials != null) {
      item = widget.itensMaterials?.cast<ItemModel?>().firstWhere(
                (e) => e?.id == widget.item?.id,
                orElse: () => null,
              ) ??
          ItemModel(
            id: uid.v4(),
            description: '',
            obmID: widget.obmID,
            ciaID: widget.ciaID,
          );
    } else {
      item = ItemModel(
        id: uid.v4(),
        description: '',
        obmID: widget.obmID,
        ciaID: widget.ciaID,
      );

      if (widget.item != null) {
        item = ItemModel.fromMap(widget.item!.toMap());
      }
    }

    controllerQuantity.text = widget.item?.quantity.toString() ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    controllerQuantity.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 350,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: widget.itensMaterials != null
              ? Form(
                  key: formKEYQuantity,
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListWidget<ItemModel>(
                        value: item,
                        list: widget.itensMaterials ?? [],
                        hint: 'Selecione o componente',
                        searchText: (item) {
                          return item.description;
                        },
                        onSelect: (value) {
                          setState(() {
                            item = value;
                          });
                        },
                        child: (item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.description,
                                  style: Constants.title,
                                ),
                                Text(
                                  item.unit.label,
                                  style: Constants.subtitleHint,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      FieldText(
                        controller: controllerQuantity,
                        hint: 'Ex: 1',
                        label: 'Quantidade',
                        inputType: TextInputType.number,
                        validation: Validation.validatorNumber,
                      ),
                      SizedBox(
                        height: 45.0,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKEYQuantity.currentState!.validate()) {
                                widget.onChange(item.copyWith(
                                    quantity:
                                        int.parse(controllerQuantity.text)));
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              (widget.item == null) ? "Adicionar" : "Alterar",
                              style: Constants.titleButton,
                            )),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: formKEY,
                  child: Column(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldText(
                        initValue: item.description,
                        hint: 'Ex: Nome do item',
                        label: 'Descrição',
                        validation: Validation.validatorPreenchimento,
                        onSaved: (text) {
                          item.description = text ?? '';
                        },
                      ),
                      if (widget.material)
                        Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FieldText(
                              initValue: item.register,
                              hint: '0000000',
                              label: 'Registro',
                              inputType: TextInputType.number,
                              onSaved: (text) {
                                item.register = text ?? '';
                              },
                            ),
                            Container(
                              height: 55.0,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade700),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "Unidade",
                                    style: Constants.titleHint,
                                  ),
                                  Expanded(
                                    child: DropdownButton<ItemUnit>(
                                        isExpanded: true,
                                        value: item.unit,
                                        underline: Container(),
                                        onChanged: (value) {
                                          if (value == null) return;

                                          setState(() {
                                            item.unit = value;
                                          });
                                        },
                                        items: [
                                          ...ItemUnit.values
                                              .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5),
                                                      child: Text(
                                                          e.label.toUpperCase(),
                                                          style:
                                                              Constants.title),
                                                    ),
                                                  ))
                                              .toList()
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 55.0,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade700),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Text(
                                    "Validade",
                                    style: Constants.titleHint,
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await showMonthPicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2020),
                                                lastDate: DateTime(
                                                    DateTime.now().year + 5))
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              item.validity = value;
                                            });
                                          }
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          item.validity = null;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: (item.validity == null)
                                                ? Text(
                                                    'Sem validade',
                                                    style:
                                                        Constants.subtitleHint,
                                                    textAlign: TextAlign.right,
                                                  )
                                                : Text(
                                                    Core.formatDate(
                                                        item.validity!,
                                                        monthLarge: true),
                                                    textAlign: TextAlign.right,
                                                    style: Constants.title,
                                                  ),
                                          ),
                                          if ((item.validity != null))
                                            Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.grey.shade700,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      FieldText(
                        // controller: controllerQuantity,
                        initValue: item.quantity.toString(),
                        hint: 'Ex: 1',
                        label: 'Quantidade',
                        inputType: TextInputType.number,
                        validation: Validation.validatorNumber,
                        onSaved: (text) {
                          if (text == null) return;
                          item.quantity = int.parse(text);
                        },
                      ),
                      SizedBox(
                        height: 45.0,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKEY.currentState!.validate()) {
                                formKEY.currentState?.save();
                                widget.onChange(item);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              (widget.item == null) ? "Adicionar" : "Alterar",
                              style: Constants.titleButton,
                            )),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
