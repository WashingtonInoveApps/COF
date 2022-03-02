import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardCarSupply extends StatelessWidget {
  final SupplyModel supply;
  const CardCarSupply({Key? key, required this.supply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formatDate(supply.date),
            style: title.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Row(
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
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Row(
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
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Row(
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
