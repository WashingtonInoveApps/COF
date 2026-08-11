import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_register_controller.dart';
import 'package:bsu_control/car/view/cars_page.dart';
import 'package:bsu_control/car/view/pages/car_details_page.dart';
import 'package:bsu_control/car/view/pages/car_function_page.dart';
import 'package:bsu_control/car/view/pages/car_infor_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import '../../widgets/backgraund_page.dart';
import '../controller/car_controller.dart';

class CarRegisterPage extends StatefulWidget {
  final CarModel? car;
  const CarRegisterPage({Key? key, this.car}) : super(key: key);

  @override
  State createState() => _CarRegisterPageState();
}

class _CarRegisterPageState extends State<CarRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late CarController controller;
  late CarRegisterController register;

  @override
  void initState() {
    super.initState();

    controller = CarController(
      config: config,
      user: app.user,
    );

    register = CarRegisterController(
      init: widget.car,
      user: app.user,
      obms: app.obms,
      types: app.carsTypes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.car != null);

    final pages = [
      CarRegisterInforPage(controller: register),
      CarRegisterDetailsPage(controller: register),
      CarRegisterFunctionPage(controller: register),
    ];

    return Stack(
      children: [
        BackgraundPage(
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
                            final messagesValidation =
                                register.validationForm(controller.step);

                            if (messagesValidation.isEmpty) {
                              controller
                                  .save(
                                car: register.car,
                                images: register.images,
                              )
                                  .then((_) {
                                if (update) {
                                  Navigator.of(context).pop();
                                } else {
                                  app.setRouter(5);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CarsPage()));
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
                                      messages: messagesValidation));
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
                            final messagesValidation =
                                register.validationForm(controller.step);

                            if (messagesValidation.isEmpty) {
                              controller.processStep(true);
                            } else {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertMultMessage(
                                      messages: messagesValidation));
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
          childLeft: Observer(builder: (_) {
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
    );
  }
}
