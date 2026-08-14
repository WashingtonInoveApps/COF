import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'textfield_widget.dart';

class SectionWidget extends StatefulWidget {
  final SectionItensModel? section;
  final Function(SectionItensModel) onChange;
  const SectionWidget({Key? key, this.section, required this.onChange})
      : super(key: key);

  @override
  State<SectionWidget> createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  final formKEY = GlobalKey<FormState>();
  final controllerText = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.section != null) {
      controllerText.text = widget.section?.description ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
        ),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: formKEY,
              child: FieldText(
                controller: controllerText,
                hint: 'Ex: EQUIPAMENTOS',
                label: 'Seção',
                textCase: FieldTextCase.upper,
                validation: Validation.validatorPreenchimento,
              ),
            ),
            SizedBox(
              height: 45.0,
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    if (formKEY.currentState!.validate()) {
                      widget.onChange(SectionItensModel(
                          id: widget.section?.id ?? const Uuid().v4(),
                          description: controllerText.text,
                          itens: []));
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    (widget.section == null) ? "Adicionar" : "Alterar",
                    style: Constants.titleButton,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
