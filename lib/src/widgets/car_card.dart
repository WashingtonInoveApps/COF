import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/src/car/car_mapa_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final Function() onTap;
  const CarCard({Key? key, required this.car, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${car.resgaste} - ${car.modelo}",
                      style: title.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    car.enable ? MdiIcons.checkCircle : MdiIcons.closeCircle,
                    color: Theme.of(context).primaryColor,
                    size: 20.0,
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  car.adm
                      ? SizedBox(
                          width: 75.0,
                          child: TextButton(
                              style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CarMapaPage(
                                          car: car,
                                        )));
                              },
                              child: Text(
                                "MAPA",
                                style: subtitle.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              )),
                        )
                      : Container(
                          height: 40.0,
                        ),
                  Expanded(
                    child: Container(),
                  ),
                  Text(
                    "PLACA",
                    style: subtitleHint,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    car.placa,
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "KM",
                    style: subtitleHint,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    car.km.toString(),
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
