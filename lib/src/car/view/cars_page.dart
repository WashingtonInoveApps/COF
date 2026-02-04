import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import 'car_details_page.dart';

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
    return PopScope(
      canPop: false,
      child: BackgraundPage(
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Veículos registrados',
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
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: Text(
                "Operacionais",
                style: Constants.titleButton,
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
                        style: Constants.titleHint,
                      ),
                    )
                  : Column(
                      children: List.generate(
                          controller.carsOPR.length,
                          (index) => CarCard(
                                options: controller.user.admin,
                                car: controller.carsOPR[index],
                                onLong: () async {
                                  await carController.deleteCar(
                                      id: controller.carsOPR[index].id ?? '');
                                },
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CarDetailsPage(
                                            carID:
                                                controller.carsOPR[index].id!,
                                          )));
                                },
                                onCopy: () async {
                                  await carController.copy(
                                      car: controller.carsOPR[index]);
                                },
                              )),
                    );
            }),
          ],
        ),
        childRight: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(5)),
              child: Text(
                "Administrativos",
                style: Constants.titleButton,
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
                        style: Constants.titleHint,
                      ),
                    )
                  : Column(
                      children: List.generate(
                          controller.carsADM.length,
                          (index) => CarCard(
                                options: controller.user.admin,
                                car: controller.carsADM[index],
                                onLong: () async {
                                  await carController.deleteCar(
                                      id: controller.carsADM[index].id ?? '');
                                },
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CarDetailsPage(
                                            carID:
                                                controller.carsADM[index].id!,
                                          )));
                                },
                              )),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
