import 'package:bsu_control/checklist/view/widget/checklist_item_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:flutter/material.dart';

import '../../../widgets/container_custom_widget.dart';
import '../../../widgets/textfield_widget.dart';

class ChecklistSectionPage extends StatefulWidget {
  final String title;
  final List<SectionItensModel> list;
  final Function(String, int) onChangeOBS;
  final Function(ItemModel, int indexSection, int indexItem) onChangeItem;

  const ChecklistSectionPage(
      {Key? key,
      required this.list,
      required this.title,
      required this.onChangeOBS,
      required this.onChangeItem})
      : super(key: key);

  @override
  State<ChecklistSectionPage> createState() => _ChecklistSectionPageState();
}

class _ChecklistSectionPageState extends State<ChecklistSectionPage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ContainerCustom(
            label: widget.title,
            color: Colors.grey.shade800,
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              runSpacing: 10,
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(widget.list.length, (indexSection) {
                final category = widget.list[indexSection];
                return Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 450),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContainerCustom(
                        label: category.description,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Text(
                              "Marque os itens que estão em conformidade ou coloque a quantidade encontrada",
                              style: Constants.subtitleHint,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  category.value = !category.value;
                                });
                              },
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Constants.primary,
                                child: Icon(
                                  category.value
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: category.value,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: List.generate(category.itens.length,
                                    (indexItem) {
                              final item = category.itens[indexItem];

                              return ChecklistItemWidget(
                                item: item,
                                onChange: (value) {
                                  widget.onChangeItem(
                                      value, indexSection, indexItem);
                                },
                              );
                            })
                                .expand((widget) => [widget, const Divider()])
                                .toList()
                              ..removeLast(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Observação',
                        style: Constants.titleHint,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FieldText(
                        initValue: widget.list[indexSection].obs,
                        hint: "EX.: Alguma informação importante",
                        onChange: (text) {
                          widget.onChangeOBS(text, indexSection);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
