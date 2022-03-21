import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/car_supply_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../model/user_model.dart';

class CheckListPage extends StatefulWidget {
  final CheckListModel? checkList;
  const CheckListPage({Key? key, this.checkList}) : super(key: key);

  @override
  _CheckListPageState createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  final controller = GetIt.I.get<AppController>();
  final _key = GlobalKey<FormState>();

  late CheckListModel checkList;
  SupplyModel? supply;

  @override
  void initState() {
    super.initState();

    final car = (widget.checkList == null)
        ? CarModel.copy(controller.cars.first)
        : CarModel.copy((controller.cars.firstWhere((c) => c.id == widget.checkList!.checkCar.car.id)));

    checkList = (widget.checkList == null)
        ? CheckListModel(
            checkCar: CarCheckList(car: car), alfa: alfas.first, resgate: car.resgaste, user: controller.user, date: DateTime.now(), supply: [])
        : CheckListModel.copy(widget.checkList!);

    checkList.checkCar.car = car;
    controller.setResgate(car.resgaste);
  }

  @override
  Widget build(BuildContext context) {
    final itens = checkList.checkCar.car.itens.where((i) => i.itens.isNotEmpty).toList();

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
                                    formatDate(checkList.date, outher: true),
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
                                          "RESGATE",
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
                                                  value: controller.resgate,
                                                  onChanged: (widget.checkList == null)
                                                      ? (value) {
                                                          if (value != null) {
                                                            checkList.checkCar.car =
                                                                CarModel.copy(controller.cars.firstWhere((c) => c.resgaste == value));
                                                            checkList.resgate = checkList.checkCar.car.resgaste;
                                                            controller.setResgate(checkList.checkCar.car.resgaste);

                                                            setState(() {});
                                                          }
                                                        }
                                                      : null,
                                                  underline: Container(),
                                                  isExpanded: true,
                                                  items: List.generate(
                                                      controller.resgates.length,
                                                      (index) => DropdownMenuItem<String>(
                                                            child: Text(
                                                              controller.resgates[index],
                                                              style: subtitle,
                                                            ),
                                                            value: controller.resgates[index],
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
                                            child: DropdownButton<String>(
                                                value: checkList.alfa,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkList.alfa = value ?? alfas.first;
                                                  });
                                                },
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
                                                        ))),
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
                                  initValue: checkList.pb,
                                  hint: "EX.: BSU",
                                  validation: Validation.validatorPreenchimento,
                                  onSaved: (value) {
                                    checkList.pb = value!;
                                  }),
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
                                  initValue: checkList.kmInicial,
                                  hint: "EX.: 123456",
                                  validation: Validation.validatorNumber,
                                  inputType: TextInputType.number,
                                  onSaved: (value) {
                                    checkList.kmInicial = value!;
                                  }),
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
                                            SfSlider.vertical(
                                              min: 1.0,
                                              max: 3.0,
                                              stepSize: 0.5,
                                              value: checkList.checkCar.oleoMotor,
                                              interval: 1,
                                              activeColor: Colors.brown,
                                              inactiveColor: Colors.brown.shade200,
                                              showTicks: true,
                                              minorTicksPerInterval: 1,
                                              onChanged: (value) {
                                                final result = (double.parse(value.toString()));
                                                setState(() {
                                                  checkList.checkCar.oleoMotor = result;
                                                });
                                              },
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
                                              inactiveColor: Colors.red.shade200,
                                              minorTicksPerInterval: 1,
                                              onChanged: (value) {
                                                final result = (double.parse(value.toString()));
                                                setState(() {
                                                  checkList.checkCar.oleoHidra = result;
                                                });
                                              },
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
                                              onChanged: (value) {
                                                final result = (double.parse(value.toString()));
                                                setState(() {
                                                  checkList.checkCar.oleoFreio = result;
                                                });
                                              },
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
                                              inactiveColor: Colors.blue.shade200,
                                              minorTicksPerInterval: 1,
                                              onChanged: (value) {
                                                final result = (double.parse(value.toString()));
                                                setState(() {
                                                  checkList.checkCar.aguaRad = result;
                                                });
                                              },
                                            ),
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
                              ExpansionPanelList(
                                expandedHeaderPadding: const EdgeInsets.all(5),
                                expansionCallback: (item, value) {
                                  setState(() {
                                    itens[item].value = !value;
                                  });
                                },
                                children: List.generate(
                                  itens.length,
                                  (index) => ExpansionPanel(
                                      isExpanded: itens[index].value,
                                      headerBuilder: (context, isExpanded) {
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            itens[index].description,
                                            style: subtitle.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                      body: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            changesListWidget(
                                                itensChanges: itens[index],
                                                onSelect: (value, i) {
                                                  setState(() {
                                                    itens[index].itens[i].value = value;
                                                  });
                                                }),
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: FieldText(
                                                  hint: "OBSERVAÇÕES", initValue: itens[index].obs, onChange: (value) => itens[index].obs = value),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                      "ABASTECIMENTO",
                                      style: titleHint,
                                    ),
                                  ),
                                  TextButton.icon(
                                      style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => SupplyWidget(
                                                  user: controller.user,
                                                  onInsert: (supply) {
                                                    setState(() {
                                                      checkList.supply.add(supply);
                                                    });
                                                  },
                                                ));
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      label: Text(
                                        "Adicionar",
                                        style: title.copyWith(color: Theme.of(context).primaryColor),
                                      )),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 5.0,
                              ),
                              (checkList.supply.isEmpty)
                                  ? Center(child: Text("-", style: title))
                                  : Column(
                                      children: List.generate(
                                          checkList.supply.length,
                                          (index) => GestureDetector(
                                              onLongPress: () async {
                                                final result = await showDialog(
                                                    context: context,
                                                    builder: (context) => AlertMessage(
                                                        title: "Atenção",
                                                        message: "Deseja excluir esse registro de abastecimento ?",
                                                        cancel: true,
                                                        onPressedCancel: () => Navigator.of(context).pop(false),
                                                        onPressedOK: () => Navigator.of(context).pop(true)));

                                                if (result) {
                                                  controller
                                                      .deleteSupply(supplies: checkList.supply, index: index, carId: checkList.checkCar.car.id)
                                                      .then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        checkList.supply.removeAt(index);
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                              child: CardCarSupply(supply: checkList.supply[index]))),
                                    ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              CarChangesWidget(
                                id: checkList.id,
                                initValue: checkList.checkCar.car.changes,
                                user: checkList.user,
                                onAdd: (change) {
                                  setState(() {
                                    checkList.checkCar.car.changes.add(change);
                                  });
                                },
                                onRemove: (index) {
                                  setState(() {
                                    checkList.checkCar.car.changes.removeAt(index);
                                  });
                                },
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
                                initValue: checkList.obs,
                                hint: "OBSERVAÇÕES",
                                onSaved: (text) {
                                  checkList.obs = text ?? "";
                                },
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

                                          final carBefore = controller.cars.firstWhere((c) => c.resgaste == checkList.checkCar.car.resgaste);
                                          final id = (widget.checkList != null) ? widget.checkList!.id : null;

                                          controller
                                              .saveCheckList(
                                                  id: id,
                                                  checkList: checkList,
                                                  updateCar: (checkList.checkCar.car.changes.length.compareTo(carBefore.changes.length)))
                                              .then((value) async {
                                            await showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: "Atenção",
                                                    message: value ? "CheckList realizado com sucesso." : "Ops ! Erro ao tentar salvar o checklist.",
                                                    onPressedOK: () => Navigator.of(context).pop()));

                                            if (value) {
                                              (id == null)
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
      ),
    );
  }
}

Widget changesListWidget({required ItensChangesModel itensChanges, required Function(bool value, int i) onSelect}) {
  return Column(
    children: List.generate(
        itensChanges.itens.length,
        (index) => Row(
              children: [
                Checkbox(
                    value: itensChanges.itens[index].value,
                    onChanged: (value) {
                      onSelect(value ?? false, index);
                    }),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  itensChanges.itens[index].description,
                  style: subtitle,
                )
              ],
            )),
  );
}

class SupplyWidget extends StatefulWidget {
  final UserModel user;
  final Function(SupplyModel supply) onInsert;
  const SupplyWidget({Key? key, required this.onInsert, required this.user}) : super(key: key);

  @override
  State<SupplyWidget> createState() => _SupplyWidgetState();
}

class _SupplyWidgetState extends State<SupplyWidget> {
  final _key = GlobalKey<FormState>();
  late SupplyModel supply;

  @override
  void initState() {
    super.initState();
    supply = SupplyModel(date: DateTime.now(), user: widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(6),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldText(
              hint: "QUILÔMETRAGEM",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                supply.kmAbastecimento = value!;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "LITROS",
              validation: Validation.validatorPrice,
              inputType: TextInputType.number,
              onSaved: (value) {
                supply.litros = double.parse(value!);
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            FieldText(
              hint: "PREÇO",
              validation: Validation.validatorPrice,
              inputType: TextInputType.number,
              onSaved: (value) {
                supply.value = double.parse(value!);
              },
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
                        _key.currentState!.save();

                        Navigator.of(context).pop();

                        widget.onInsert(supply);
                      }
                    },
                    child: Text("INSERIR", style: titleButton)))
          ],
        ),
      ),
    );
  }
}
