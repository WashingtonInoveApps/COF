import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:flutter/material.dart';

class CheckListCard extends StatelessWidget {
  final CheckListModel checkList;
  final Function() onTap;
  final Function()? onDelete;
  const CheckListCard(
      {Key? key,
      required this.checkList,
      required this.onTap,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onDelete,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PREFIXO",
                          style: Constants.subtitleHint,
                        ),
                        Text(
                          "${checkList.prefix} - ${checkList.alfa}",
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PONTO BASE",
                          style: Constants.subtitleHint,
                        ),
                        Text(
                          checkList.pb.toUpperCase(),
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                "CONDUTOR",
                style: Constants.subtitleHint,
              ),
              Text(
                "${checkList.user.name.toUpperCase()} - ${checkList.user.registration}",
                style: Constants.title.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KM INICIAL",
                          style: Constants.subtitleHint,
                        ),
                        Text(
                          checkList.kmStart,
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KM FINAL",
                          style: Constants.subtitleHint,
                        ),
                        Text(
                          checkList.kmFinal.isEmpty ? '--' : checkList.kmFinal,
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
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
