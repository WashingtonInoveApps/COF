import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/alert_message.dart';
import 'car_register_page.dart';
import 'widgets/description_state_widget.dart';

class CarDetailsPage extends StatefulWidget {
  final String carID;
  const CarDetailsPage({Key? key, required this.carID}) : super(key: key);

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
    controller = CarController(app: app);

    rec = autorun((_) {
      setState(() {
        car = app.cars.firstWhere((e) => e.id == widget.carID);
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
          contentPadding: const EdgeInsets.all(10),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldText(
                  controller: _controller,
                  hint: "Quilometragem",
                  label: 'Quilometragem',
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
                        child: Text("ALTERAR", style: Core.titleButton)))
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    Widget statusRegisters(List<CarStatusModel> status) {
      return ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(5),
          itemCount: status.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Core.formatDate(status[index].date,
                              largeDayHour: true),
                          style: Core.subtitleHint,
                        ),
                        Text(
                          status[index].description,
                          style: Core.subtitle,
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              "${status[index].user.graduation} ${status[index].user.name}",
                              style: Core.subtitleHint,
                            ),
                            // InkWell(
                            //     onTap: () {},
                            //     child: Text(
                            //       'Ver detalhes',
                            //       style: Core.subtitle
                            //           .copyWith(color: Colors.blue),
                            //     )),
                          ],
                        ),
                        Visibility(
                          visible: status[index].local.isNotEmpty,
                          child: Text(
                            status[index].local,
                            style: Core.subtitleHint,
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (index == 0),
                    child: IconButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => AlertMessage(
                                    title: '',
                                    message:
                                        'Deseja deletar esse registro do estado de funcionamento ?',
                                    cancel: true,
                                    onPressedOK: () =>
                                        Navigator.of(context).pop(true),
                                    onPressedCancel: () =>
                                        Navigator.of(context).pop(false),
                                  )).then((value) async {
                            if (value ?? false) {
                              await controller.deleteStatusCar(
                                  car: car.copyWith(
                                      enable: true, state: StatusCar.reserva),
                                  status: status[index]);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            );
          });
    }

    return SafeArea(
      top: true,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
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
                height: 20,
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: LayoutBuilder(
                        builder: (context, constrained) {
                          double width = constrained.maxWidth > 500
                              ? constrained.maxWidth * 0.48
                              : constrained.maxWidth;

                          return SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                car.prefix,
                                                style: Core.title.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              Row(
                                                spacing: 10,
                                                children: [
                                                  Text(
                                                    "Quilometragem",
                                                    style: Core.titleHint,
                                                  ),
                                                  Text(
                                                      "${car.km.toString()} KM",
                                                      style: Core.title
                                                          .copyWith(
                                                              fontSize: 16)),
                                                ],
                                              ),
                                            ],
                                          )),
                                          controller.enable
                                              ? TextButton.icon(
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      side: BorderSide(
                                                          color: Theme.of(
                                                                  context)
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
                                                    style: Core.title.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Troca de óleo (KM)",
                                            style: Core.title,
                                          )),
                                          Text(
                                            car.oil.toString(),
                                            style: Core.title.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          controller.enable
                                              ? TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
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
                                                    style: Core.title.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Troca do arrefecimento (KM)",
                                            style: Core.title,
                                          )),
                                          Text(
                                            car.arref.toString(),
                                            style: Core.title.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          controller.enable
                                              ? TextButton(
                                                  style: TextButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
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
                                                    style: Core.title.copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ))
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      CarChangesWidget(
                                        add: false,
                                        car: car,
                                        // initValue: car.changes,
                                        user: app.user,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Informações",
                                        style: Core.titleHint,
                                      ),
                                      const Divider(),
                                      Text(
                                        "Modelo",
                                        style: Core.subtitleHint,
                                      ),
                                      SelectableText(
                                        car.model,
                                        style:
                                            Core.title.copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Placa",
                                        style: Core.subtitleHint,
                                      ),
                                      SelectableText(
                                        car.plate,
                                        style:
                                            Core.title.copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Referência do pneu",
                                        style: Core.subtitleHint,
                                      ),
                                      SelectableText(
                                        car.modelPneu,
                                        style:
                                            Core.title.copyWith(fontSize: 16),
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
                                                  "Número cartão",
                                                  style: Core.subtitleHint,
                                                ),
                                                SelectableText(
                                                  car.ticket,
                                                  style: Core.title
                                                      .copyWith(fontSize: 16),
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Funcionamento",
                                              style: Core.titleHint,
                                            ),
                                          ),
                                          PopupMenuButton<StatusCar>(
                                            initialValue: car.state,
                                            onSelected:
                                                (StatusCar value) async {
                                              if (value == StatusCar.baixado) {
                                                if (car.enable) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          DescriptionStateWidget(
                                                            user: app.user,
                                                            onInsert:
                                                                (result) async {
                                                              await controller.updateStatusCar(
                                                                  car: car.copyWith(
                                                                      enable:
                                                                          false,
                                                                      state:
                                                                          value),
                                                                  status: result
                                                                      .copyWith(
                                                                          carID:
                                                                              car.id!));
                                                            },
                                                          ));
                                                }
                                              } else {
                                                await controller
                                                    .updateStatusCar(
                                                        car: car.copyWith(
                                                            enable: true,
                                                            state: value));
                                              }
                                            },
                                            itemBuilder: (context) =>
                                                StatusCar.values.map((state) {
                                              return PopupMenuItem<StatusCar>(
                                                enabled: (state != car.state),
                                                value: state,
                                                child: Text(
                                                  state.label,
                                                  style: Core.title,
                                                ),
                                              );
                                            }).toList(),
                                            child: TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    side: BorderSide(
                                                        color:
                                                            car.state.color)),
                                                onPressed: null,
                                                icon: Icon(
                                                  car.state.icon,
                                                  color: car.state.color,
                                                  size: 20.0,
                                                ),
                                                label: Text(
                                                  car.state.label,
                                                  style: Core.title.copyWith(
                                                      color: car.state.color),
                                                )),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      SizedBox(
                                        height: 250,
                                        width: double.infinity,
                                        child: StreamBuilder<
                                                List<CarStatusModel>>(
                                            stream: controller.listenStatus(
                                                carId: car.id!),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                    child:
                                                        LinearProgressIndicator());
                                              } else {
                                                final status =
                                                    snapshot.data ?? [];

                                                if (status.isEmpty) {
                                                  return Text(
                                                    'Nenhum registro de problemas encontrado.',
                                                    style: Core.subtitleHint,
                                                  );
                                                } else {
                                                  status.sort((a, b) =>
                                                      b.date.compareTo(a.date));

                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Registros de problemas",
                                                        style: Core.subtitle
                                                            .copyWith(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                      Expanded(
                                                        child: statusRegisters(
                                                            status),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }
                                            }),
                                      ),
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
        ),
      ),
    );
  }
}
