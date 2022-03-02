import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_mapa_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class CarMapaPage extends StatefulWidget {
  final CarModel car;
  const CarMapaPage({Key? key, required this.car}) : super(key: key);

  @override
  _CarMapaPageState createState() => _CarMapaPageState();
}

class _CarMapaPageState extends State<CarMapaPage> {
  final controller = GetIt.I.get<AppController>();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    mapa.origem,
                    style: subtitle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 20.0,
                    color: Theme.of(context).primaryColor,
                  ),
                  Text(
                    mapa.destino,
                    style: subtitle.copyWith(fontWeight: FontWeight.bold),
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
                          mapa.kmInicial,
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(),
      body: Stack(
        children: [
          StreamBuilder<List<CarMapaModel>>(
              stream: controller.listenMapas(carId: widget.car.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();

                final mapas = (snapshot.data ?? []);
                mapas.sort((a, b) => b.date.compareTo(a.date));

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.car.resgaste} - MAPA",
                              style: titleHint,
                            ),
                          ),
                          TextButton.icon(
                              style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => MapaWidget(
                                          user: controller.user,
                                          carId: widget.car.id,
                                          onInsert: (value) async {
                                            await controller.insertMapaCar(mapa: value);
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
                                style: title.copyWith(color: Theme.of(context).primaryColor),
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
                              children: List.generate(mapas.length, (index) {
                                final kmPercorrido = int.parse(mapas[index].kmFinal) - int.parse(mapas[index].kmInicial);

                                return GestureDetector(
                                  onLongPress: (controller.user.id == mapas[index].user.id) || (controller.user.adm)
                                      ? () async {
                                          final result = await showDialog(
                                              context: context,
                                              builder: (context) => AlertMessage(
                                                  title: "Atenção",
                                                  message: "Deseja excluir esse registro ?",
                                                  cancel: true,
                                                  onPressedCancel: () => Navigator.of(context).pop(false),
                                                  onPressedOK: () => Navigator.of(context).pop(true)));

                                          if (result) {
                                            controller.deleteCarMapa(id: mapas[index].id).then((value) {
                                              if (!value) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) => AlertMessage(
                                                        title: "Atenção",
                                                        message: "Ops ! Falha ao excluir registro.",
                                                        onPressedOK: () => Navigator.of(context).pop()));
                                              }
                                            });
                                          }
                                        }
                                      : null,
                                  child: cardMapa(mapas[index], kmPercorrido),
                                );
                              }),
                            ),
                    ],
                  ),
                );
              }),
          Observer(builder: (_) {
            return IgnorePointer(
              ignoring: !controller.loading,
              child: Container(
                color: controller.loading ? Colors.black54 : Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(controller.loading ? Colors.white : Colors.transparent),
                )),
              ),
            );
          })
        ],
      ),
    );
  }
}

class MapaWidget extends StatefulWidget {
  final UserModel user;
  final String carId;
  final Function(CarMapaModel mapa) onInsert;
  const MapaWidget({Key? key, required this.user, required this.onInsert, required this.carId}) : super(key: key);

  @override
  State<MapaWidget> createState() => _MapaWidgetState();
}

class _MapaWidgetState extends State<MapaWidget> {
  final _key = GlobalKey<FormState>();

  late CarMapaModel mapa;

  @override
  void initState() {
    super.initState();
    mapa = CarMapaModel(date: DateTime.now(), user: widget.user, carId: widget.carId);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(6),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldText(
              hint: "ORIGEM",
              validation: Validation.validatorPreenchimento,
              onSaved: (value) {
                mapa.origem = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "DESTINO",
              validation: Validation.validatorPreenchimento,
              onSaved: (value) {
                mapa.destino = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "KM INICIAL",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                mapa.kmInicial = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "KM FINAL",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                mapa.kmFinal = value!;
              },
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
                        _key.currentState!.save();

                        Navigator.of(context).pop();
                        widget.onInsert(mapa);
                      }
                    },
                    child: Text("INSERIR", style: titleButton)))
          ],
        ),
      ),
    );
  }
}
