import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/checklist/view/checklist_page.dart';
import 'package:bsu_control/src/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../controller/checklist_controller.dart';

class ChecklistRegisterPage extends StatefulWidget {
  final CheckListModel? checkList;
  const ChecklistRegisterPage({Key? key, this.checkList}) : super(key: key);

  @override
  State createState() => _ChecklistRegisterPageState();
}

class _ChecklistRegisterPageState extends State<ChecklistRegisterPage> {
  final app = GetIt.I.get<AppController>();
  final _key = GlobalKey<FormState>();

  late CheckListController controller;
  List<String> prefixs = ['SELECIONE O PREFIXO'];

  @override
  void initState() {
    super.initState();
    prefixs = List<String>.from(prefixs..addAll(app.prefixs));

    final car = CarModel.copy(app.cars.first);
    final checkList = (widget.checkList == null)
        ? CheckListModel(
            checkCar: CarCheckList(car: car),
            alfa: Core.alfas.first,
            prefix: prefixs.first,
            user: app.user,
            date: DateTime.now(),
            supply: [])
        : CheckListModel.copy(checklist: widget.checkList!);

    controller = CheckListController(
      checklist: checkList,
      cars: app.cars,
      user: app.user,
      app: app,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarCustom(
                page: 2,
                titlePage: 'REGISTRO DE CHECKLIST',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: LayoutBuilder(builder: (context, constrains) {
                    double width =
                        constrains.maxWidth > 500 ? 500.0 : constrains.maxWidth;

                    return Center(
                      child: Form(
                        key: _key,
                        child: Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        "CHECKLIST VEÍCULAR",
                                        style: Core.titleHint,
                                      )),
                                      Text(
                                        Core.formatDate(
                                          controller.date,
                                          largeDay: true,
                                        ),
                                        style: Core.titleHint,
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "PREFIXO",
                                              style: Core.subtitle.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Card(
                                              margin: EdgeInsets.zero,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Observer(builder: (_) {
                                                  return DropdownButton<String>(
                                                      value: controller.prefix,
                                                      onChanged:
                                                          (widget.checkList ==
                                                                  null)
                                                              ? (value) {
                                                                  setState(() {
                                                                    controller
                                                                        .setPrefix(
                                                                            value);
                                                                  });
                                                                }
                                                              : null,
                                                      underline: Container(),
                                                      isExpanded: true,
                                                      items: List.generate(
                                                          prefixs.length,
                                                          (index) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                enabled:
                                                                    index != 0,
                                                                value: prefixs[
                                                                    index],
                                                                child: Text(
                                                                  prefixs[
                                                                      index],
                                                                  style: Core
                                                                      .subtitle,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              )));
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "ALFA",
                                              style: Core.subtitle.copyWith(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Card(
                                              margin: EdgeInsets.zero,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: Observer(builder: (_) {
                                                  return DropdownButton<String>(
                                                      value: controller.alfa,
                                                      onChanged:
                                                          controller.setAlfa,
                                                      underline: Container(),
                                                      isExpanded: true,
                                                      items: List.generate(
                                                          Core.alfas.length,
                                                          (index) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    Core.alfas[
                                                                        index],
                                                                child: Text(
                                                                  Core.alfas[
                                                                      index],
                                                                  style: Core
                                                                      .subtitle,
                                                                ),
                                                              )));
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "PONTO BASE",
                                    style: Core.subtitle
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  FieldText(
                                      initValue: controller.checklist.pb,
                                      hint: "EX.: BSU",
                                      validation:
                                          Validation.validatorPreenchimento,
                                      onSaved: controller.setPB),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "KM INICIAL",
                                    style: Core.subtitle
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  FieldText(
                                      initValue: controller.checklist.kmStart,
                                      hint: "EX.: 123456",
                                      validation: Validation.validatorNumber,
                                      inputType: TextInputType.number,
                                      onSaved: controller.setKMStart),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    " NIVÉIS DOS FLUÍDOS",
                                    style: Core.titleHint,
                                  ),
                                  const Divider(),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: Observer(
                                        builder: (context) => FluidsWidget(
                                            oil: controller.oil,
                                            hidra: controller.hidra,
                                            fr: controller.fr,
                                            arref: controller.arref,
                                            onOil: controller.setOil,
                                            onHidra: controller.setHidra,
                                            onFr: controller.setFR,
                                            onArref: controller.setArref)),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    "ITENS",
                                    style: Core.titleHint,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Observer(builder: (_) {
                                    return ExpansionPanelList(
                                      expandedHeaderPadding:
                                          const EdgeInsets.all(5),
                                      expansionCallback: (index, value) {
                                        controller.statusExpanded(index, value);
                                      },
                                      children: List.generate(
                                        controller.itens.length,
                                        (index) => ExpansionPanel(
                                            isExpanded:
                                                controller.itens[index].value,
                                            headerBuilder:
                                                (context, isExpanded) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller.itens[index]
                                                          .description,
                                                      style:
                                                          Core.title.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Marque os itens que estão em conformidade.",
                                                      style: Core.subtitle
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            body: SingleChildScrollView(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  Column(
                                                    children: List.generate(
                                                        controller.itens[index]
                                                            .itens.length,
                                                        (indexItem) {
                                                      final item = controller
                                                          .itens[index]
                                                          .itens[indexItem];
                                                      return itemWidget(
                                                          item: item,
                                                          onSelect: (value) =>
                                                              controller
                                                                  .selectValueItens(
                                                                      value,
                                                                      index,
                                                                      indexItem));
                                                    }),
                                                  ),
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: FieldText(
                                                        hint: "OBSERVAÇÕES",
                                                        initValue: controller
                                                            .itens[index].obs,
                                                        onChange: (value) =>
                                                            controller
                                                                .itens[index]
                                                                .obs = value),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Observer(builder: (_) {
                                      return Visibility(
                                        visible:
                                            controller.prefix != prefixs.first,
                                        child: StatefulBuilder(builder:
                                            (context, setStateChanges) {
                                          return Container();
                                          // return CarChangesWidget(
                                          //   checklistId: controller.id,
                                          //   // initValue: controller.carChanges,
                                          //   car: controller.cars.first,
                                          //   user: controller.user,
                                          //   onAdd: (change) {
                                          //     setStateChanges(() {
                                          //       controller
                                          //           .addCarChanges(change);
                                          //     });
                                          //   },
                                          //   onRemove: (index) {
                                          //     setStateChanges(() {
                                          //       controller
                                          //           .removeCarChanges(index);
                                          //     });
                                          //   },
                                          // );
                                        }),
                                      );
                                    }),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    "OUTRAS OBSERVAÇÕES",
                                    style: Core.titleHint,
                                  ),
                                  const Divider(),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  FieldText(
                                    initValue: controller.obs,
                                    hint: "OBSERVAÇÕES",
                                    onSaved: controller.setOBS,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: SizedBox(
                                      height: 45.0,
                                      width: 150.0,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            if (_key.currentState!.validate()) {
                                              _key.currentState!.save();

                                              if (controller.prefix ==
                                                  prefixs.first) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertMessage(
                                                            title: 'Atenção',
                                                            message:
                                                                'Selecione o prefixo do veículo antes de salvar o checklist.',
                                                            onPressedOK: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop()));
                                              } else {
                                                controller
                                                    .save(
                                                        id: widget
                                                            .checkList?.id,
                                                        checkList: controller
                                                            .checklist)
                                                    .then((value) async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) => AlertMessage(
                                                          title: "Atenção",
                                                          message: value
                                                              ? "CheckList realizado com sucesso."
                                                              : "Ops ! Erro ao tentar salvar o checklist.",
                                                          onPressedOK: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop())).then(
                                                      (_) {
                                                    if (value) {
                                                      (widget.checkList?.id ==
                                                              null)
                                                          ? Navigator.of(
                                                                  context)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const ChecklistPage()))
                                                          : Navigator.of(
                                                                  context)
                                                              .pop();
                                                    }
                                                  });
                                                });
                                              }
                                            }
                                          },
                                          child: Text(
                                            "SALVAR",
                                            style: Core.titleButton,
                                          )),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          Observer(builder: (_) {
            return IgnorePointer(
              ignoring: !controller.loading,
              child: Container(
                color: controller.loading ? Colors.black54 : Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      controller.loading ? Colors.white : Colors.transparent),
                )),
              ),
            );
          })
        ],
      ),
    );
  }
}

Widget itemWidget(
    {required ItemModel item, required Function(bool value) onSelect}) {
  bool result = item.value;
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        Checkbox(
            value: result,
            onChanged: (value) {
              setState(() {
                result = value ?? result;
                onSelect(result);
              });
            }),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          item.description,
          style: Core.subtitle,
        )
      ],
    );
  });
}
