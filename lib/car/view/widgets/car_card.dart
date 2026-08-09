import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/car_enum.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  final bool options;
  final Function() onTap;
  const CarCard({
    Key? key,
    required this.car,
    required this.onTap,
    this.options = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.prefix,
                        style: Constants.title
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        car.model,
                        style: Constants.title.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 140,
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
                        style: Constants.title.copyWith(color: car.state.color),
                      )),
                ),
              ],
            ),
            const Divider(),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 35,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Visibility(
                            visible: options,
                            child: SizedBox(
                              width: 80.0,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(5)),
                                      side: BorderSide(
                                          color:
                                              Theme.of(context).primaryColor)),
                                  onPressed: onTap,
                                  child: Text(
                                    "Detalhes",
                                    style: Constants.subtitle.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold),
                                  )),
                            )),
                      ],
                    ),
                  ),
                ),
                Text(
                  car.km.toString(),
                  style: Constants.title.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  " KM",
                  style: Constants.subtitleHint,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
