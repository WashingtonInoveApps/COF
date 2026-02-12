import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ConfigViewWidget extends StatelessWidget {
  final DateTime dateStart;
  final DateTime dateFinish;
  final Function(DateTime?) onDateStart;
  final Function(DateTime?) onDateFinish;
  final Function()? onReset;
  final Function()? onChange;

  const ConfigViewWidget(
      {Key? key,
      required this.dateStart,
      required this.dateFinish,
      required this.onDateStart,
      required this.onDateFinish,
      this.onReset,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              children: [
                const Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 20,
                ),
                Expanded(
                  child: Text(
                    'Configuração de exibição',
                    style: Constants.titleHint,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: dateStart,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 10)),
                        lastDate: DateTime.now())
                    .then(onDateStart);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data inicial',
                      style: Constants.subtitleHint,
                    ),
                    Text(
                      Core.formatDate(dateStart, largeDay: true),
                      style: Constants.title,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: dateFinish,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 10)),
                        lastDate: DateTime.now())
                    .then(onDateFinish);
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data final',
                      style: Constants.subtitleHint,
                    ),
                    Text(
                      Core.formatDate(dateFinish, largeDay: true),
                      style: Constants.title,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                  child: ElevatedButton.icon(
                      onPressed: onReset,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400),
                      icon: Icon(
                        MdiIcons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Limpar',
                        style: Constants.titleButton,
                      )),
                ),
                SizedBox(
                  height: 35,
                  child: ElevatedButton.icon(
                      onPressed: onChange,
                      icon: Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Aplicar',
                        style: Constants.titleButton,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
