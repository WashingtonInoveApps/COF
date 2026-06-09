import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class LimitTableWidget extends StatelessWidget {
  final int limit;
  final Function(int?) onChange;
  const LimitTableWidget(
      {Key? key, required this.limit, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Text(
          'Mostrar',
          style: Constants.subtitleHint,
        ),
        Container(
          height: 40,
          width: 65,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0)),
          child: DropdownButton<int>(
              isExpanded: true,
              value: limit,
              underline: Container(),
              onChanged: onChange,
              items: [1, 2, 5, 10, 25, 50, 75, 100]
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            e.toString(),
                            style: Constants.subtitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
