import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:uuid/uuid.dart';

import '../../../model/outher_changes_model.dart';
import '../../../widgets/card_outhers_widget.dart';
import '../../../widgets/container_custom_widget.dart';
import '../../../widgets/image_change_widget.dart';
import '../../controller/checklist_register_controller.dart';

class CheckListOthersPage extends StatefulWidget {
  final UserModel user;

  final ChecklistRegisterController controller;

  const CheckListOthersPage({
    Key? key,
    required this.controller,
    required this.user,
  }) : super(key: key);

  @override
  State<CheckListOthersPage> createState() => _CheckListOthersPageState();
}

class _CheckListOthersPageState extends State<CheckListOthersPage> {
  late ChecklistRegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const ContainerCustom(label: 'OUTRAS ALTERAÇÕES'),
          const SizedBox(
            height: 10,
          ),
          Observer(builder: (context) {
            return controller.others.isEmpty
                ? Text(
                    'Nenhuma outra alteração encontrada',
                    style: Constants.titleHint,
                  )
                : Column(
                    children: List.generate(controller.others.length, (index) {
                      final other = controller.others[index];

                      return CardOutherChange(
                        other: other,
                        onDelete: () {
                          controller.deleteOuhtersChange(index);
                        },
                      );
                    }).expand((widget) => [widget, const Divider()]).toList()
                      ..removeLast(),
                  );
          }),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: IconButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (context) => ImageChangeWidget(
                            aspectRatio: null,
                            onSelect: (image, description) {
                              controller.addOthersChange(
                                OtherChangeModel(
                                  id: const Uuid().v4(),
                                  date: DateTime.now(),
                                  description: description,
                                  image: image,
                                  user: widget.user,
                                ),
                              );
                            },
                          ));
                },
                style: IconButton.styleFrom(backgroundColor: Constants.primary),
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                )),
          ),
          const SizedBox(
            height: 20,
          ),
          const ContainerCustom(label: 'OBSERVAÇÕES IMPORTANTES'),
          const SizedBox(
            height: 10,
          ),
          FieldText(
            initValue: controller.obs,
            hint: 'Observações importantes',
            onChange: controller.setOBS,
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
