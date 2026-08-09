import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/services_enum.dart';
import 'package:bsu_control/model/service_model.dart';
import 'package:bsu_control/widgets/alert_message.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';

class CardComponentWidget extends StatefulWidget {
  final ServicesComponent component;
  final Function()? onDelet;
  final Function(ServicesComponent) onChange;
  const CardComponentWidget(
      {Key? key, required this.component, this.onDelet, required this.onChange})
      : super(key: key);

  @override
  State<CardComponentWidget> createState() => _CardComponentWidgetState();
}

class _CardComponentWidgetState extends State<CardComponentWidget> {
  @override
  Widget build(BuildContext context) {
    final component = widget.component;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          List.generate(component.functions.length, (index) {
                        final e = component.functions[index];
                        return Center(
                          child: InkWell(
                            onLongPress: component.functions.length > 1
                                ? () {
                                    final result = [...component.functions];
                                    result.removeAt(index);

                                    widget.onChange(
                                        component.copyWith(functions: result));
                                  }
                                : null,
                            child: IntrinsicWidth(
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: e.color),
                                child: Text(
                                  e.label,
                                  style: Constants.subtitle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  PopupMenuButton<ServiceFunctions>(
                      onSelected: (fun) {
                        final result = [...component.functions, fun];
                        widget.onChange(component.copyWith(functions: result));
                      },
                      itemBuilder: (context) => [
                            ...List.generate(ServiceFunctions.values.length,
                                (index) {
                              final fun = ServiceFunctions.values[index];
                              return PopupMenuItem<ServiceFunctions>(
                                  value: fun,
                                  child: Text(
                                    fun.label,
                                    style: Constants.title,
                                  ));
                            }),
                          ],
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.grey,
                      )),
                  Visibility(
                    visible: widget.onDelet != null,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertMessage(
                                    message: 'Deseja excluir esse componente ?',
                                    cancel: true,
                                    titleOK: 'Sim',
                                    onPressedOK: () =>
                                        Navigator.of(context).pop(true),
                                    onPressedCancel: () =>
                                        Navigator.of(context).pop(false),
                                  )).then((value) {
                            if (value ?? false) {
                              widget.onDelet?.call();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.grey,
                        )),
                  ),
                ],
              ),
            ),
            Text(
              component.user.graduation,
              style: Constants.subtitleHint,
            ),
            Core.boldFirstName(
                name: component.user.name,
                fullName: component.user.fullname,
                style: Constants.title),
            Text(
              component.user.registration,
              style: Constants.subtitleHint,
            ),
            const Divider(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade700),
                child: Text(
                  component.period.label,
                  style: Constants.subtitle.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDateTimePickerDialog(
                        context: context, initialDateTime: component.startDate)
                    .then((result) {
                  if (result != null) {
                    widget.onChange.call(component.copyWith(
                      startDate: result,
                    ));
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Text(
                        'Inicio',
                        style: Constants.subtitleHint,
                      ),
                    ),
                    Center(
                      child: Text(
                        Core.formatDate(component.startDate, shortHour: true),
                        style: Constants.subtitle,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDateTimePickerDialog(
                        context: context, initialDateTime: component.endDate)
                    .then((result) {
                  if (result != null) {
                    widget.onChange.call(component.copyWith(
                      endDate: result,
                    ));
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Text(
                        'Final',
                        style: Constants.subtitleHint,
                      ),
                    ),
                    Center(
                      child: Text(
                        Core.formatDate(component.endDate, shortHour: true),
                        style: Constants.subtitle,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<DateTime?> showDateTimePickerDialog({
  required BuildContext context,
  DateTime? initialDateTime,
}) async {
  DateTime selectedDateTime = initialDateTime ?? DateTime.now();

  return showDialog<DateTime>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Selecionar data e hora',
              style: Constants.title,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // DATA
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime,
                      firstDate:
                          selectedDateTime.subtract(const Duration(days: 1)),
                      lastDate: selectedDateTime.add(const Duration(days: 1)),
                    );

                    if (date != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          selectedDateTime.hour,
                          selectedDateTime.minute,
                        );
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        const Icon(Icons.calendar_today),
                        Text(
                          Core.formatDate(selectedDateTime),
                          style: Constants.title,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        selectedDateTime,
                      ),
                    );

                    if (time != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          selectedDateTime.year,
                          selectedDateTime.month,
                          selectedDateTime.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(width: 10),
                        Text(
                          '${selectedDateTime.hour.toString().padLeft(2, '0')}:'
                          '${selectedDateTime.minute.toString().padLeft(2, '0')}',
                          style: Constants.title,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(side: BorderSide.none),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancelar',
                  style: Constants.subtitleHint,
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    selectedDateTime,
                  );
                },
                child: Text(
                  'Confirmar',
                  style: Constants.title.copyWith(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
