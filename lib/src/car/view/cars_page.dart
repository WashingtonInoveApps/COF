import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/car/repository/car_repository.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'car_details_page.dart';
import 'car_register_page.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final controller = GetIt.I.get<AppController>();
  late CarController carController;

  @override
  void initState() {
    super.initState();
    carController = CarController(app: controller, repository: CarRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(titlePage: 'VEÍCULOS CADASTRADOS'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "OPERACIONAIS",
                          style: titleHint,
                        ),
                      ),
                      controller.user.adminFleet
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CarRegisterPage()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: Text(
                                  "NOVO",
                                  style: subtitle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          : Container(),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Observer(builder: (_) {
                    return controller.carsOPR.isEmpty
                        ? Center(
                            child: Text(
                              "Ops ! Nenhum registro encontrado.",
                              style: title,
                            ),
                          )
                        : Column(
                            children: List.generate(
                                controller.carsOPR.length,
                                (index) => CarCard(
                                      car: controller.carsOPR[index],
                                      onLong: () async {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertMessage(
                                                  title: '',
                                                  message:
                                                      'Deseja realmente deletar o registro desse veículo ?',
                                                  cancel: true,
                                                  onPressedOK: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  onPressedCancel: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                )).then((value) async {
                                          if (value ?? false) {
                                            await carController.deleteCar(
                                                id: controller
                                                        .carsOPR[index].id ??
                                                    '');
                                          }
                                        });
                                      },
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CarDetailsPage(
                                                      carId: controller
                                                          .carsOPR[index].id!,
                                                    )));
                                      },
                                    )),
                          );
                  }),
                  Text(
                    "ADMINISTRATIVO",
                    style: titleHint,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Observer(builder: (_) {
                    return controller.carsADM.isEmpty
                        ? Center(
                            child: Text(
                              "Ops ! Nenhum registro encontrado.",
                              style: title,
                            ),
                          )
                        : Column(
                            children: List.generate(
                                controller.carsADM.length,
                                (index) => CarCard(
                                      car: controller.carsADM[index],
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CarDetailsPage(
                                                      carId: controller
                                                          .carsADM[index].id!,
                                                    )));
                                      },
                                    )),
                          );
                  }),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
