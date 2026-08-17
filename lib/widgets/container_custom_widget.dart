import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class ContainerCustom extends StatelessWidget {
  final String label;
  final Color? color;
  const ContainerCustom({Key? key, required this.label, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color ?? Constants.primary,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        label,
        style: Constants.titleButton,
      ),
    );
  }
}
