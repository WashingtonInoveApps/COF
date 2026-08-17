import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color color;
  final double? width;

  const TagWidget(
      {Key? key,
      this.icon,
      required this.label,
      required this.color,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(5)),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon == null ? Container() : Icon(icon, color: Colors.white),
          Expanded(
            child: Text(
              label,
              style: Constants.subtitle.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
