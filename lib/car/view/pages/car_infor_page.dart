import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/cia_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/validation.dart';
import '../../../widgets/textfield_widget.dart';

class CarRegisterInforPage extends StatefulWidget {
  final CarRegisterController controller;
  const CarRegisterInforPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<CarRegisterInforPage> createState() => _CarRegisterInforPageState();
}

class _CarRegisterInforPageState extends State<CarRegisterInforPage> {
  late CarRegisterController register;

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
              "INFORMAÇÕES BÁSICAS",
              style: Constants.titleButton,
            ),
          ),
          Text(
            "ORGANIZAÇÃO",
            style: Constants.titleHint,
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0)),
            child: Observer(builder: (_) {
              return IgnorePointer(
                ignoring: true,
                child: DropdownButton<OBMModel>(
                    isExpanded: true,
                    value: register.obm,
                    underline: Container(),
                    onChanged: register.setOBM,
                    items: [
                      DropdownMenuItem(
                          value: null,
                          child: Text(
                            'Selecione',
                            style: Constants.title,
                          )),
                      ...register.obms
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e.prefix,
                                        style: Constants.title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        e.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Constants.subtitle
                                            .copyWith(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ]),
              );
            }),
          ),
          Observer(builder: (context) {
            return (register.obm?.cias.isNotEmpty ?? false)
                ? Column(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COMPANHIA",
                        style: Constants.titleHint,
                      ),
                      Container(
                        height: 50.0,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)),
                        child: DropdownButton<CiaModel?>(
                            isExpanded: true,
                            value: register.cia,
                            underline: Container(),
                            onChanged: register.setCia,
                            items: [
                              DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    'Selecione',
                                    style: Constants.title,
                                  )),
                              ...register.obm?.cias
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Text(e.name.toUpperCase(),
                                                  style: Constants.title),
                                            ),
                                          ))
                                      .toList() ??
                                  [],
                            ]),
                      ),
                    ],
                  )
                : Container();
          }),
          Text(
            "PREFIXO",
            style: Constants.titleHint,
          ),
          FieldText(
            initValue: register.prefix,
            hint: "EX.: RESGATE 32",
            validation: Validation.validatorPreenchimento,
            onChange: register.setPrefix,
            upper: true,
          ),
        ],
      ),
    );
  }
}
