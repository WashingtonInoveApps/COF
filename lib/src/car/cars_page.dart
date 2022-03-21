import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/car_details_page.dart';
import 'package:bsu_control/src/car/car_register_page.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CarsPage extends StatefulWidget {
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  final controller = GetIt.I.get<AppController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const AppBarCustom(
          page: 2,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "VIATURAS",
                      style: titleHint,
                    ),
                  ),
                  controller.enable
                      ? TextButton.icon(
                          style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CarRegisterPage()));
                          },
                          icon: Icon(
                            Icons.add,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            "Adicionar",
                            style: title.copyWith(color: Theme.of(context).primaryColor),
                          ))
                      : Container(),
                ],
              ),
              const Divider(),
              const SizedBox(
                height: 5.0,
              ),
              Observer(builder: (_) {
                return controller.cars.isEmpty
                    ? Center(
                        child: Text(
                          "Ops ! Nenhuma informação encontrada.",
                          style: title,
                        ),
                      )
                    : Column(
                        children: [
                          Column(
                            children: List.generate(
                                controller.carsOPR.length,
                                (index) => CarCard(
                                      car: controller.carsOPR[index],
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CarDetailsPage(
                                                  carId: controller.carsOPR[index].id,
                                                )));
                                      },
                                    )),
                          ),
                          Column(
                            children: List.generate(
                                controller.carsADM.length,
                                (index) => CarCard(
                                      car: controller.carsADM[index],
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CarDetailsPage(
                                                  carId: controller.carsADM[index].id,
                                                )));
                                      },
                                    )),
                          ),
                        ],
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
