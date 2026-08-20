import 'package:bsu_control/checklist/controller/checklist_register_controller.dart';
import 'package:bsu_control/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/checklist/view/widget/fuel_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/validation.dart';
import '../../../widgets/car_changes_widget.dart';
import '../../../widgets/container_custom_widget.dart';
import '../../../widgets/textfield_widget.dart';

class ChecklistCarPage extends StatefulWidget {
  final UserModel user;
  final ChecklistRegisterController controller;

  const ChecklistCarPage({
    Key? key,
    required this.controller,
    required this.user,
  }) : super(key: key);

  @override
  State<ChecklistCarPage> createState() => _ChecklistCarPageState();
}

class _ChecklistCarPageState extends State<ChecklistCarPage> {
  late ChecklistRegisterController register;

  @override
  void initState() {
    super.initState();
    register = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        children: [
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ContainerCustom(label: 'INFORMAÇÕES DO VEÍCULO'),
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
                    return IgnorePointer(
                      ignoring: widget.controller.update,
                      child: DropdownButton<CarModel?>(
                          isExpanded: true,
                          value: register.car,
                          underline: Container(),
                          onChanged: register.setCar,
                          items: [
                            DropdownMenuItem(
                                value: null,
                                child: Text(
                                  'Selecione',
                                  style: Constants.title,
                                )),
                            ...register.carsValidations
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(
                                          e.prefix,
                                          style: Constants.title,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ))
                                .toList()
                          ]),
                    );
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
                    initValue: register.startKM.toString(),
                    hint: "EX.: 123456",
                    validation: Validation.validatorNumber,
                    inputType: TextInputType.number,
                    onChange: register.setKMStart),
                const SizedBox(
                  height: 15.0,
                ),
                const ContainerCustom(label: 'FLUÍDOS'),
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
                  height: 5.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Observer(builder: (_) {
                    return FuelWidget(
                        fuel: register.fuel, onChange: register.setFuel);
                  }),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text.rich(
                  TextSpan(text: "NÍVEIS DE FLUÍDOS", children: [
                    TextSpan(
                        text: ' *',
                        style: Constants.title.copyWith(color: Colors.red))
                  ]),
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Observer(
                      builder: (context) => FluidsWidget(
                          oil: register.oil,
                          hidra: register.hidra,
                          fr: register.fr,
                          arref: register.arref,
                          onOil: register.setOil,
                          onHidra: register.setHidra,
                          onFr: register.setFR,
                          onArref: register.setArref)),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Observer(builder: (_) {
                    return (register.car == null)
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const ContainerCustom(label: 'ALTERAÇÕES'),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CarChangesWidget(
                                  remove: true,
                                  checklistID: register.id,
                                  car: register.car!,
                                  user: widget.user,
                                  changes: List<CarChangeModel>.from(
                                      register.changes),
                                  onChange: register.addCarChanges,
                                ),
                              ),
                            ],
                          );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
