import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class AlertMultMessage extends StatelessWidget {
  final List<String> messages;
  const AlertMultMessage({Key? key, required this.messages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      content: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.grey,
              )),
          Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: messages.map((err) {
              return Row(
                spacing: 10,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 20,
                  ),
                  Expanded(
                    child: Text(
                      err,
                      style: Constants.title,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
