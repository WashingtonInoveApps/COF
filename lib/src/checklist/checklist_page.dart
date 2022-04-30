import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_checklist.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/checklist/checklist_controller.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CheckListPage extends StatefulWidget {
  final CheckListModel? checkList;
  const CheckListPage({Key? key, this.checkList}) : super(key: key);

  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  final app = GetIt.I.get<AppController>();
  final _key = GlobalKey<FormState>();

  late CheckListController controller;

  @override
  void initState() {
    super.initState();

    final car = CarModel.copy(app.cars.first);
    final checkList = (widget.checkList == null)
        ? CheckListModel(checkCar: CarCheckList(car: car), alfa: alfas.first, prefix: car.prefix, user: app.user, date: DateTime.now(), supply: [])
        : CheckListModel.copy(checklist: widget.checkList!);

    controller = CheckListController(checklist: checkList, cars: app.cars, user: app.user);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('State');
    return WillPopScope(
      onWillPop: () async => (widget.checkList != null),
      child: Scaffold(
        appBar: const AppBarCustom(
          page: 1,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: LayoutBuilder(builder: (context, constrains) {
                double width = constrains.maxWidth > 500 ? 500.0 : constrains.maxWidth;

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
                                    formatDate(controller.date, outher: true),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "prefix",
                                          style: subtitle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          margin: EdgeInsets.zero,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Observer(builder: (_) {
                                              return DropdownButton<String>(
                                                  value: controller.prefix,
                                                  onChanged: (widget.checkList == null) ? controller.setPrefix : null,
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  items: List.generate(
                                                      app.prefixs.length,
                                                      (index) => DropdownMenuItem<String>(
                                                            child: Text(
                                                              app.prefixs[index],
                                                              style: subtitle,
                                                            ),
                                                            value: app.prefixs[index],
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ALFA",
                                          style: subtitle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          margin: EdgeInsets.zero,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                            child: Observer(builder: (_) {
                                              return DropdownButton<String>(
                                                  value: controller.alfa,
                                                  onChanged: controller.setAlfa,
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  items: List.generate(
                                                      alfas.length,
                                                      (index) => DropdownMenuItem<String>(
                                                            child: Text(
                                                              alfas[index],
                                                              style: subtitle,
                                                            ),
                                                            value: alfas[index],
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
                                style: subtitle.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              FieldText(
                                  initValue: controller.checklist.pb,
                                  hint: "EX.: BSU",
                                  validation: Validation.validatorPreenchimento,
                                  onSaved: controller.setPB),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "KM INICIAL",
                                style: subtitle.copyWith(fontWeight: FontWeight.bold),
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
                              Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
                                  child: Row(
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
                                            Observer(builder: (_) {
                                              return SfSlider.vertical(
                                                min: 1.0,
                                                max: 3.0,
                                                stepSize: 0.5,
                                                value: controller.oil,
                                                interval: 1,
                                                activeColor: Colors.brown,
                                                inactiveColor: Colors.brown.shade200,
                                                showTicks: true,
                                                minorTicksPerInterval: 1,
                                                onChanged: controller.setOil,
                                              );
                                            }),
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
                                            Observer(builder: (_) {
                                              return SfSlider.vertical(
                                                min: 1.0,
                                                max: 3.0,
                                                stepSize: 0.5,
                                                value: controller.hidra,
                                                interval: 1,
                                                showTicks: true,
                                                activeColor: Colors.red,
                                                inactiveColor: Colors.red.shade200,
                                                minorTicksPerInterval: 1,
                                                onChanged: controller.setHidra,
                                              );
                                            }),
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
                                            Observer(builder: (_) {
                                              return SfSlider.vertical(
                                                min: 1.0,
                                                max: 3.0,
                                                stepSize: 0.5,
                                                value: controller.fr,
                                                interval: 1,
                                                showTicks: true,
                                                activeColor: Colors.grey,
                                                inactiveColor: Colors.grey.shade200,
                                                minorTicksPerInterval: 1,
                                                onChanged: controller.setFR,
                                              );
                                            }),
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
                                            Observer(builder: (_) {
                                              return SfSlider.vertical(
                                                min: 1.0,
                                                max: 3.0,
                                                stepSize: 0.5,
                                                value: controller.arref,
                                                interval: 1,
                                                showTicks: true,
                                                activeColor: Colors.blue,
                                                inactiveColor: Colors.blue.shade200,
                                                minorTicksPerInterval: 1,
                                                onChanged: controller.setArref,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Text(
                                "ITENS",
                                style: titleHint,
                              ),
                              const Divider(),
                              Text("Marque os itens que apresentam problemas.", style: subtitle),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Observer(builder: (_) {
                                return ExpansionPanelList(
                                  expandedHeaderPadding: const EdgeInsets.all(5),
                                  expansionCallback: (index, value) {
                                    controller.statusExpanded(index, value);
                                  },
                                  children: List.generate(
                                    controller.itens.length,
                                    (index) => ExpansionPanel(
                                        isExpanded: controller.itens[index].value,
                                        headerBuilder: (context, isExpanded) {
                                          return Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                controller.itens[index].description,
                                                style: subtitle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        body: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Column(
                                                children: List.generate(controller.itens[index].itens.length, (indexItem) {
                                                  final item = controller.itens[index].itens[indexItem];
                                                  return itemWidget(
                                                      item: item, onSelect: (value) => controller.selectValueItens(value, index, indexItem));
                                                }),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: FieldText(
                                                    hint: "OBSERVAÇÕES",
                                                    initValue: controller.itens[index].obs,
                                                    onChange: (value) => controller.itens[index].obs = value),
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
                              Observer(builder: (_) {
                                debugPrint('Changes.: ${controller.carChanges.length}');
                                return StatefulBuilder(builder: (context, setStateChanges) {
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
                                        controller.removeCarChanges(index);
                                      });
                                    },
                                  );
                                });
                              }),
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

                                          app.saveCheckList(id: widget.checkList?.id, checkList: controller.checklist).then((value) async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: "Atenção",
                                                    message: value ? "CheckList realizado com sucesso." : "Ops ! Erro ao tentar salvar o checklist.",
                                                    onPressedOK: () => Navigator.of(context).pop()));

                                            if (value) {
                                              (widget.checkList?.id == null)
                                                  ? Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()))
                                                  : Navigator.of(context).pop();
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
            Observer(builder: (_) {
              return IgnorePointer(
                ignoring: !app.loading,
                child: Container(
                  color: app.loading ? Colors.black54 : Colors.transparent,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(app.loading ? Colors.white : Colors.transparent),
                  )),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

Widget itemWidget({required ItemModel item, required Function(bool value) onSelect}) {
  bool _value = item.value;
  return StatefulBuilder(builder: (context, setState) {
    return Row(
      children: [
        Checkbox(
            value: _value,
            onChanged: (value) {
              setState(() {
                _value = value ?? _value;
                onSelect(_value);
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
