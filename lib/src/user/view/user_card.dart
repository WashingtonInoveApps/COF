import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class CardUser extends StatelessWidget {
  final UserModel user;
  final Function() onStatus;
  const CardUser({Key? key, required this.user, required this.onStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: user.graduation.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.graduation,
                    style: Constants.subtitle.copyWith(color: Colors.grey),
                  ),
                  const Divider(),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.name.toUpperCase(),
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: onStatus,
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: user.enable
                                ? Theme.of(context).primaryColor
                                : Colors.red),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      user.enable ? 'Liberado' : 'Bloqueado',
                      style: Constants.subtitle.copyWith(
                          color: user.enable
                              ? Theme.of(context).primaryColor
                              : Colors.red),
                    ),
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Matricula ',
                        style: Constants.title.copyWith(color: Colors.grey),
                      ),
                      Expanded(
                        child: Text(
                          user.registration.toUpperCase(),
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Contato ',
                        style: Constants.title.copyWith(color: Colors.grey),
                      ),
                      Expanded(
                        child: Text(
                          user.contact.toUpperCase(),
                          style: Constants.title
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
