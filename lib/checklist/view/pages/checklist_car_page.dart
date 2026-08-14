import 'package:bsu_control/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/checklist/view/widget/fuel_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/validation.dart';
import '../../../model/outher_changes_model.dart';
import '../../../widgets/car_changes_widget.dart';
import '../../../widgets/card_outhers_widget.dart';
import '../../../widgets/image_change_widget.dart';
import '../../../widgets/textfield_widget.dart';

class ChecklistCarPage extends StatelessWidget {
  final UserModel user;
  final double width;
  final CheckListController controller;
  const ChecklistCarPage(
      {Key? key,
      required this.controller,
      required this.user,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Constants.primary, borderRadius: BorderRadius.circular(5)),
          child: Text(
            'INFORMAÇÕES DO VEÍCULO',
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
            children: [
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          ignoring: controller.update,
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.prefix,
                              underline: Container(),
                              onChanged: controller.setPrefix,
                              items: controller.prefixs
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
                                  .toList()),
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
                        initValue: controller.startKM.toString(),
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
                            fuel: controller.fuel,
                            onChange: controller.setFuel);
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
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Observer(builder: (_) {
                        return (controller.car == null)
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: CarChangesWidget(
                                  remove: true,
                                  checklistID: controller.id,
                                  car: controller.car!,
                                  user: user,
                                  onChange: controller.addCarChanges,
                                ),
                              );
                      }),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.primary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'OUTRAS ALTERAÇÕES',
                        style: Constants.titleButton,
                      ),
                    ),
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
                              children: List.generate(controller.others.length,
                                      (index) {
                                final outher = controller.others[index];

                                return CardOutherChange(
                                  outher: outher,
                                  onDelete: () {
                                    controller.deleteOuhtersChange(index);
                                  },
                                );
                              })
                                  .expand((widget) => [widget, const Divider()])
                                  .toList()
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
                                      onSelect: (image, description) {
                                        controller
                                            .addOthersChange(OtherChangeModel(
                                          date: DateTime.now(),
                                          description: description,
                                          fileImage: image,
                                        ));
                                      },
                                    ));
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Constants.primary),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
