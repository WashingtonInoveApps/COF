import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/car_supply_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'checklist_page.dart';

class CheckListDetailsPage extends StatefulWidget {
  final String checkListId;
  const CheckListDetailsPage({Key? key, required this.checkListId}) : super(key: key);

  @override
  State<CheckListDetailsPage> createState() => _CheckListDetailsPageState();
}

class _CheckListDetailsPageState extends State<CheckListDetailsPage> {
  late CheckListModel checkList;
  late ReactionDisposer rec;

  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  final controller = GetIt.I.get<AppController>();

  @override
  void initState() {
    super.initState();

    rec = autorun((_) {
      setState(() {
        checkList = controller.checkLists.firstWhere((e) => e.id == widget.checkListId);
        checkList.enable = (checkList.enable && (checkList.user.matricula == controller.user.matricula));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    rec.reaction.dispose();
    _controller.dispose();
  }

  finishWidget({required Function(String value) onFinish}) => Form(
        key: _key,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(6),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FieldText(
                controller: _controller,
                hint: "KM FINAL",
                validation: Validation.validatorNumber,
                inputType: TextInputType.number,
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          Navigator.of(context).pop();
                          onFinish(_controller.text);
                        }
                      },
                      child: Text("FINALIZAR", style: titleButton)))
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var itens = List<ItensChangesModel>.from(checkList.checkCar.car.itens.where((i) => i.itens.isNotEmpty).toList());
    final color = checkList.enable ? Theme.of(context).primaryColor : Colors.grey;

    return Scaffold(
      appBar: AppBarCustom(onBack: () => Navigator.of(context).pop()),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: LayoutBuilder(builder: (context, constrains) {
              double width = constrains.maxWidth > 500 ? 500.0 : constrains.maxWidth;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CHECKLIST VEICULAR",
                                  style: title.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDate(checkList.date),
                                  style: subtitleHint,
                                ),
                              ],
                            )),
                            Row(
                              children: [
                                TextButton.icon(
                                    style: TextButton.styleFrom(side: BorderSide(color: color)),
                                    onPressed: checkList.enable
                                        ? () async {
                                            await Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => CheckListPage(
                                                      checkList: checkList,
                                                    )));
                                          }
                                        : null,
                                    icon: Icon(
                                      MdiIcons.bookEdit,
                                      size: 20,
                                      color: color,
                                    ),
                                    label: Text(
                                      "Editar",
                                      style: title.copyWith(color: color),
                                    )),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                TextButton.icon(
                                    style: TextButton.styleFrom(side: BorderSide(color: color)),
                                    onPressed: checkList.enable
                                        ? () async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) => finishWidget(
                                                      onFinish: (value) async {
                                                        await controller.finishCheckList(kmFinal: value, checkList: checkList);
                                                      },
                                                    ));
                                          }
                                        : null,
                                    icon: Icon(
                                      MdiIcons.checkAll,
                                      size: 20,
                                      color: color,
                                    ),
                                    label: Text(
                                      "Finalizar",
                                      style: title.copyWith(color: color),
                                    ))
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Center(
                    child: Wrap(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${checkList.resgate} - ${checkList.alfa}",
                                      style: title.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    checkList.pb,
                                    style: title.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Condutor",
                                style: subtitleHint,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "${checkList.user.name} - ${checkList.user.matricula}",
                                style: title.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "KM Inicial",
                                          style: subtitleHint,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          checkList.kmInicial,
                                          style: title.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "KM Final",
                                          style: subtitleHint,
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          checkList.kmFinal.isEmpty ? "---" : checkList.kmFinal,
                                          style: title.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "NÍVEIS DOS FLUÍDOS",
                                style: titleHint,
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "ÓLEO DO MOTOR",
                                            style: subtitle,
                                          ),
                                        ),
                                        SfSlider.vertical(
                                          min: 1.0,
                                          max: 3.0,
                                          stepSize: 0.5,
                                          value: checkList.checkCar.oleoMotor,
                                          interval: 1,
                                          showTicks: true,
                                          activeColor: Colors.brown,
                                          inactiveColor: Colors.brown.shade100,
                                          minorTicksPerInterval: 1,
                                          onChanged: (value) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "ÓLEO HIDRAÚLICO",
                                            style: subtitle,
                                          ),
                                        ),
                                        SfSlider.vertical(
                                          min: 1.0,
                                          max: 3.0,
                                          stepSize: 0.5,
                                          value: checkList.checkCar.oleoHidra,
                                          interval: 1,
                                          showTicks: true,
                                          activeColor: Colors.red,
                                          inactiveColor: Colors.red.shade100,
                                          minorTicksPerInterval: 1,
                                          onChanged: (value) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "ÓLEO DE FREIO",
                                            style: subtitle,
                                          ),
                                        ),
                                        SfSlider.vertical(
                                          min: 1.0,
                                          max: 3.0,
                                          stepSize: 0.5,
                                          value: checkList.checkCar.oleoFreio,
                                          interval: 1,
                                          showTicks: true,
                                          activeColor: Colors.grey,
                                          inactiveColor: Colors.grey.shade200,
                                          minorTicksPerInterval: 1,
                                          onChanged: (value) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RotatedBox(
                                          quarterTurns: 3,
                                          child: Text(
                                            "ÁGUA DO RADIADOR",
                                            style: subtitle,
                                          ),
                                        ),
                                        SfSlider.vertical(
                                          min: 1.0,
                                          max: 3.0,
                                          stepSize: 0.5,
                                          value: checkList.checkCar.aguaRad,
                                          interval: 1,
                                          showTicks: true,
                                          activeColor: Colors.blue,
                                          inactiveColor: Colors.blue.shade100,
                                          minorTicksPerInterval: 1,
                                          onChanged: (value) {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Wrap(children: List.generate(itens.length, (index) => changesListWidget(itensChanges: itens[index]))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          width: width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ABASTECIMENTO",
                                style: titleHint,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 5.0,
                              ),
                              (checkList.supply.isEmpty)
                                  ? Center(child: Text("-", style: title))
                                  : Column(
                                      children: List.generate(
                                          checkList.supply.length, (index) => CardCarSupply(details: true, supply: checkList.supply[index])),
                                    ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              CarChangesWidget(
                                add: false,
                                user: checkList.user,
                                initValue: checkList.checkCar.car.changes,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "OUTRAS OBSERVAÇÕES",
                                style: titleHint,
                              ),
                              const Divider(),
                              Text(
                                checkList.obs,
                                style: title,
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
                  (checkList.dateFinish == null)
                      ? Container()
                      : Text(
                          "Checklist finalizado em ${formatDate(checkList.dateFinish!)}",
                          style: subtitleHint,
                        ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              );
            }),
          ),
          Observer(builder: (_) {
            return IgnorePointer(
              ignoring: !controller.loading,
              child: Container(
                color: controller.loading ? Colors.black54 : Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(controller.loading ? Colors.white : Colors.transparent),
                )),
              ),
            );
          })
        ],
      ),
    );
  }
}

Widget changesListWidget({required ItensChangesModel itensChanges}) => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itensChanges.description,
            style: subtitleHint,
          ),
          const Divider(),
          Column(
            children: List.generate(
                itensChanges.itens.length,
                (index) => Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itensChanges.itens[index].description,
                              style: subtitle,
                            ),
                          ),
                          !itensChanges.itens[index].value
                              ? const Icon(MdiIcons.checkCircle, size: 20.0, color: Colors.green)
                              : const Icon(MdiIcons.closeCircle, size: 20.0, color: Colors.red),
                        ],
                      ),
                    )),
          ),
          itensChanges.obs.isEmpty
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "OBSERVAÇÃO",
                        style: subtitleHint,
                      ),
                      const Divider(),
                      Text(
                        itensChanges.obs,
                        style: title,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
