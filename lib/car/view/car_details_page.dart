import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/car_changes_widget.dart';
import '../../widgets/card_outhers_widget.dart';
import '../../widgets/container_custom_widget.dart';
import '../../widgets/list_itens_view_widget.dart';
import '../../widgets/textfield_widget.dart';
import 'car_register_page.dart';
import 'widgets/description_state_widget.dart';

class CarDetailsPage extends StatefulWidget {
  final CarController controller;
  final String carID;

  const CarDetailsPage(
      {Key? key, required this.carID, required this.controller})
      : super(key: key);

  @override
  State createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  late CarModel car;
  late ReactionDisposer rec;
  late CarController controller;

  StreamSubscription? subscriptionStatus;

  final app = GetIt.I.get<AppController>();

  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

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
                style: Constants.title.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(
                label: 'INFORMAÇÕES BÁSICAS',
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
                style: Constants.title,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "Modelo",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.model,
                style: Constants.title,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "Placa",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.plate,
                style: Constants.title,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "Referência do pneu",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                car.modelPneu.isEmpty ? '-' : car.modelPneu,
                style: Constants.title,
              ),
              const SizedBox(
                height: 5.0,
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
                          car.ticket.isEmpty ? '-' : car.ticket,
                          style: Constants.title,
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(
                label: 'MANUTENÇÃO',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Troca de óleo (KM)",
                        style: Constants.subtitleHint,
                      ),
                      Text(
                        car.oil.toString(),
                        style: Constants.title.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )),
                  if (controller.enable)
                    TextButton(
                        style: TextButton.styleFrom(
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
                          style: Constants.subtitle
                              .copyWith(color: Theme.of(context).primaryColor),
                        )),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Troca do arrefecimento (KM)",
                        style: Constants.subtitleHint,
                      ),
                      Text(
                        car.arref.toString(),
                        style: Constants.title.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )),
                  if (controller.enable)
                    TextButton(
                        style: TextButton.styleFrom(
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
                          style: Constants.subtitle
                              .copyWith(color: Theme.of(context).primaryColor),
                        )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(
                label: 'ALTERAÇÕES',
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
                height: 5.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PopupMenuButton<StatusCar>(
                  enabled: controller.enable,
                  initialValue: car.state,
                  onSelected: (StatusCar value) async {
                    if (value == StatusCar.broken) {
                      showDialog(
                          context: context,
                          builder: (context) => DescriptionStateWidget(
                                user: app.user,
                                onInsert: (result) async {
                                  await controller.saveStatus(
                                      car: car.copyWith(
                                        enable: false,
                                        state: value,
                                      ),
                                      status: result.copyWith(
                                        carID: car.id!,
                                        state: value,
                                      ));
                                },
                              ));
                    } else {
                      await controller.saveStatus(
                          car: car.copyWith(
                            enable: true,
                            state: value,
                          ),
                          status: CarStatusModel(
                              date: DateTime.now(),
                              user: app.user,
                              carID: car.id ?? '',
                              state: value,
                              value: value.enable));
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
                        style: Constants.title.copyWith(color: car.state.color),
                      )),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const ContainerCustom(
                label: 'FUNCIONAMENTO',
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Observer(builder: (context) {
                  {
                    final status = controller.statusGeral
                        .where((e) => e.carID == car.id)
                        .toList();

                    if (status.isEmpty) {
                      return Text(
                        'Nenhum registro encontrado.',
                        style: Constants.titleHint,
                      );
                    } else {
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
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(
                label: 'OUTRAS ALTERAÇÕES',
              ),
              (car.others?.isEmpty ?? true)
                  ? Text(
                      'Nenhuma outra alteração encontrada',
                      style: Constants.titleHint,
                    )
                  : Column(
                      children: List.generate(car.others!.length, (index) {
                        final other = car.others![index];

                        return CardOutherChange(
                          other: other,
                        );
                      }).expand((widget) => [widget, const Divider()]).toList()
                        ..removeLast(),
                    ),
              const SizedBox(
                height: 10.0,
              ),
              const ContainerCustom(
                label: 'ITENS OU ACESSÓRIOS',
              ),
              (car.itens.isEmpty)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : ListItensViewWidget(
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
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
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
                              controller.delete(car: car).then((value) {
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
                          style: Constants.titleButton,
                        )),
                    ElevatedButton(
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
                              await Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => CarRegisterPage(
                                            copied: true,
                                            car: CarModel(
                                              itens: car.itens,
                                              changes: [],
                                              status: [],
                                              images: car.images,
                                              obmID: car.obmID,
                                              cia: car.cia,
                                              ciaID: car.ciaID,
                                              model: car.model,
                                              modelPneu: car.modelPneu,
                                              function: car.function,
                                              type: car.type,
                                            ),
                                          )));
                            }
                          });
                        },
                        child: Text(
                          "Copiar",
                          style: Constants.titleButton,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CarRegisterPage(
                                    car: car,
                                  )));
                        },
                        child: Text(
                          "Editar",
                          style: Constants.titleButton,
                        )),
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
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: IntrinsicHeight(
          child: Row(
            spacing: 10,
            children: [
              Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    color: state.state.color,
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  state.state.icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.description.isNotEmpty)
                      Text(
                        state.description,
                        style: Constants.title,
                      ),
                    Text(
                      "${state.user.graduation} ${state.user.name}",
                      style: Constants.titleHint,
                    ),
                    if (state.local.isNotEmpty)
                      Text(
                        state.local,
                        style: Constants.titleHint,
                      ),
                    Text(
                      Core.formatDate(state.date, largeDayHour: true),
                      style: Constants.subtitleHint,
                    ),
                  ],
                ),
              ),
              if ((index == 0 && !state.value && onDelete != null))
                IconButton(
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
                          onDelete.call(state);
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.grey,
                    )),
            ],
          ),
        ),
      );
    }).expand((widget) => [widget, const Divider()]).toList()
      ..removeLast(),
  );
}
