import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:flutter/material.dart';

import '../../../core/constants.dart';

class CardUser extends StatelessWidget {
  final UserModel user;
  final OBMModel obm;
  final Function() onEdit;
  final Function() onDelete;
  final Function(bool) onEnable;

  const CardUser({
    Key? key,
    required this.user,
    required this.obm,
    required this.onEdit,
    required this.onDelete,
    required this.onEnable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              obm.prefix,
              style: Constants.titleHint,
            ),
            Text(
              obm.name,
              style: Constants.subtitleHint,
            ),
            Core.boldFirstName(
              graduation: user.graduation.toUpperCase(),
              name: user.name.toUpperCase(),
              fullName: user.fullname.toUpperCase(),
              normalStyle: Constants.title,
            ),
            Text.rich(
              TextSpan(text: 'Matrícula  ', children: [
                TextSpan(
                    text: user.registration,
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold)),
                const TextSpan(text: '  Contato  '),
                TextSpan(
                    text: user.contact,
                    style:
                        Constants.title.copyWith(fontWeight: FontWeight.bold)),
              ]),
              style: Constants.subtitleHint,
            ),
            Text(
              user.email,
              style: Constants.subtitleHint,
            ),
            const Divider(),
            Row(
              spacing: 10,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    onPressed: onEdit,
                    child: Text(
                      "Alterar",
                      style: Constants.title
                          .copyWith(color: Theme.of(context).primaryColor),
                    )),
                TextButton(
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side:
                            BorderSide(color: Theme.of(context).primaryColor)),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertMessage(
                              title: 'Atenção',
                              message:
                                  'Deseja excluir o registro desse usuário ?',
                              titleOK: 'Sim',
                              cancel: true,
                              onPressedCancel: () =>
                                  Navigator.of(context).pop(false),
                              onPressedOK: () => Navigator.of(context)
                                  .pop(true))).then((value) {
                        if (value ?? false) {
                          onDelete();
                        }
                      });
                    },
                    child: Text(
                      "Excluir",
                      style: Constants.title
                          .copyWith(color: Theme.of(context).primaryColor),
                    )),
                const Spacer(),
                Switch(
                    value: user.enable,
                    padding: EdgeInsets.zero,
                    activeThumbColor: Constants.primary,
                    onChanged: (value) {
                      onEnable(value);
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
