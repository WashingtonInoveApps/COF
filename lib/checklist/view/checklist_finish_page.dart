import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/checklist/view/widget/insert_material_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:signature/signature.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/textfield_widget.dart';

class ChecklistFinishPage extends StatefulWidget {
  final CheckListController controller;
  final ChecklistModel checklist;
  const ChecklistFinishPage(
      {Key? key, required this.checklist, required this.controller})
      : super(key: key);

  @override
  State<ChecklistFinishPage> createState() => _ChecklistFinishPageState();
}

class _ChecklistFinishPageState extends State<ChecklistFinishPage> {
  final signatureController = SignatureController();
  final endKMController = TextEditingController();
  final obsController = TextEditingController();

  final key = GlobalKey<FormState>();

  late ChecklistModel checklist;
  String label = '';

  @override
  void initState() {
    super.initState();
    checklist = widget.checklist;
  }

  @override
  void dispose() {
    super.dispose();
    endKMController.dispose();
    signatureController.dispose();
    obsController.dispose();
  }

  Future<bool> finishChecklist() async {
    try {
      widget.controller.setLoading(true);
      final image = await signatureController.toPngBytes();

      await widget.controller.finish(
          checklist: checklist.copyWith(
              endKM: int.parse(endKMController.text), obs: obsController.text),
          image: image);
      widget.controller.setLoading(false);

      return true;
    } catch (e) {
      widget.controller.setLoading(false);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: key,
          child: BackgraundPage(
            menu: false,
            onBack: () => Navigator.of(context).pop(),
            childLeft: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "INFORMAÇÕES BÁSICAS",
                    style: Constants.titleButton,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  checklist.cia?.name ?? '',
                  style: Constants.title.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${checklist.prefix} - ${checklist.team}',
                  style: Constants.title,
                ),
                Text(
                  Core.formatDate(checklist.date, largeDayHour: true),
                  style: Constants.titleHint,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Responsável",
                  style: Constants.titleHint,
                ),
                Core.boldFirstName(
                    graduation: checklist.user.graduation,
                    name: checklist.user.name,
                    fullName: checklist.user.fullname),
                Text(
                  checklist.user.registration,
                  style: Constants.titleHint,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KM Inicial",
                            style: Constants.titleHint,
                          ),
                          Text(
                            checklist.startKM.toString(),
                            style: Constants.title,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KM Final",
                            style: Constants.titleHint,
                          ),
                          Text(
                            (checklist.endKM <= 0
                                ? ' - '
                                : checklist.endKM.toString()),
                            style: Constants.title,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
                    "MATERIAIS UTILIZADOS",
                    style: Constants.titleButton,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Insira os materiais consumidos durante o serviço.',
                  style: Constants.subtitleHint,
                ),
                const SizedBox(
                  height: 10,
                ),
                Observer(builder: (context) {
                  return (widget.controller.materialsConsumedUsed.isEmpty)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 5, right: 5),
                          child: Column(
                            children: List.generate(
                                    widget.controller.materialsConsumedUsed
                                        .length, (index) {
                              final material = widget
                                  .controller.materialsConsumedUsed[index];
                              return Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        material.description,
                                        style: Constants.title,
                                      ),
                                      Text(
                                        '${material.quantity.toString().padLeft(2, '0')} unidade(s)',
                                        style: Constants.subtitleHint,
                                      ),
                                    ],
                                  )),
                                  IconButton(
                                    onPressed: () {
                                      widget.controller
                                          .deleteMaterialsConsumedUsed(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            })
                                .expand((widget) => [widget, const Divider()])
                                .toList()
                              ..removeLast(),
                          ),
                        );
                }),
                Center(
                  child: IconButton(
                      onPressed: () async {
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return Center(
                        //         child: InsertMaterialWidget(
                        //           init: widget.controller.materialsConsumedUsed,
                        //           materials: checklist
                        //               .checkCar.car.materialsConsumable,
                        //           onInsert: widget
                        //               .controller.addMaterialsConsumedUsed,
                        //         ),
                        //       );
                        //     });
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Constants.primary),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            childRight: Column(
              spacing: 10,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "INFORMAÇÕES FINAIS",
                    style: Constants.titleButton,
                  ),
                ),
                Stack(
                  children: [
                    FieldText(
                      controller: endKMController,
                      hint: 'Ex.: 12345',
                      validation: Validation.validatorNumber,
                      inputType: TextInputType.number,
                    ),
                    Positioned(
                        top: 10,
                        right: 10,
                        child: Text(
                          'KM Final',
                          style: Constants.subtitleHint,
                        ))
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assinatura digital',
                        style: Constants.titleHint,
                      ),
                      Stack(
                        children: [
                          Signature(
                            controller: signatureController,
                            height: 200,
                            width: double.infinity,
                            backgroundColor: Colors.grey.shade200,
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: InkWell(
                              onTap: () => signatureController.clear(),
                              child: const Icon(
                                Icons.refresh,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      Visibility(
                        visible: label.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            'Insira sua assinatura',
                            style: Constants.title.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    'OBSERVAÇÕES GERAIS',
                    style: Constants.titleButton,
                  ),
                ),
                FieldText(
                  controller: obsController,
                  hint: "EX.: Alguma informação importante",
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                      height: 40.0,
                      child: ElevatedButton(
                          onPressed: () {
                            if (key.currentState?.validate() ?? false) {
                              if (signatureController.isEmpty) {
                                setState(() {
                                  label =
                                      'Insira uma assinatura antes de prosseguir.';
                                });

                                return;
                              } else {
                                setState(() {
                                  label = '';
                                });

                                finishChecklist().then((_) {
                                  Navigator.of(context).pop();
                                }).catchError((err) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: "Atenção",
                                          message: err.toString(),
                                          onPressedOK: () =>
                                              Navigator.of(context).pop()));
                                });
                              }
                            }
                          },
                          child:
                              Text("Finalizar", style: Constants.titleButton))),
                )
              ],
            ),
          ),
        ),
        Observer(builder: (_) {
          return IgnorePointer(
            ignoring: !widget.controller.loading,
            child: Container(
              color: widget.controller.loading
                  ? Colors.black54
                  : Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.controller.loading
                        ? Colors.white
                        : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}
