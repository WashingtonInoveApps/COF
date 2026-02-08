import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/src/checklist/view/widget/checklist_item_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class ChecklistMaterialsPage extends StatefulWidget {
  final CheckListController controller;
  const ChecklistMaterialsPage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ChecklistMaterialsPage> createState() => _ChecklistMaterialsPageState();
}

class _ChecklistMaterialsPageState extends State<ChecklistMaterialsPage> {
  late CheckListController controller;
  late ReactionDisposer _dispose;

  double width = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    width = processWidth(controller.app.maxWidth);

    _dispose = reaction<double>((_) => controller.app.maxWidth, (value) {
      setState(() {
        width = processWidth(value);
      });
    });
  }

  double processWidth(double value) {
    if (value <= 500) return value;

    return value * 0.48;
  }

  @override
  void dispose() {
    super.dispose();
    _dispose.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Observer(builder: (context) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Constants.primary,
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                'MATERIAIS',
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
                children: List.generate(controller.car!.materials.length,
                    (indexCategory) {
                  final category = controller.car!.materials[indexCategory];
                  return Container(
                    width: width,
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
                            final itemChange = controller
                                .materials[indexCategory].itens[indexItem];

                            return ChacklistItemWidget(
                              item: item,
                              init: itemChange,
                              onChange: (value) {
                                controller.changeMaterials(
                                    value.copyWith(
                                        quantity: item.quantity,
                                        quantityMarked: value.quantity),
                                    indexCategory,
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
                          initValue: controller.materials[indexCategory].obs,
                          hint: "EX.: Alguma informação importante",
                          onChange: (text) {
                            controller.changeOBSMaterials(text, indexCategory);
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
