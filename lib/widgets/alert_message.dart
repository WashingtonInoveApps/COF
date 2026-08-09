// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../core/constants.dart';

class AlertMessage extends StatelessWidget {
  final String title;
  final String message;
  final String titleOK;
  final String cancelTitle;
  final bool ok;
  final bool cancel;
  final Function() onPressedOK;
  final Function()? onPressedCancel;

  const AlertMessage({
    Key? key,
    this.title = '',
    required this.message,
    this.titleOK = '',
    this.cancelTitle = '',
    this.ok = true,
    this.cancel = false,
    required this.onPressedOK,
    this.onPressedCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        title,
        style: Constants.title,
        textAlign: TextAlign.center,
      ),
      titleTextStyle: Constants.title.copyWith(
        fontWeight: FontWeight.bold,
      ),
      titlePadding: const EdgeInsets.only(top: 20.0, left: 10.0),
      content: Text(
        message,
        style: Constants.title,
        textAlign: TextAlign.center,
      ),
      contentTextStyle: Constants.subtitle,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      actions: <Widget>[
        Visibility(
          visible: cancel,
          child: TextButton(
            style: TextButton.styleFrom(
              side: BorderSide.none,
            ),
            onPressed: onPressedCancel,
            child: Text(
              cancelTitle.isEmpty ? "Cancelar" : cancelTitle,
              style: Constants.subtitle.copyWith(color: Colors.grey),
            ),
          ),
        ),
        Visibility(
          visible: ok,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Constants.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(50))),
            onPressed: onPressedOK,
            child: Text(
              titleOK.isEmpty ? "OK" : titleOK,
              style: Constants.subtitle.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
