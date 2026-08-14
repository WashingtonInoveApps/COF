import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:flutter/material.dart';

class CardCarSupply extends StatelessWidget {
  final SupplyModel supply;
  final bool details;
  final Function()? onTap;
  const CardCarSupply(
      {Key? key, required this.supply, this.details = false, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "${Core.formatDate(supply.date)} - ${supply.user.name}",
                  style: Constants.subtitleHint,
                ),
              ),
              (onTap == null)
                  ? Container()
                  : InkWell(
                      onTap: onTap,
                      child: Text('Remover',
                          style: Constants.subtitle
                              .copyWith(color: Theme.of(context).primaryColor)))
            ],
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
                    style: Constants.subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    supply.km,
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Litros",
                    style: Constants.subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    supply.litros.toStringAsFixed(2),
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Valor",
                    style: Constants.subtitleHint,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "R\$ ${supply.value.toStringAsFixed(2)}",
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold),
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
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            child: body,
          )
        : Card(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: body,
          );
  }
}
