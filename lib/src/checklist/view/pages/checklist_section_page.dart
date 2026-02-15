import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/checklist/view/widget/checklist_item_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChecklistSectionPage extends StatefulWidget {
  final String title;
  final double width;
  final List<ItensChangesModel> list;
  final Function(String, int) onChangeOBS;
  final Function(ItemModel, int indexSection, int indexItem) onChangeItem;

  const ChecklistSectionPage(
      {Key? key,
      required this.list,
      required this.title,
      required this.width,
      required this.onChangeOBS,
      required this.onChangeItem})
      : super(key: key);

  @override
  State<ChecklistSectionPage> createState() => _ChecklistSectionPageState();
}

class _ChecklistSectionPageState extends State<ChecklistSectionPage> {
  final app = GetIt.I.get<AppController>();

  @override
  Widget build(BuildContext context) {
    final size = processWidth(widget.width);

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
              widget.title,
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
              children: List.generate(widget.list.length, (indexSection) {
                final category = widget.list[indexSection];
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
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          category.description,
                          style: Constants.titleButton,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                                backgroundColor: Colors.blue.shade700,
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
                        child: Column(
                          children:
                              List.generate(category.itens.length, (indexItem) {
                            final item = category.itens[indexItem];

                            return ChacklistItemWidget(
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
                      Text(
                        'OBSERVAÇÕES',
                        style: Constants.subtitleHint,
                      ),
                      const SizedBox(
                        height: 10,
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

double processWidth(double value) {
  if (value <= 500) return value;

  return value * 0.48;
}
