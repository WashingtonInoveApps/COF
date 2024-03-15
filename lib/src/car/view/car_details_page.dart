import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/car/repository/car_repository.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';

import 'car_register_page.dart';

class CarDetailsPage extends StatefulWidget {
  final String carId;
  const CarDetailsPage({Key? key, required this.carId}) : super(key: key);

  @override
  State createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late CarModel car;
  late ReactionDisposer rec;
  late CarController controller;

  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();
  final app = GetIt.I.get<AppController>();

  @override
  void initState() {
    super.initState();
    controller = CarController(app: app, repository: CarRepository());

    rec = autorun((_) {
      setState(() {
        car = app.cars.firstWhere((e) => e.id == widget.carId);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec.reaction.dispose();
    _controller.dispose();
  }

  kmChangeWidget({required Function(int value) onUpdate}) => Form(
        key: _key,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(6),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldText(
                controller: _controller,
                hint: "QUILÔMETRAGEM",
                validation: Validation.validatorNumber,
                inputType: TextInputType.number,
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          Navigator.of(context).pop();

                          onUpdate(int.parse(_controller.text));
                        }
                      },
                      child: Text("ALTERAR", style: titleButton)))
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(
            titlePage: 'DETALHES DO VEÍCULO',
          ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      double width = constrains.maxWidth > 500
                          ? 500.0
                          : constrains.maxWidth;

                      return Center(
                        child: Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            car.prefix,
                                            style: title.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Placa",
                                                style: titleHint,
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(car.plate,
                                                  style: title.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                "KM",
                                                style: titleHint,
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(car.km.toString(),
                                                  style: title.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      )),
                                      controller.enable
                                          ? TextButton.icon(
                                              style: TextButton.styleFrom(
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .primaryColor)),
                                              onPressed: () async {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            CarRegisterPage(
                                                              car: car,
                                                            )));
                                              },
                                              icon: Icon(
                                                MdiIcons.bookEdit,
                                                size: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              label: Text(
                                                "Editar",
                                                style: title.copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ))
                                          : Container(),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      controller.enable
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      side: BorderSide(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)),
                                                  onPressed: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                kmChangeWidget(
                                                                  onUpdate:
                                                                      (value) async {
                                                                    await controller.updateKMOil(
                                                                        id: car
                                                                            .id!,
                                                                        value:
                                                                            value);
                                                                    _controller
                                                                        .clear();
                                                                  },
                                                                ));
                                                  },
                                                  child: Text(
                                                    "Alterar",
                                                    style: title.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            )
                                          : Container(),
                                      Expanded(
                                          child: Text(
                                        "TROCA DE ÓLEO (KM)",
                                        style: subtitleHint,
                                      )),
                                      Text(
                                        car.oil.toString(),
                                        style: title.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      controller.enable
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10.0),
                                              child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      side: BorderSide(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor)),
                                                  onPressed: () async {
                                                    await showDialog(
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                kmChangeWidget(
                                                                  onUpdate:
                                                                      (value) async {
                                                                    await controller.updateKMArref(
                                                                        id: car
                                                                            .id!,
                                                                        value:
                                                                            value);
                                                                    _controller
                                                                        .clear();
                                                                  },
                                                                ));
                                                  },
                                                  child: Text(
                                                    "Alterar",
                                                    style: title.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                            )
                                          : Container(),
                                      Expanded(
                                          child: Text(
                                        "ARREFECIMENTO (KM)",
                                        style: subtitleHint,
                                      )),
                                      Text(
                                        car.arref.toString(),
                                        style: title.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  CarChangesWidget(
                                    add: false,
                                    initValue: car.changes,
                                    user: app.user,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "INFORMAÇÕES",
                                    style: titleHint,
                                  ),
                                  const Divider(),
                                  Text(
                                    "MODELO",
                                    style: subtitleHint,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SelectableText(
                                    car.model,
                                    style: title.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "MODELO PNEU",
                                    style: subtitleHint,
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  SelectableText(
                                    car.modelPneu,
                                    style: title.copyWith(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  controller.enable
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "NÚMERO CARTÃO DE ABASTECIMENTO",
                                              style: subtitleHint,
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            SelectableText(
                                              car.ticket,
                                              style: title.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              "NÚMERO CARTÃO MANUTENÇÃO",
                                              style: subtitleHint,
                                            ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            SelectableText(
                                              car.prime,
                                              style: title.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : Container(),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "FUNCIONAMENTO",
                                          style: titleHint,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120.0,
                                        child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                            onPressed: controller.enable
                                                ? () async {
                                                    if (car.enable) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              StatusWidget(
                                                                user: app.user,
                                                                onInsert:
                                                                    (value) async {
                                                                  await controller.updateStatusCar(
                                                                      status:
                                                                          value,
                                                                      id: car
                                                                          .id!,
                                                                      enable: !car
                                                                          .enable);
                                                                },
                                                              ));
                                                    } else {
                                                      await controller.updateStatusCar(
                                                          status: CarStatusModel(
                                                              date: DateTime
                                                                  .now(),
                                                              user: app.user,
                                                              description:
                                                                  "RETORNOU AO FUNCIONAMENTO.",
                                                              type: "",
                                                              value: true),
                                                          id: car.id!,
                                                          enable: !car.enable);
                                                    }
                                                  }
                                                : null,
                                            icon: Icon(
                                              car.enable
                                                  ? MdiIcons.checkCircle
                                                  : MdiIcons.closeCircle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 20.0,
                                            ),
                                            label: Text(
                                              car.enable
                                                  ? "Operando"
                                                  : "Baixado",
                                              style: title.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  StreamBuilder<List<CarStatusModel>>(
                                      stream: controller.listenStatus(
                                          carId: car.id!),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const LinearProgressIndicator();
                                        }

                                        final status = snapshot.data ?? [];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              status.length,
                                              (index) => Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${formatDate(status[index].date)} - ${status[index].user.name}",
                                                          style: subtitleHint,
                                                        ),
                                                        Text(
                                                          status[index]
                                                              .description
                                                              .toUpperCase(),
                                                          style: subtitle,
                                                        ),
                                                        // Text(
                                                        //   status[index].local,
                                                        //   style: subtitleHint,
                                                        // )
                                                      ],
                                                    ),
                                                  )),
                                        );
                                      }),
                                  const SizedBox(
                                    height: 50.0,
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
                Observer(builder: (_) {
                  return IgnorePointer(
                    ignoring: !controller.loading,
                    child: Container(
                      color: controller.loading
                          ? Colors.black54
                          : Colors.transparent,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            controller.loading
                                ? Colors.white
                                : Colors.transparent),
                      )),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusWidget extends StatefulWidget {
  final Function(CarStatusModel) onInsert;
  final UserModel user;
  const StatusWidget({Key? key, required this.onInsert, required this.user})
      : super(key: key);

  @override
  State createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  String _status = statusType.first;

  final _controllerDesc = TextEditingController();
  final _controllerLocal = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    _controllerDesc.dispose();
    _controllerLocal.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<String>(
                  value: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value ?? statusType.first;
                    });
                  },
                  underline: Container(),
                  isExpanded: true,
                  items: List.generate(
                      statusType.length,
                      (index) => DropdownMenuItem<String>(
                            value: statusType[index],
                            child: Text(
                              statusType[index],
                              style: subtitle,
                            ),
                          ))),
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              controller: _controllerDesc,
              hint: "DESCRIÇÃO",
              validation: Validation.validatorPreenchimento,
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              controller: _controllerLocal,
              hint: "LOCAL",
              validation: Validation.validatorPreenchimento,
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        Navigator.of(context).pop();
                        widget.onInsert(CarStatusModel(
                            date: DateTime.now(),
                            user: widget.user,
                            type: _status,
                            description: _controllerDesc.text,
                            local: _controllerLocal.text,
                            value: false));
                      }
                    },
                    child: Text("INSERIR", style: titleButton)))
          ],
        ),
      ),
    );
  }
}
