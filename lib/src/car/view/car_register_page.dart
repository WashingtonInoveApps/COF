import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../controller/car_controller.dart';
import 'widgets/itens_section_widget.dart';
import 'widgets/section_widget.dart';

class CarRegisterPage extends StatefulWidget {
  final CarModel? car;
  const CarRegisterPage({Key? key, this.car}) : super(key: key);

  @override
  State createState() => _CarRegisterPageState();
}

class _CarRegisterPageState extends State<CarRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late CarModel car;
  late CarController controller;

  final _key = GlobalKey<FormState>();
  final carTypeController = TextEditingController();

  final maskReference = MaskTextInputFormatter(
      mask: '###/## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskCard = MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    controller = CarController(app: app);
    controller.cleanSectionsItens();
    controller.cleanSectionsMaterials();

    controller.setOBM(app.obms.firstWhere((e) => e.id == app.user.obmID));

    if (widget.car != null) {
      controller.setTypeCar(widget.car?.type);
      controller.setFunctionCar(widget.car?.function);
      controller.cleanSectionsItens();
      controller.cleanSectionsMaterials();

      car = CarModel.copy(widget.car!);
      for (final itens in car.itens) {
        controller.addSectionsItens(itens.copyWith(value: false));
      }

      for (final itens in car.materials) {
        controller.addSectionsMaterials(itens.copyWith(value: false));
      }

      controller.onChangesCar(widget.car?.changes ?? []);
    } else {
      car = CarModel(
          images: [],
          itens: [],
          materials: [],
          changes: [],
          status: [],
          mapas: [],
          function: Constants.carsFunctions.first,
          type: app.carsTypes.first);

      controller.setTypeCar(app.carsTypes.first);
      controller.setFunctionCar(Constants.carsFunctions.first);
    }
  }

  @override
  void dispose() {
    super.dispose();
    carTypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(app.carsTypes.join(';'));
    return Stack(
      children: [
        Form(
          key: _key,
          child: BackgraundPage(
            menu: (widget.car == null),
            onBack:
                (widget.car == null) ? null : () => Navigator.of(context).pop(),
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registro de veículo',
                  style: Constants.title.copyWith(fontSize: 18),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            childLeft: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ORGANIZAÇÃO",
                  style: Constants.subtitleHint,
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
                      ignoring: !app.user.adminFull,
                      child: DropdownButton<OBMModel>(
                          isExpanded: true,
                          value: controller.obm,
                          underline: Container(),
                          onChanged: controller.setOBM,
                          items: app.obms
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
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
                              .toList()),
                    );
                  }),
                ),
                Observer(builder: (context) {
                  return Visibility(
                      visible: (controller.cia != null),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COMPANHIA",
                            style: Constants.subtitleHint,
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
                            child: DropdownButton<String?>(
                                isExpanded: true,
                                value: controller.cia,
                                underline: Container(),
                                onChanged: controller.setCia,
                                items: controller.obm.cias
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(e.toUpperCase(),
                                                style: Constants.title),
                                          ),
                                        ))
                                    .toList()),
                          ),
                        ],
                      ));
                }),
                Text(
                  "PREFIXO",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.prefix,
                  hint: "EX.: RESGATE 32",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.prefix = value ?? car.prefix,
                  upper: true,
                ),
                Text(
                  "MODELO",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.model,
                  hint: "EX.: RENAULT MASTER 2.3 2010",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.model = value ?? car.model,
                  upper: true,
                ),
                Text(
                  "PLACA",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.plate,
                  hint: "EX.: XXX2X45",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.plate = value ?? car.plate,
                  upper: true,
                ),
                Text(
                  "KM INICIAL",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.km.toString(),
                  hint: "EX.: 1234567",
                  inputType: TextInputType.number,
                  validation: Validation.validatorNumber,
                  onSaved: (value) => car.km = int.parse(value!),
                ),
                Text(
                  "MODELO DO PNEU",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.modelPneu,
                  hint: "EX.: 202/75 15",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.modelPneu = value ?? car.modelPneu,
                  upper: true,
                  mask: [maskReference],
                ),
                Text(
                  "NÚMERO DO CARTÃO",
                  style: Constants.subtitleHint,
                ),
                FieldText(
                  initValue: car.ticket,
                  hint: "EX.: 0000 0000 0000 0000",
                  inputType: TextInputType.number,
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.ticket = value ?? car.ticket,
                  mask: [maskCard],
                ),
              ],
            ),
            childRight: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ITENS",
                  style: Constants.subtitleHint,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Observer(builder: (context) {
                  return controller.sectionsItens.isEmpty
                      ? Text(
                          'Nenhum itens do checklist encontrado.',
                          style: Constants.title,
                        )
                      : Column(
                          children: List.generate(
                              controller.sectionsItens.length, (index) {
                            final section = controller.sectionsItens[index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          section.description,
                                          style: Constants.title,
                                        )),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: 'Atenção',
                                                    message:
                                                        'Deseja excluir essa categoria de itens ?',
                                                    cancel: true,
                                                    titleOK: 'Sim',
                                                    onPressedCancel: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    onPressedOK: () =>
                                                        Navigator.of(context)
                                                            .pop(true))).then(
                                                (value) {
                                              if (value ?? false) {
                                                controller
                                                    .removeSectionsItens(index);
                                              }
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: const Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                      child: SectionWidget(
                                                        section: section,
                                                        onChange: (value) {
                                                          controller
                                                              .editSectionsItens(
                                                                  index, value);
                                                        },
                                                      ),
                                                    ));
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: const Icon(
                                              Icons.edit,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .expansionSectionsItens(index),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: Icon(
                                              section.value
                                                  ? Icons
                                                      .keyboard_arrow_up_outlined
                                                  : Icons
                                                      .keyboard_arrow_down_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                        visible: section.value,
                                        child: SizedBox(
                                          height: 300,
                                          child: changesListWidget(
                                              section: section,
                                              context: context,
                                              onDelete: (value) =>
                                                  controller.removeSectionItens(
                                                      index, value),
                                              onAdd: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Center(
                                                          child:
                                                              ItensSectionWidget(
                                                            onChange: (value) {
                                                              controller
                                                                  .addSectionItens(
                                                                      index,
                                                                      value);
                                                            },
                                                          ),
                                                        ));
                                              }),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                }),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: SectionWidget(
                                    onChange: (value) {
                                      controller.addSectionsItens(value);
                                    },
                                  ),
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
                Text(
                  "MATERIAIS",
                  style: Constants.subtitleHint,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                Observer(builder: (context) {
                  return controller.sectionsMaterials.isEmpty
                      ? Text(
                          'Nenhum material encontrado.',
                          style: Constants.title,
                        )
                      : Column(
                          children: List.generate(
                              controller.sectionsMaterials.length, (index) {
                            final section = controller.sectionsMaterials[index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Row(
                                      spacing: 5,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          section.description,
                                          style: Constants.title,
                                        )),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: 'Atenção',
                                                    message:
                                                        'Deseja excluir essa categoria de itens ?',
                                                    cancel: true,
                                                    titleOK: 'Sim',
                                                    onPressedCancel: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    onPressedOK: () =>
                                                        Navigator.of(context)
                                                            .pop(true))).then(
                                                (value) {
                                              if (value ?? false) {
                                                controller
                                                    .removeSectionsMaterials(
                                                        index);
                                              }
                                            });
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: const Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                      child: SectionWidget(
                                                        section: section,
                                                        onChange: (value) {
                                                          controller
                                                              .editSectionsMaterials(
                                                                  index, value);
                                                        },
                                                      ),
                                                    ));
                                          },
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: const Icon(
                                              Icons.edit,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => controller
                                              .expansionSectionsMaterials(
                                                  index),
                                          child: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Constants.primary,
                                            child: Icon(
                                              section.value
                                                  ? Icons
                                                      .keyboard_arrow_up_outlined
                                                  : Icons
                                                      .keyboard_arrow_down_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                        visible: section.value,
                                        child: SizedBox(
                                          height: 300,
                                          child: changesListWidget(
                                              section: section,
                                              context: context,
                                              onDelete: (value) => controller
                                                  .removeSectionMaterials(
                                                      index, value),
                                              onAdd: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        Center(
                                                          child:
                                                              ItensSectionWidget(
                                                            onChange: (value) {
                                                              controller
                                                                  .addSectionMaterials(
                                                                      index,
                                                                      value);
                                                            },
                                                          ),
                                                        ));
                                              }),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                }),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Center(
                                  child: SectionWidget(
                                    onChange: (value) {
                                      controller.addSectionsMaterials(value);
                                    },
                                  ),
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
                Text(
                  "FUNÇÃO",
                  style: Constants.subtitleHint,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
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
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: controller.function,
                        underline: Container(),
                        onChanged: (value) {
                          controller.setFunctionCar(value);

                          FocusScope.of(context).unfocus();
                        },
                        items: Constants.carsFunctions
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(e.toUpperCase(),
                                        style: Constants.title),
                                  ),
                                ))
                            .toList());
                  }),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "TIPO DE VEÍCULO",
                  style: Constants.subtitleHint,
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
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
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: controller.type,
                        underline: Container(),
                        onChanged: (value) {
                          controller.setTypeCar(value);
                          carTypeController.text = '';

                          FocusScope.of(context).unfocus();
                        },
                        items: app.carsTypes
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(e.toUpperCase(),
                                        style: Constants.title),
                                  ),
                                ))
                            .toList());
                  }),
                ),
                Observer(builder: (_) {
                  return controller.fieldCarTypeVisible
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: FieldText(
                            controller: carTypeController,
                            hint: "TIPO DE VEÍCULO",
                            validation: Validation.validatorPreenchimento,
                          ),
                        )
                      : Container();
                }),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Observer(builder: (_) {
                    final resultCar = car.copyWith(
                        changes: controller.carChanges
                            .toList()); //toList() para vê as mudanças

                    return CarChangesWidget(
                      car: resultCar,
                      remove: true,
                      register: true,
                      user: app.user,
                      update: true,
                      onChange: controller.onChangesCar,
                      onChangeImages: (value) {
                        images
                          ..clear()
                          ..addAll(value);
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 45.0,
                    width: 150.0,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState?.validate() ?? false) {
                            _key.currentState!.save();

                            car.type = controller.type;
                            car.function = controller.function;
                            car.adm = controller.adm;
                            car.changes = controller.carChanges;
                            car.obmID = controller.obm.id ?? '';
                            car.cia = (controller.cia?.toLowerCase()) ??
                                (controller.obm.id ?? '');
                            car.itens = controller.sectionsItens;
                            car.materials = controller.sectionsMaterials;

                            if (carTypeController.text.isNotEmpty) {
                              car.type = carTypeController.text;
                            }

                            controller
                                .save(car: car, images: images)
                                .then((value) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      title: "Atenção",
                                      message:
                                          "Cadastro realizado com sucesso.",
                                      onPressedOK: () =>
                                          Navigator.of(context).pop()));

                              if (value) {
                                Navigator.of(context).pop();
                              }
                            }).catchError((err) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      title: "Atenção",
                                      message: err.toString(),
                                      onPressedOK: () =>
                                          Navigator.of(context).pop()));
                            });
                          }
                        },
                        child: Text(
                          (widget.car == null) ? "SALVAR" : "ALTERAR",
                          style: Constants.titleButton,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
        Observer(builder: (_) {
          return IgnorePointer(
            ignoring: !controller.loading,
            child: Container(
              color: controller.loading ? Colors.black54 : Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    controller.loading ? Colors.white : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}

Widget changesListWidget(
        {required ItensChangesModel section,
        required BuildContext context,
        required Function(int i) onDelete,
        required Function() onAdd}) =>
    Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  section.itens.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    section.itens[index].description,
                                    style: Constants.subtitle,
                                  ),
                                  (section.itens[index].quantity > 1)
                                      ? Text(
                                          '${section.itens[index].quantity} unids.',
                                          style: Constants.subtitleHint,
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            InkWell(
                              child: const Icon(
                                Icons.remove,
                                color: Colors.grey,
                                size: 20,
                              ),
                              onTap: () => onDelete(index),
                            )
                          ],
                        ),
                      )),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: InkWell(
            onTap: onAdd,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Constants.primary,
              child: const Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
