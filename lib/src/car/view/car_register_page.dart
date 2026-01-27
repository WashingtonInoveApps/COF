import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

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
  late CarModel car;
  late CarController controller;

  final _key = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final app = GetIt.I.get<AppController>();

  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();
    controller = CarController(app: app);
    controller.cleanSections();

    if (widget.car != null) {
      controller.setTypeCar(widget.car?.typeCar);
      controller.cleanSections();

      car = CarModel.copy(widget.car!);
      for (final itens in car.itens) {
        controller.addSections(itens.copyWith(value: false));
      }

      controller.onChangesCar(widget.car?.changes ?? []);
    } else {
      car = CarModel(
          images: [],
          itens: [],
          changes: [],
          status: [],
          mapas: [],
          typeCar: Core.carsType.first);

      controller.setTypeCar(Core.carsType.first);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        'assets/cbmcecabecalho2.png',
                        fit: BoxFit.fitHeight,
                        height: 70,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Registro de veículo',
                    style: Core.title.copyWith(fontSize: 18),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _key,
                    child: LayoutBuilder(
                      builder: (context, constrained) {
                        double width = constrained.maxWidth > 500
                            ? constrained.maxWidth * 0.48
                            : constrained.maxWidth;

                        return SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PREFIXO",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.prefix,
                                      hint: "EX.: RESGATE 32",
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: (value) =>
                                          car.prefix = value ?? car.prefix,
                                      upper: true,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "MODELO",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.model,
                                      hint: "EX.: RENAULT MASTER 2.3 2010",
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: (value) =>
                                          car.model = value ?? car.model,
                                      upper: true,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "PLACA",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.plate,
                                      hint: "EX.: XXX2X45",
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: (value) =>
                                          car.plate = value ?? car.plate,
                                      upper: true,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "KM INICIAL",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.km.toString(),
                                      hint: "EX.: 1234567",
                                      inputType: TextInputType.number,
                                      validation: Validation.validatorNumber,
                                      onSaved: (value) =>
                                          car.km = int.parse(value!),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "MODELO DO PNEU",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.modelPneu,
                                      hint: "EX.: 202/75 15",
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: (value) => car.modelPneu =
                                          value ?? car.modelPneu,
                                      upper: true,
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      "NÚMERO DO CARTÃO",
                                      style: Core.subtitleHint,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    FieldText(
                                      initValue: car.ticket,
                                      hint: "EX.: 0000 0000 0000 0000",
                                      inputType: TextInputType.number,
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: (value) =>
                                          car.ticket = value ?? car.ticket,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ITENS",
                                      style: Core.subtitleHint,
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Observer(builder: (context) {
                                      return controller.sectionsItens.isEmpty
                                          ? Text(
                                              'Nenhum itens do checklist encontrado.',
                                              style: Core.title,
                                            )
                                          : Column(
                                              children: List.generate(
                                                  controller.sectionsItens
                                                      .length, (index) {
                                                final section = controller
                                                    .sectionsItens[index];

                                                return Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          spacing: 5,
                                                          children: [
                                                            Expanded(
                                                                child: Text(
                                                              section
                                                                  .description,
                                                              style: Core.title,
                                                            )),
                                                            InkWell(
                                                              onTap: () => controller
                                                                  .removeSections(
                                                                      index),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor:
                                                                    Core.primary,
                                                                child:
                                                                    const Icon(
                                                                  Icons.remove,
                                                                  size: 15,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            Center(
                                                                              child: SectionWidget(
                                                                                section: section,
                                                                                onChange: (value) {
                                                                                  controller.editSections(index, value);
                                                                                },
                                                                              ),
                                                                            ));
                                                              },
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor:
                                                                    Core.primary,
                                                                child:
                                                                    const Icon(
                                                                  Icons.edit,
                                                                  size: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () => controller
                                                                  .expansionSections(
                                                                      index),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 12,
                                                                backgroundColor:
                                                                    Core.primary,
                                                                child: Icon(
                                                                  section.value
                                                                      ? Icons
                                                                          .keyboard_arrow_up_outlined
                                                                      : Icons
                                                                          .keyboard_arrow_down_outlined,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Visibility(
                                                            visible:
                                                                section.value,
                                                            child: SizedBox(
                                                              height: 300,
                                                              child:
                                                                  changesListWidget(
                                                                      section:
                                                                          section,
                                                                      context:
                                                                          context,
                                                                      onDelete: (value) => controller.removeItensSection(
                                                                          index,
                                                                          value),
                                                                      onAdd:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                Center(
                                                                                  child: ItensSectionWidget(
                                                                                    onChange: (value) {
                                                                                      controller.addItensSection(index, value);
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
                                                          controller
                                                              .addSections(
                                                                  value);
                                                        },
                                                      ),
                                                    ));
                                          },
                                          style: IconButton.styleFrom(
                                              backgroundColor: Core.primary),
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "TIPO DE VEÍCULO",
                                      style: Core.subtitleHint,
                                    ),
                                    const Divider(),
                                    Card(
                                      margin: EdgeInsets.zero,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Observer(builder: (_) {
                                          return DropdownButton<String>(
                                              value: controller.typeCar,
                                              onChanged: (value) {
                                                controller.setTypeCar(value);

                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              underline: Container(),
                                              isExpanded: true,
                                              items: List.generate(
                                                  Core.carsType.length,
                                                  (index) =>
                                                      DropdownMenuItem<String>(
                                                        value: Core
                                                            .carsType[index],
                                                        child: Text(
                                                          Core.carsType[index],
                                                          style: Core.subtitle,
                                                        ),
                                                      )));
                                        }),
                                      ),
                                    ),
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
                                              if (_key.currentState!
                                                  .validate()) {
                                                _key.currentState!.save();

                                                car.typeCar =
                                                    controller.typeCar;
                                                car.adm = controller.adm;
                                                car.changes =
                                                    controller.carChanges;
                                                car.obm = app.user.obm;
                                                car.itens =
                                                    controller.sectionsItens;

                                                controller
                                                    .saveCar(
                                                        car: car,
                                                        images: images)
                                                    .then((value) async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              title: "Atenção",
                                                              message:
                                                                  "Cadastro realizado com sucesso.",
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));

                                                  if (value) {
                                                    Navigator.of(context).pop();
                                                  }
                                                }).catchError((err) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              title: "Atenção",
                                                              message: err
                                                                  .toString(),
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                });
                                              }
                                            },
                                            child: Text(
                                              "SALVAR",
                                              style: Core.titleButton,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
      ),
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
                              child: Text(
                                section.itens[index].description,
                                style: Core.subtitle,
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
              backgroundColor: Core.primary,
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
