import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/checklist/repository/checklist_repository.dart';
import 'package:bsu_control/src/checklist/view/checklist_page.dart';
import 'package:bsu_control/src/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
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

  @override
  void initState() {
    super.initState();

    final car = CarModel.copy(app.cars.first);
    final checkList = (widget.checkList == null)
        ? CheckListModel(
            checkCar: CarCheckList(car: car),
            alfa: alfas.first,
            prefix: car.prefix,
            user: app.user,
            date: DateTime.now(),
            supply: [])
        : CheckListModel.copy(checklist: widget.checkList!);

    controller = CheckListController(
        checklist: checkList,
        cars: app.cars,
        user: app.user,
        app: app,
        repository: CheckListRepository());
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
                                        style: titleHint,
                                      )),
                                      Text(
                                        formatDate(controller.date,
                                            outher: true, referenceDate: true),
                                        style: titleHint,
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
                                              style: subtitle.copyWith(
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
                                                      onChanged: (widget
                                                                  .checkList ==
                                                              null)
                                                          ? controller.setPrefix
                                                          : null,
                                                      underline: Container(),
                                                      isExpanded: true,
                                                      items: List.generate(
                                                          app.prefixs.length,
                                                          (index) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value:
                                                                    app.prefixs[
                                                                        index],
                                                                child: Text(
                                                                  app.prefixs[
                                                                      index],
                                                                  style:
                                                                      subtitle,
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
                                              style: subtitle.copyWith(
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
                                                          alfas.length,
                                                          (index) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: alfas[
                                                                    index],
                                                                child: Text(
                                                                  alfas[index],
                                                                  style:
                                                                      subtitle,
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
                                    style: subtitle.copyWith(
                                        fontWeight: FontWeight.bold),
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
                                    style: subtitle.copyWith(
                                        fontWeight: FontWeight.bold),
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
                                    style: titleHint,
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
                                    style: titleHint,
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
                                                      style: title.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Marque os itens que estão em conformidade.",
                                                      style: subtitle.copyWith(
                                                          color: Colors.grey),
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
                                      return StatefulBuilder(
                                          builder: (context, setStateChanges) {
                                        return CarChangesWidget(
                                          checklistId: controller.id,
                                          initValue: controller.carChanges,
                                          user: controller.user,
                                          onAdd: (change) {
                                            setStateChanges(() {
                                              controller.addCarChanges(change);
                                            });
                                          },
                                          onRemove: (index) {
                                            setStateChanges(() {
                                              controller
                                                  .removeCarChanges(index);
                                            });
                                          },
                                        );
                                      });
                                    }),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  Text(
                                    "OUTRAS OBSERVAÇÕES",
                                    style: titleHint,
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

                                              controller
                                                  .save(
                                                      id: widget.checkList?.id,
                                                      checkList:
                                                          controller.checklist)
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
                                                                .pop()));

                                                if (value) {
                                                  (widget.checkList?.id == null)
                                                      // ignore: use_build_context_synchronously
                                                      ? Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const ChecklistPage()))
                                                      // ignore: use_build_context_synchronously
                                                      : Navigator.of(context)
                                                          .pop();
                                                }
                                              });
                                            }
                                          },
                                          child: Text(
                                            "SALVAR",
                                            style: titleButton,
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
          style: subtitle,
        )
      ],
    );
  });
}
