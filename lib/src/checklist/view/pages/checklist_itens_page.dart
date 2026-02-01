import 'package:bsu_control/src/checklist/controller/checklist_controller.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class ChecklistItensPage extends StatefulWidget {
  final CheckListController controller;
  const ChecklistItensPage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<ChecklistItensPage> createState() => _ChecklistItensPageState();
}

class _ChecklistItensPageState extends State<ChecklistItensPage> {
  late CheckListController controller;
  late ReactionDisposer _dispose;

  double width = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    width = processWidth(controller.app.maxWidth);

    _dispose = reaction<double>((_) => controller.app.maxWidth, (value) {
      setState(() {
        width = processWidth(value);
      });
    });
  }

  double processWidth(double value) {
    if (value <= 500) return value;

    return value * 0.48;
  }

  @override
  void dispose() {
    super.dispose();
    _dispose.reaction.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: [
          SizedBox(
              width: width,
              child: Column(
                children: [Text("Itens")],
              )),
          SizedBox(width: width, child: Column()),
        ],
      ),
    );
  }
}
