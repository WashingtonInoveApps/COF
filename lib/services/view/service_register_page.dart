import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../home/home_page.dart';
import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import '../../widgets/backgraund_page.dart';
import '../controller/service_controller.dart';
import 'pages/service_details_page.dart';
import 'pages/service_infor_page.dart';

class ServiceRegisterPage extends StatefulWidget {
  final ServiceModel? service;
  const ServiceRegisterPage({Key? key, this.service}) : super(key: key);

  @override
  State createState() => _ServiceRegisterPageState();
}

class _ServiceRegisterPageState extends State<ServiceRegisterPage> {
  final app = GetIt.I.get<AppController>();
  late ServiceController controller;

  @override
  void initState() {
    super.initState();

    controller = ServiceController(
      init: widget.service,
      users: app.users,
      config: config,
      user: app.user,
      update: (widget.service != null),
      cars: app.carsUsers,
      servicesToday: [],
    );
  }

  double processWidth(double value) {
    if (value <= 500) return value;

    return value * 0.48;
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.service != null);

    final pages = [
      ServiceInforPage(
        obms: app.obms,
        user: app.user,
        controller: controller,
      ),
      ServiceDetailsPage(
        obms: app.obms,
        controller: controller,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          BackgraundPage(
            menu: !update,
            onBack: update ? () => Navigator.of(context).pop() : null,
            contentBottom: Center(
              child: Row(
                spacing: 50,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Observer(builder: (_) {
                    return (update && controller.step == 0)
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text(
                              'Cancelar',
                              style: Constants.titleButton,
                            ))
                        : ElevatedButton(
                            onPressed: (controller.step > 0)
                                ? () {
                                    controller.processStep(false);
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text(
                              'Voltar',
                              style: Constants.titleButton,
                            ));
                  }),
                  Observer(builder: (_) {
                    return controller.btFinish
                        ? ElevatedButton(
                            onPressed: () async {
                              if (controller.validationForm()) {
                                controller.save().then((_) {
                                  if (update) {
                                    Navigator.of(context).pop();
                                  } else {
                                    app.setRouter(0);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  }
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
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertMultMessage(
                                        messages: controller.messagesErros));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primary),
                            child: Text(
                              update ? 'Alterar' : 'Salvar',
                              style: Constants.titleButton,
                            ))
                        : ElevatedButton(
                            onPressed: () async {
                              if (controller.validationForm()) {
                                controller.processStep(true);
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertMultMessage(
                                        messages: controller.messagesErros));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primary),
                            child: Text(
                              'Próximo',
                              style: Constants.titleButton,
                            ));
                  }),
                ],
              ),
            ),
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update ? 'Alteração de Serviço' : 'Registro de Serviço',
                  style: Constants.title.copyWith(fontSize: 18),
                ),
                const Divider(),
              ],
            ),
            childLeft: Observer(builder: (_) {
              log('Step: ${controller.step}');
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[controller.step],
              );
            }),
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

Widget itemWidget(
    {required ItemModel item, required Function(bool value) onSelect}) {
  bool result = item.value;
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        Checkbox(
            value: result,
            onChanged: (value) {
              setState(() {
                result = value ?? result;
                onSelect(result);
              });
            }),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          item.description,
          style: Constants.subtitle,
        )
      ],
    );
  });
}
