import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
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
    carController = CarController(app: controller);
  }

  @override
  Widget build(BuildContext context) {
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
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      'Veículos cadastrados',
                      style: Core.title.copyWith(fontSize: 18),
                    ),
                  ),
                  controller.user.admin
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CarRegisterPage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 2),
                            child: Text(
                              "NOVO CADASTRO",
                              style: Core.subtitle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))
                      : Container(),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constrained) {
                  double width = constrained.maxWidth > 500
                      ? constrained.maxWidth * 0.48
                      : constrained.maxWidth;

                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "OPERACIONAIS",
                                    style: Core.titleButton,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Observer(builder: (_) {
                                  return controller.carsOPR.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Ops ! Nenhum registro encontrado.",
                                            style: Core.titleHint,
                                          ),
                                        )
                                      : Column(
                                          children: List.generate(
                                              controller.carsOPR.length,
                                              (index) => CarCard(
                                                    car: controller
                                                        .carsOPR[index],
                                                    onLong: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertMessage(
                                                                    title: '',
                                                                    message:
                                                                        'Deseja realmente deletar o registro desse veículo ?',
                                                                    cancel:
                                                                        true,
                                                                    onPressedOK: () =>
                                                                        Navigator.of(context)
                                                                            .pop(true),
                                                                    onPressedCancel: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                  )).then(
                                                          (value) async {
                                                        if (value ?? false) {
                                                          await carController
                                                              .deleteCar(
                                                                  id: controller
                                                                          .carsOPR[
                                                                              index]
                                                                          .id ??
                                                                      '');
                                                        }
                                                      });
                                                    },
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CarDetailsPage(
                                                                    carID: controller
                                                                        .carsOPR[
                                                                            index]
                                                                        .id!,
                                                                  )));
                                                    },
                                                  )),
                                        );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    "ADMINISTRATIVO",
                                    style: Core.titleButton,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Observer(builder: (_) {
                                  return controller.carsADM.isEmpty
                                      ? Center(
                                          child: Text(
                                            "Ops ! Nenhum registro encontrado.",
                                            style: Core.titleHint,
                                          ),
                                        )
                                      : Column(
                                          children: List.generate(
                                              controller.carsADM.length,
                                              (index) => CarCard(
                                                    car: controller
                                                        .carsADM[index],
                                                    onLong: () {
                                                      showDialog(
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  AlertMessage(
                                                                    title: '',
                                                                    message:
                                                                        'Deseja realmente deletar o registro desse veículo ?',
                                                                    cancel:
                                                                        true,
                                                                    onPressedOK: () =>
                                                                        Navigator.of(context)
                                                                            .pop(true),
                                                                    onPressedCancel: () =>
                                                                        Navigator.of(context)
                                                                            .pop(false),
                                                                  )).then(
                                                          (value) async {
                                                        if (value ?? false) {
                                                          await carController
                                                              .deleteCar(
                                                                  id: controller
                                                                          .carsADM[
                                                                              index]
                                                                          .id ??
                                                                      '');
                                                        }
                                                      });
                                                    },
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CarDetailsPage(
                                                                    carID: controller
                                                                        .carsADM[
                                                                            index]
                                                                        .id!,
                                                                  )));
                                                    },
                                                  )),
                                        );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
