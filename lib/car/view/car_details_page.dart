import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/car_changes_widget.dart';
import '../../widgets/textfield_widget.dart';
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
    controller = CarController(
      config: config,
      user: app.user,
    );

    rec = autorun((_) {
      setState(() {
        car = app.cars.firstWhere((e) => e.id == widget.carID);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec();
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
                        child: Text("Alterar", style: Constants.titleButton)))
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgraundPage(
          menu: false,
          onBack: () => Navigator.of(context).pop(),
          wrapAlign: WrapAlignment.spaceBetween,
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                car.prefix,
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Constants.primary,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'INFORMAÇÕES BÁSICAS',
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Quilometragem",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                "${car.km.toString()} KM",
                style: Constants.title.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Modelo",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.model,
                style: Constants.title.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Placa",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.plate,
                style: Constants.title.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Referência do pneu",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.modelPneu,
                style: Constants.title.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 10.0,
              ),
              controller.enable
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Número cartão",
                          style: Constants.subtitleHint,
                        ),
                        SelectableText(
                          car.ticket,
                          style: Constants.title.copyWith(fontSize: 16),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: Text(
                    "Troca de óleo (KM)",
                    style: Constants.title,
                  )),
                  Text(
                    car.oil.toString(),
                    style: Constants.title
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  controller.enable
                      ? TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => kmChangeWidget(
                                      onUpdate: (value) async {
                                        await controller.updateKMOil(
                                            id: car.id!, value: value);
                                        _controller.clear();
                                      },
                                    ));
                          },
                          child: Text(
                            "Alterar",
                            style: Constants.title.copyWith(
                                color: Theme.of(context).primaryColor),
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
                    style: Constants.title,
                  )),
                  Text(
                    car.arref.toString(),
                    style: Constants.title
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  controller.enable
                      ? TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => kmChangeWidget(
                                      onUpdate: (value) async {
                                        await controller.updateKMArref(
                                            id: car.id!, value: value);
                                        _controller.clear();
                                      },
                                    ));
                          },
                          child: Text(
                            "Alterar",
                            style: Constants.title.copyWith(
                                color: Theme.of(context).primaryColor),
                          ))
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: CarChangesWidget(
                  add: false,
                  car: car,
                  user: app.user,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Funcionamento",
                      style: Constants.titleHint,
                    ),
                  ),
                  PopupMenuButton<StatusCar>(
                    enabled: controller.enable,
                    initialValue: car.state,
                    onSelected: (StatusCar value) async {
                      if (value == StatusCar.baixado) {
                        if (car.enable) {
                          showDialog(
                              context: context,
                              builder: (context) => DescriptionStateWidget(
                                    user: app.user,
                                    onInsert: (result) async {
                                      await controller.saveStatus(
                                          car: car.copyWith(
                                              enable: false, state: value),
                                          status: result.copyWith(
                                              carID: car.id!, state: value));
                                    },
                                  ));
                        }
                      } else {
                        if (value == StatusCar.waiting) {
                          await controller.saveStatus(
                              car: car.copyWith(enable: true, state: value));
                        } else {
                          await controller.saveStatus(
                              car: car.copyWith(enable: true, state: value),
                              status: CarStatusModel(
                                  date: DateTime.now(),
                                  user: app.user,
                                  carID: car.id ?? '',
                                  description: value.label,
                                  state: value,
                                  value: true));
                        }
                      }
                    },
                    itemBuilder: (context) => StatusCar.values.map((state) {
                      return PopupMenuItem<StatusCar>(
                        enabled: (state != car.state),
                        value: state,
                        child: Text(
                          state.label,
                          style: Constants.title,
                        ),
                      );
                    }).toList(),
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            side: BorderSide(color: car.state.color)),
                        onPressed: null,
                        icon: Icon(
                          car.state.icon,
                          color: car.state.color,
                          size: 20.0,
                        ),
                        label: Text(
                          car.state.label,
                          style:
                              Constants.title.copyWith(color: car.state.color),
                        )),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: StreamBuilder<List<CarStatusModel>>(
                    stream: controller.listenStatus(carId: car.id!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: LinearProgressIndicator());
                      } else {
                        final status =
                            List<CarStatusModel>.from(snapshot.data ?? []);

                        if (status.isEmpty) {
                          return Text(
                            'Nenhum registro de problemas encontrado.',
                            style: Constants.subtitleHint,
                          );
                        } else {
                          status.sort((a, b) => b.date.compareTo(a.date));

                          return statusRegisters(
                              context: context,
                              status: status,
                              onDelete: controller.enable
                                  ? (value) async {
                                      await controller.deleteStatus(
                                          car: car.copyWith(
                                              enable: true,
                                              state: StatusCar.waiting),
                                          status: value);
                                    }
                                  : null);
                        }
                      }
                    }),
              ),
              const SizedBox(
                height: 10.0,
              ),
            ],
          ),
          childRight: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Constants.primary,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'ITENS OU ACESSÓRIOS',
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              (car.itens.isEmpty)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : changesListWidget(
                      context: context,
                      categories: car.itens,
                    ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: controller.enable,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 80.0,
                      child: TextButton(
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CarRegisterPage(
                                      car: car,
                                    )));
                          },
                          child: Text(
                            "Editar",
                            style: Constants.title.copyWith(
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                    SizedBox(
                      width: 80.0,
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertMessage(
                                      title: 'Atenção',
                                      message:
                                          'Deseja deletar o registro desse veículo ?',
                                      cancel: true,
                                      titleOK: 'Sim',
                                      onPressedOK: () =>
                                          Navigator.of(context).pop(true),
                                      onPressedCancel: () =>
                                          Navigator.of(context).pop(false),
                                    )).then((value) {
                              if (value ?? false) {
                                controller
                                    .delete(id: car.id ?? '')
                                    .then((value) {
                                  Navigator.of(context).pop();
                                }).catchError((err) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                            title: 'Atenção',
                                            message: err.toString(),
                                            onPressedOK: () =>
                                                Navigator.of(context).pop(),
                                          ));
                                });
                              }
                            });
                          },
                          child: Text(
                            "Excluir",
                            style: Constants.title.copyWith(
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                    SizedBox(
                      width: 80.0,
                      child: TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertMessage(
                                      title: '',
                                      message:
                                          'Deseja criar uma copia atual desse veiculo ?',
                                      cancel: true,
                                      titleOK: 'Sim',
                                      onPressedOK: () =>
                                          Navigator.of(context).pop(true),
                                      onPressedCancel: () =>
                                          Navigator.of(context).pop(false),
                                    )).then((value) async {
                              if (value ?? false) {
                                controller.copy(car: car).then((value) {
                                  Navigator.of(context).pop();
                                }).catchError((err) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                            title: 'Atenção',
                                            message: err.toString(),
                                            onPressedOK: () =>
                                                Navigator.of(context).pop(),
                                          ));
                                });
                              }
                            });
                          },
                          child: Text(
                            "Copiar",
                            style: Constants.title.copyWith(
                                color: Theme.of(context).primaryColor),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
            ],
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

