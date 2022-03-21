import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:flutter/material.dart';

class CardCarSupply extends StatelessWidget {
  final SupplyModel supply;
  final bool details;
  const CardCarSupply({Key? key, required this.supply, this.details = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${formatDate(supply.date)} - ${supply.user.name}",
            style: subtitleHint,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "KM",
                    style: subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    supply.kmAbastecimento,
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Litros",
                    style: subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    supply.litros.toStringAsFixed(2),
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Valor",
                    style: subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "R\$ ${supply.value.toStringAsFixed(2)}",
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    return details
        ? Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
            child: body,
          )
        : Card(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: body,
          );
  }
}
