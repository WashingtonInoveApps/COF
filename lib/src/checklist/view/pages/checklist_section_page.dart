import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/checklist/view/widget/checklist_item_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';

class ChecklistSectionPage extends StatelessWidget {
  final String title;
  final double width;
  final List<ItensChangesModel> sections;
  final List<ItensChangesModel> list;
  final Function(String, int) onChangeOBS;
  final Function(ItemModel, int indexSection, int indexItem) onChangeItem;

  const ChecklistSectionPage(
      {Key? key,
      required this.list,
      required this.title,
      required this.sections,
      required this.width,
      required this.onChangeOBS,
      required this.onChangeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = processWidth(width);

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              title,
              style: Constants.titleButton,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              children: List.generate(sections.length, (indexSection) {
                final category = sections[indexSection];
                return Container(
                  width: size,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          category.description,
                          style: Constants.titleButton,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Marque os itens que estão em conformidade ou coloque a quantidade encontrada",
                        style: Constants.subtitleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children:
                            List.generate(category.itens.length, (indexItem) {
                          final item = category.itens[indexItem];
                          final itemChange =
                              list[indexSection].itens[indexItem];

                          return ChacklistItemWidget(
                            item: item,
                            init: itemChange,
                            onChange: (value) {
                              onChangeItem(
                                  value.copyWith(
                                      quantity: item.quantity,
                                      quantityMarked: value.quantity),
                                  indexSection,
                                  indexItem);
                            },
                          );
                        }),
                      ),
                      Text(
                        'OBSERVAÇÕES',
                        style: Constants.subtitleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FieldText(
                        initValue: list[indexSection].obs,
                        hint: "EX.: Alguma informação importante",
                        onChange: (text) {
                          onChangeOBS(text, indexSection);
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

double processWidth(double value) {
  if (value <= 500) return value;

  return value * 0.48;
}
