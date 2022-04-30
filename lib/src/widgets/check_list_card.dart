import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';

class CheckListCard extends StatelessWidget {
  final CheckListModel checkList;
  final Function() onTap;
  const CheckListCard({Key? key, required this.checkList, required this.onTap}) : super(key: key);

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
                      "${checkList.prefix} - ${checkList.alfa}",
                      style: title.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    checkList.pb,
                    style: title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "Condutor",
                style: subtitleHint,
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "${checkList.user.name} - ${checkList.user.matricula}",
                style: title.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10.0,
              ),
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
                          checkList.kmStart,
                          style: title.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15.0,),
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
                          checkList.kmFinal,
                          style: title.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
