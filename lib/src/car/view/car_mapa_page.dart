import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/src/car/controller/car_controller.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../repository/car_repository.dart';
import '../../widgets/car_mapa_card.dart';

class CarMapaPage extends StatefulWidget {
  final CarModel car;
  const CarMapaPage({Key? key, required this.car}) : super(key: key);

  @override
  State createState() => _CarMapaPageState();
}

class _CarMapaPageState extends State<CarMapaPage> {
  late CarController controller;
  final app = GetIt.I.get<AppController>();

  cardMapa(CarMapaModel mapa, int kmPercorrido) => Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDate(mapa.date),
                style: title,
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.locationEnter,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          mapa.origin.toUpperCase(),
                          style: subtitle.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        MdiIcons.locationExit,
                        size: 20,
                        color: Colors.green,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          mapa.destiny.toUpperCase(),
                          style: subtitle.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "KM Inicial",
                          style: subtitleHint,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          mapa.kmStart,
                          style: title.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15.0,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "KM Final",
                          style: subtitleHint,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          mapa.kmFinal,
                          style: title.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "${mapa.user.name} ( ${mapa.user.matricula} )",
                    style: title,
                  )),
                  Text("$kmPercorrido KM", style: title)
                ],
              )
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    controller = CarController(app: app, repository: CarRepository());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarCustom(),
              Expanded(
                child: StreamBuilder<List<CarMapaModel>>(
                    stream: controller.listenMapas(carId: widget.car.id!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const LinearProgressIndicator();
                      }

                      final mapas = (snapshot.data ?? []);
                      mapas.sort((a, b) => b.date.compareTo(a.date));

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: LayoutBuilder(builder: (context, constrains) {
                          double width = constrains.maxWidth > 500
                              ? 500.0
                              : constrains.maxWidth;
                          return Container(
                            width: width,
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.car.prefix} - MAPA",
                                        style: titleHint,
                                      ),
                                    ),
                                    TextButton.icon(
                                        style: TextButton.styleFrom(
                                            side: BorderSide(
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  CarMapaWidget(
                                                    user: app.user,
                                                    carId: widget.car.id!,
                                                    onInsert: (value) async {
                                                      await controller
                                                          .insertMapaCar(
                                                              mapa: value);
                                                    },
                                                  ));
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        label: Text(
                                          "Adicionar",
                                          style: title.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                mapas.isEmpty
                                    ? Center(
                                        child: Text(
                                          "Ops ! Nenhuma informação encontrada.",
                                          style: title,
                                        ),
                                      )
                                    : Column(
                                        children: List.generate(mapas.length,
                                            (index) {
                                          final kmPercorrido = int.parse(
                                                  mapas[index].kmFinal) -
                                              int.parse(mapas[index].kmStart);

                                          return GestureDetector(
                                            onLongPress: (app.user.id ==
                                                        mapas[index].user.id) ||
                                                    (app.user.admin)
                                                ? () async {
                                                    final result = await showDialog(
                                                        context: context,
                                                        builder: (context) => AlertMessage(
                                                            title: "Atenção",
                                                            message:
                                                                "Deseja excluir esse registro ?",
                                                            cancel: true,
                                                            onPressedCancel: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            onPressedOK: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(
                                                                        true)));

                                                    if (result) {
                                                      controller
                                                          .deleteCarMapa(
                                                              id: mapas[index]
                                                                  .id)
                                                          .then((value) {
                                                        if (!value) {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) => AlertMessage(
                                                                  title:
                                                                      "Atenção",
                                                                  message:
                                                                      "Ops ! Falha ao excluir registro.",
                                                                  onPressedOK: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop()));
                                                        }
                                                      });
                                                    }
                                                  }
                                                : null,
                                            child: cardMapa(
                                                mapas[index], kmPercorrido),
                                          );
                                        }),
                                      ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
              ),
            ],
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
