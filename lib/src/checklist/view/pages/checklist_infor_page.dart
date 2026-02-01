import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CheckListInforPage extends StatefulWidget {
  final CheckListController controller;
  const CheckListInforPage({Key? key, required this.controller})
      : super(key: key);

  @override
  State<CheckListInforPage> createState() => _CheckListInforPageState();
}

class _CheckListInforPageState extends State<CheckListInforPage> {
  late CheckListController controller;

  final maskContact = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    controller.setOBM(controller.app.obms
        .firstWhere((e) => e.id == controller.app.user.obmID));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Constants.primary,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              'INFORMAÇÕES BÁSICAS',
              style: Constants.titleButton,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              showDatePicker(
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 1)),
                      lastDate: DateTime.now())
                  .then(controller.changeDate);
            },
            child: Container(
              height: 45,
              alignment: Alignment.centerLeft,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey)),
              child: Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Data',
                    style: Constants.titleHint,
                  ),
                  Expanded(
                    child: Observer(builder: (_) {
                      return Text(
                        Core.formatDate(widget.controller.date, largeDay: true),
                      );
                    }),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(text: "ORGANIZAÇÃO ", children: [
              TextSpan(
                  text: '*', style: Constants.title.copyWith(color: Colors.red))
            ]),
            style: Constants.subtitleHint,
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 45.0,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0)),
            child: Observer(builder: (_) {
              return DropdownButton<OBMModel>(
                  isExpanded: true,
                  value: controller.obm,
                  underline: Container(),
                  onChanged: controller.setOBM,
                  items: controller.app.obms
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    e.prefix,
                                    style: Constants.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    e.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.subtitle
                                        .copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList());
            }),
          ),
          Observer(builder: (context) {
            return Visibility(
                visible: (controller.cia != null),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(text: "COMPANHIA ", children: [
                        TextSpan(
                            text: '*',
                            style: Constants.title.copyWith(color: Colors.red))
                      ]),
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButton<String?>(
                          isExpanded: true,
                          value: controller.cia,
                          underline: Container(),
                          onChanged: controller.setCia,
                          items: controller.obm.cias
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(e.toUpperCase(),
                                          style: Constants.title),
                                    ),
                                  ))
                              .toList()),
                    ),
                  ],
                ));
          }),
          Observer(builder: (context) {
            return Visibility(
                visible: (controller.obm.team.isNotEmpty),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(text: "GUARNIÇÃO ", children: [
                        TextSpan(
                            text: '*',
                            style: Constants.title.copyWith(color: Colors.red))
                      ]),
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 45.0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: DropdownButton<String?>(
                          isExpanded: true,
                          value: controller.team,
                          underline: Container(),
                          onChanged: controller.setTeam,
                          items: controller.obm.team
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Text(
                                        e.toUpperCase(),
                                        style: Constants.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ))
                              .toList()),
                    ),
                  ],
                ));
          }),
          const SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(text: "CONTATO ", children: [
              TextSpan(
                  text: '*', style: Constants.title.copyWith(color: Colors.red))
            ]),
            style: Constants.subtitleHint,
          ),
          const SizedBox(
            height: 5,
          ),
          FieldText(
            initValue: controller.contact,
            hint: "(85) 90000-0000",
            inputType: TextInputType.number,
            mask: [maskContact],
            onChange: controller.setContact,
          ),
        ],
      ),
    );
  }
}
