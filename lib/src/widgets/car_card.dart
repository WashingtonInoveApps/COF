import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../car/view/car_mapa_page.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final Function() onTap;
  final Function()? onLong;
  const CarCard({Key? key, required this.car, required this.onTap, this.onLong})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLong,
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
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.prefix,
                          style:
                              Core.title.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          car.model,
                          style: Core.title.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                        style: TextButton.styleFrom(
                            side: BorderSide(color: car.state.color)),
                        onPressed: null,
                        icon: Icon(
                          car.state.icon,
                          color: car.state.color,
                          size: 20.0,
                        ),
                        label: Text(
                          car.state.label,
                          style: Core.title.copyWith(color: car.state.color),
                        )),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  car.adm
                      ? SizedBox(
                          height: 35,
                          width: 80.0,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor)),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CarMapaPage(
                                          car: car,
                                        )));
                              },
                              child: Text(
                                "MAPA",
                                style: Core.subtitle.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold),
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
                    style: Core.subtitleHint,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    car.plate,
                    style: Core.title.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "KM",
                    style: Core.subtitleHint,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    car.km.toString(),
                    style: Core.title.copyWith(fontWeight: FontWeight.bold),
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
