import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/src/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/src/checklist/view/widget/fuel_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/validation.dart';

class ChecklistCarPage extends StatefulWidget {
  final CheckListController controller;
  const ChecklistCarPage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ChecklistCarPage> createState() => _ChecklistCarPageState();
}

class _ChecklistCarPageState extends State<ChecklistCarPage> {
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
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(text: "PREFIXO", children: [
                    TextSpan(
                        text: ' *',
                        style: Constants.title.copyWith(color: Colors.red))
                  ]),
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 5,
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
                    final prefixs = List<String>.from(
                        controller.cars.map((e) => e.prefix).toList()
                          ..add('SELECIONE'));

                    return DropdownButton<String>(
                        isExpanded: true,
                        value: controller.prefix,
                        underline: Container(),
                        onChanged: controller.setPrefix,
                        items: prefixs
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      e,
                                      style: Constants.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList());
                  }),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text.rich(
                  TextSpan(text: "KM INICIAL", children: [
                    TextSpan(
                        text: ' *',
                        style: Constants.title.copyWith(color: Colors.red))
                  ]),
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                FieldText(
                    initValue: controller.startKM,
                    hint: "EX.: 123456",
                    validation: Validation.validatorNumber,
                    inputType: TextInputType.number,
                    onChange: controller.setKMStart),
                const SizedBox(
                  height: 10.0,
                ),
                Text.rich(
                  TextSpan(text: "NÍVEL DE COMBUSTÍVEL", children: [
                    TextSpan(
                        text: ' *',
                        style: Constants.title.copyWith(color: Colors.red))
                  ]),
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Observer(builder: (_) {
                    return FuelWidget(
                        fuel: controller.fuel, onChange: controller.setFuel);
                  }),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text.rich(
                  TextSpan(text: "NÍVEIS DE FLUÍDOS", children: [
                    TextSpan(
                        text: ' *',
                        style: Constants.title.copyWith(color: Colors.red))
                  ]),
                  style: Constants.subtitleHint,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Observer(
                      builder: (context) => FluidsWidget(
                          oil: controller.oil,
                          hidra: controller.hidra,
                          fr: controller.fr,
                          arref: controller.arref,
                          onOil: controller.setOil,
                          onHidra: controller.setHidra,
                          onFr: controller.setFR,
                          onArref: controller.setArref)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Observer(builder: (_) {
                    return (controller.car == null)
                        ? Container()
                        : CarChangesWidget(
                            checklistId: controller.id,
                            car: controller.car!,
                            user: controller.app.user,
                            onChange: controller.addCarChanges,
                          );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "OBSERVAÇÕES",
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 5,
                ),
                FieldText(
                  initValue: controller.obs,
                  hint: "EX.: Alguma informação importante",
                  onChange: controller.setOBS,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
