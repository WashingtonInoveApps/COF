import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ItensSectionWidget extends StatefulWidget {
  final ItemModel? item;
  final Function(ItemModel) onChange;
  const ItensSectionWidget({Key? key, this.item, required this.onChange})
      : super(key: key);

  @override
  State<ItensSectionWidget> createState() => _ItensSectionWidgetState();
}

class _ItensSectionWidgetState extends State<ItensSectionWidget> {
  final formKEY = GlobalKey<FormState>();
  final controllerText = TextEditingController();
  final controllerQuantity = TextEditingController();

  final uid = const Uuid();

  @override
  void dispose() {
    super.dispose();
    controllerText.dispose();
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
          child: Form(
            key: formKEY,
            child: Column(
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldText(
                  controller: controllerText,
                  hint: 'Ex: Búzina, Mangueira',
                  label: 'Item',
                  upper: true,
                  validation: Validation.validatorPreenchimento,
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
                        if (formKEY.currentState!.validate()) {
                          widget.onChange(ItemModel(
                              id: uid.v4(),
                              description: controllerText.text,
                              quantity: int.parse(controllerQuantity.text)));
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "Adicionar",
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
