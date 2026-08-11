import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              "INFORMAÇÕES DO VEÍCULO",
              style: Constants.titleButton,
            ),
          ),
          Text(
            "MODELO",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.model,
            hint: "EX.: RENAULT MASTER 2.3 2010",
            onChange: register.setModel,
            upper: true,
          ),
          Text(
            "PLACA",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.plate,
            hint: "EX.: XXX2X45",
            onChange: register.setPlate,
            upper: true,
          ),
          Text(
            "KM INICIAL",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.km.toString(),
            hint: "EX.: 1234567",
            inputType: TextInputType.number,
            onChange: register.setKM,
          ),
          Text(
            "MODELO DO PNEU",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.modelPneu,
            hint: "EX.: 202/75 15",
            inputType: TextInputType.number,
            onChange: register.setModelPneu,
            upper: true,
            mask: [maskReference],
          ),
          Text(
            "NÚMERO DO CARTÃO",
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
