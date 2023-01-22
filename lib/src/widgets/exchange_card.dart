import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';

class ExchangeCard extends StatelessWidget {
  final UserModel user;
  final ExchangeModel exchange;
  final Function() onConfirmRequested;
  final Function() onAuthorized;
  final Function() onDownload;

  const ExchangeCard(
      {Key? key,
      required this.exchange,
      required this.user,
      required this.onAuthorized,
      required this.onDownload,
      required this.onConfirmRequested})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SOLICITANTE',
              style: subtitleHint,
            ),
            Text(
              '${exchange.requester!.graduacao} ${exchange.requester!.name} - ${exchange.requester!.matricula}',
              style: title.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'SOLICITADO',
              style: subtitleHint,
            ),
            Text(
              '${exchange.requested!.graduacao} ${exchange.requested!.name} - ${exchange.requested!.matricula}',
              style: title.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORIGEM',
                        style: subtitleHint,
                      ),
                      Text(
                        exchange.baseFirst,
                        style: title,
                      ),
                      Text(
                        formatDate(exchange.dateFirst!, outher: true),
                        style: title.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DESTINO',
                        style: subtitleHint,
                      ),
                      Text(
                        exchange.baseLast,
                        style: title,
                      ),
                      Text(
                        formatDate(exchange.dateLast!, outher: true),
                        style: title.copyWith(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            const SizedBox(
              height: 5,
            ),
            Visibility(
                visible: (exchange.requester!.id == user.id) &&
                    (exchange.authorizer == null),
                child: Text(
                  'AGUARDANDO AUTORIZAÇÃO DA PERMUTA',
                  style: subtitleHint,
                )),
            Visibility(
              visible: exchange.authorizer != null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERMUTA AUTORIZADA POR ${exchange.authorizer?.graduacao} ${exchange.authorizer?.name} EM ${formatDate(exchange.authorizedDate ?? DateTime.now())}',
                    style: subtitleHint,
                  ),
                  const Divider()
                ],
              ),
            ),
            Visibility(
              visible: (exchange.requested!.id == user.id) &&
                  (exchange.requestedAuthorizedDate == null),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 45.0,
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                      onPressed: onConfirmRequested,
                      child: Text(
                        "CONFIRMAR PERMUTA",
                        style: titleButton,
                      )),
                ),
              ),
            ),
            Visibility(
              visible: (user.admin && exchange.authorizer == null),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 45.0,
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                      onPressed: exchange.requestedAuthorizedDate != null
                          ? onAuthorized
                          : null,
                      child: Text(
                        "AUTORIZAR PERMUTA",
                        style: titleButton,
                      )),
                ),
              ),
            ),
            Visibility(
              visible: (exchange.authorizer != null),
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 45.0,
                  width: 200,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                      onPressed: onDownload,
                      child: Text(
                        "BAIXAR ARQUIVO",
                        style: titleButton,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
