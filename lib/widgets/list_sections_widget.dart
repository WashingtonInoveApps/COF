// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:bsu_control/car/view/widgets/section_widget.dart';

import '../core/constants.dart';
import '../model/item_model.dart';
import '../model/itens_changes_model.dart';
import 'alert_message.dart';
import '../core/sections_controller.dart';
import '../car/view/widgets/itens_section_widget.dart';

class ListSectionsWidget extends StatefulWidget {
  final List<ItensChangesModel> list;

  final Function(ItensChangesModel value) onAddSections;
  final Function(int index) onRemoveSection;
  final Function(ItensChangesModel value, int index) onEditSection;
  final Function(int index) onExpansionSection;

  final Function(ItemModel value, int index) onAddItens;
  final Function(int index, int indexItem) onRemoveItens;
  final Function(ItemModel value, int index, int indexItem) onEditItens;
  final Function(int index, int indexItem, MoveDirection position) onMoveItens;

  const ListSectionsWidget({
    Key? key,
    required this.list,
    required this.onAddSections,
    required this.onRemoveSection,
    required this.onEditSection,
    required this.onExpansionSection,
    required this.onRemoveItens,
    required this.onEditItens,
    required this.onAddItens,
    required this.onMoveItens,
  }) : super(key: key);

  @override
  State<ListSectionsWidget> createState() => _ListSectionsWidgetState();
}

class _ListSectionsWidgetState extends State<ListSectionsWidget> {
  @override
  Widget build(BuildContext context) {
    log(widget.list.map((e) => e.toJson()).toList().toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.list.isEmpty
            ? Text(
                'Nenhum itens encontrado.',
                style: Constants.title,
              )
            : Column(
                children: List.generate(widget.list.length, (index) {
                  final section = widget.list[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Expanded(
                                  child: Text(
                                section.description,
                                style: Constants.title,
                              )),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: 'Atenção',
                                          message:
                                              'Deseja excluir essa categoria de itens ?',
                                          cancel: true,
                                          titleOK: 'Sim',
                                          onPressedCancel: () =>
                                              Navigator.of(context).pop(false),
                                          onPressedOK: () =>
                                              Navigator.of(context)
                                                  .pop(true))).then((value) {
                                    if (value ?? false) {
                                      widget.onRemoveSection.call(index);
                                    }
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                            child: SectionWidget(
                                              section: section,
                                              onChange: (value) {
                                                widget.onEditSection
                                                    .call(value, index);
                                              },
                                            ),
                                          ));
                                },
                                child: const CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.edit,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    widget.onExpansionSection.call(index),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    section.value
                                        ? Icons.keyboard_arrow_up_outlined
                                        : Icons.keyboard_arrow_down_outlined,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: section.value,
                              child: SizedBox(
                                height: 300,
                                child: changesListWidget(
                                    section: section,
                                    context: context,
                                    onDelete: (indexItem) => widget
                                        .onRemoveItens
                                        .call(index, indexItem),
                                    onAdd: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                                child: ItensSectionWidget(
                                                  onChange: (value) {
                                                    widget.onAddItens
                                                        .call(value, index);
                                                  },
                                                ),
                                              ));
                                    },
                                    onEdit: (item, indexItem) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                                child: ItensSectionWidget(
                                                  item: item,
                                                  onChange: (value) {
                                                    widget.onEditItens.call(
                                                        value,
                                                        index,
                                                        indexItem);
                                                  },
                                                ),
                                              ));
                                    },
                                    onMove: (indexItem, position) {
                                      widget.onMoveItens
                                          .call(index, indexItem, position);
                                    }),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
              ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Center(
                          child: SectionWidget(
                            onChange: (value) {
                              widget.onAddSections.call(value);
                            },
                          ),
                        ));
              },
              style: IconButton.styleFrom(backgroundColor: Constants.primary),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              )),
        ),
      ],
    );
  }
}

Widget changesListWidget({
  required ItensChangesModel section,
  required BuildContext context,
  required Function(ItemModel, int) onEdit,
  required Function(int i) onDelete,
  required void Function(int, MoveDirection) onMove,
  required Function() onAdd,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 5,
      ),
      const Divider(),
      Expanded(
        child: section.itens.isEmpty
            ? Text(
                'Nenhum item adicionado na seção.',
                style: Constants.subtitleHint,
              )
            : SingleChildScrollView(
                child: Column(
                  children: List.generate(
                          section.itens.length,
                          (index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  spacing: 5,
                                  children: [
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            section.itens[index].description,
                                            style: Constants.title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        Text(
                                          '${section.itens[index].quantity} unids.',
                                          style: Constants.titleHint,
                                        )
                                      ],
                                    ),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        InkWell(
                                          onTap: (index == 0)
                                              ? null
                                              : () => onMove(
                                                  index, MoveDirection.up),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: (index == 0)
                                                ? Colors.grey
                                                : Constants.primary,
                                            child: const Icon(
                                              Icons.arrow_upward_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (index <
                                                  (section.itens.length - 1))
                                              ? () => onMove(
                                                  index, MoveDirection.down)
                                              : null,
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: (index <
                                                    (section.itens.length - 1))
                                                ? Constants.primary
                                                : Colors.grey,
                                            child: const Icon(
                                              Icons.arrow_downward_rounded,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Constants.primary,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          onTap: () => onEdit(
                                              section.itens[index], index),
                                        ),
                                        InkWell(
                                          child: const CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          onTap: () => onDelete(index),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                      .expand((widget) => [widget, const Divider()])
                      .toList()
                    ..removeLast(),
                ),
              ),
      ),
      Center(
        child: InkWell(
          onTap: onAdd,
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Constants.primary,
            child: Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
