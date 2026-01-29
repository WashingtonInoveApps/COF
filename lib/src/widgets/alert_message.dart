import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class AlertMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? titleOK;
  final String? titleCancel;
  final bool ok;
  final bool cancel;
  final Function() onPressedOK;
  final Function()? onPressedCancel;
  final Icon? icons;

  const AlertMessage(
      {Key? key,
      required this.title,
      required this.message,
      this.titleCancel,
      this.titleOK,
      required this.onPressedOK,
      this.cancel = false,
      this.ok = true,
      this.icons,
      this.onPressedCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        title.toUpperCase(),
        style: Constants.title,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Constants.title,
      titlePadding: const EdgeInsets.only(top: 20.0, left: 10.0, bottom: 10.0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icons ??
              const SizedBox(
                width: 1.0,
              ),
          Flexible(
            flex: 1,
            child: Text(
              message,
              style: Constants.title,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      contentTextStyle: Constants.title,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      actions: <Widget>[
        cancel
            ? TextButton(
                onPressed: onPressedCancel,
                child: Text(
                  titleCancel ?? "Cancelar",
                  style: Constants.title.copyWith(color: Colors.grey),
                ),
              )
            : Container(),
        ok
            ? TextButton(
                onPressed: onPressedOK,
                child: Text(
                  titleOK ?? "OK",
                  style: Constants.title
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              )
            : Container(),
      ],
    );
  }
}
