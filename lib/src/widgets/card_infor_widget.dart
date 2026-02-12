import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class CardInfoWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double value;
  const CardInfoWidget(
      {Key? key,
      required this.icon,
      required this.label,
      required this.color,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: color),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                ...label
                    .split(' ')
                    .map((e) => Text(
                          e.toUpperCase(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Constants.subtitle.copyWith(color: Colors.grey),
                        ))
                    .toList(),
                Text(
                  value.toString().padLeft(2, '0'),
                  style: Constants.title.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