Widget statusRegisters(
    {required BuildContext context,
    required List<CarStatusModel> status,
    required Function(CarStatusModel)? onDelete}) {
  return Column(
    children: List.generate(status.length, (index) {
      final state = status[index];
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !state.value,
                    child: Text(
                      "Registros de problemas",
                      style: Constants.subtitle.copyWith(color: Colors.red),
                    ),
                  ),
                  Text(
                    Core.formatDate(state.date, largeDayHour: true),
                    style: Constants.titleHint,
                  ),
                  Text(
                    state.description,
                    style: Constants.title,
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Text(
                        "${state.user.graduation} ${state.user.name}",
                        style: Constants.titleHint,
                      ),
                    ],
                  ),
                  Visibility(
                    visible: state.local.isNotEmpty,
                    child: Text(
                      state.local,
                      style: Constants.titleHint,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: (index == 0 && !state.value && onDelete != null),
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
                        onDelete?.call(state);
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
    }).expand((widget) => [widget, const Divider()]).toList()
      ..removeLast(),
  );
}

Widget changesListWidget(
    {required BuildContext context,
    required List<ItensChangesModel> categories}) {
  final list = List<ItensChangesModel>.from(categories);

  return StatefulBuilder(
    builder: (context, setState) {
      return ExpansionPanelList(
        elevation: 2,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, expanded) {
          setState(() {
            list[panelIndex].value = expanded;
          });
        },
        children: list.map((category) {
          return ExpansionPanel(
              isExpanded: category.value,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  title: Text(
                    category.description,
                    style: Constants.title,
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: category.itens
                      .map((item) {
                        return Row(
                          children: [
                            Expanded(
                                child: Text(
                              item.description,
                              style: Constants.title,
                            )),
                            Text.rich(
                              TextSpan(
                                  text: item.quantity.toString(),
                                  children: [
                                    TextSpan(
                                      text: ' unids.',
                                      style: Constants.subtitleHint,
                                    )
                                  ]),
                              style: Constants.title,
                            ),
                          ],
                        );
                      })
                      .expand((widget) => [
                            widget,
                            const Divider(),
                          ])
                      .toList()
                    ..removeLast(),
                ),
              ));
        }).toList(),
      );
    },
  );
}
