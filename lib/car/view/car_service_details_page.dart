import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/car/view/car_services_register_page.dart';
import 'package:bsu_control/car/view/widgets/card_imagem_service_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_service_model.dart';
import 'package:bsu_control/model/car_status_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/container_custom_widget.dart';

class CarServiceDetailsPage extends StatefulWidget {
  final CarController controller;
  final String serviceID;

  const CarServiceDetailsPage(
      {Key? key, required this.serviceID, required this.controller})
      : super(key: key);

  @override
  State createState() => _CarServiceDetailsPageState();
}

class _CarServiceDetailsPageState extends State<CarServiceDetailsPage> {
  late CarServiceModel service;
  late ReactionDisposer rec;
  late CarController controller;
  late StreamSubscription subscription;

  final app = GetIt.I.get<AppController>();

  @override
  void initState() {
    super.initState();

    controller = widget.controller;

    rec = autorun((_) {
      setState(() {
        service =
            controller.services.firstWhere((e) => e.id == widget.serviceID);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec();
  }

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
                'Serviço',
                style: Constants.title.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                Core.formatDate(service.date, largeDayHour: true),
                style: Constants.titleHint,
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
                "Prefixo",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                service.car?.prefix ?? '',
                style: Constants.title,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Motivo",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                service.problem.label,
                style: Constants.title,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Descrição",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                service.description,
                style: Constants.title,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Local",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                service.local,
                style: Constants.title,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Ganrantia",
                style: Constants.subtitleHint,
              ),
              SelectableText(
                service.expired == null
                    ? 'Sem garantia'
                    : Core.formatDate(service.expired ?? DateTime.now(),
                        largeDay: true),
                style: Constants.title,
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
                label: 'IMAGENS',
              ),
              (service.images?.isEmpty ?? true)
                  ? Text(
                      'Nenhuma imagem encontrada.',
                      style: Constants.titleHint,
                    )
                  : SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(service.images!.length, (index) {
                          final image = service.images![index];

                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: CardServiceImageWidget(
                              value: image,
                              onView: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          contentPadding:
                                              const EdgeInsets.all(5),
                                          content: CardServiceImageWidget(
                                            value: image,
                                            onClose: () =>
                                                Navigator.of(context).pop(),
                                            heigth: 400,
                                            width: 400,
                                          ),
                                        ));
                              },
                            ),
                          );
                        })
                                .expand((widget) => [widget, const Divider()])
                                .toList()
                              ..removeLast(),
                      ),
                    ),
              const SizedBox(
                height: 10.0,
              ),
              const ContainerCustom(
                label: 'OBSERVAÇÕES IMPORTANTES',
              ),
              service.obs.isEmpty
                  ? Text(
                      'Sem observações registradas.',
                      style: Constants.titleHint,
                    )
                  : Text(
                      service.obs,
                      style: Constants.title,
                    ),
              const SizedBox(
                height: 10.0,
              ),
              if (controller.enable)
                Row(
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
                              controller
                                  .deleteService(service: service)
                                  .then((_) {
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
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CarServiceRegisterPage(
                                    service: service,
                                  )));
                        },
                        child: Text(
                          "Editar",
                          style: Constants.titleButton,
                        )),
                  ],
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
