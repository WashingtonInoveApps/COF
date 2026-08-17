import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../widgets/container_custom_widget.dart';
import '../../../widgets/textfield_widget.dart';

class CarRegisterDetailsPage extends StatefulWidget {
  final CarRegisterController controller;
  const CarRegisterDetailsPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CarRegisterDetailsPage> createState() => _CarRegisterDetailsPageState();
}

class _CarRegisterDetailsPageState extends State<CarRegisterDetailsPage> {
  late CarRegisterController register;

  final maskReference = MaskTextInputFormatter(
      mask: '###/## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskCard = MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    register = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ContainerCustom(
            label: "INFORMAÇÕES DO VEÍCULO",
          ),
          Text(
            "Modelo",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.model,
            hint: "EX.: RENAULT MASTER 2.3 2010",
            onChange: register.setModel,
            textCase: FieldTextCase.upper,
          ),
          Text(
            "Placa",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.plate,
            hint: "EX.: XXX2X45",
            onChange: register.setPlate,
            textCase: FieldTextCase.upper,
          ),
          Text(
            "KM Inicial",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.km.toString(),
            hint: "EX.: 1234567",
            inputType: TextInputType.number,
            onChange: register.setKM,
          ),
          Text(
            "Modelo de Pneu",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.modelPneu,
            hint: "EX.: 202/75 15",
            inputType: TextInputType.number,
            onChange: register.setModelPneu,
            textCase: FieldTextCase.upper,
            mask: [maskReference],
          ),
          Text(
            "Número do Cartão",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.ticket,
            hint: "EX.: 0000 0000 0000 0000",
            inputType: TextInputType.number,
            onChange: register.setTicket,
            mask: [maskCard],
          ),
        ],
      ),
    );
  }
}
