import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CarRegisterPage extends StatefulWidget {
  final CarModel? car;
  const CarRegisterPage({Key? key, this.car}) : super(key: key);

  @override
  _CarRegisterPageState createState() => _CarRegisterPageState();
}

class _CarRegisterPageState extends State<CarRegisterPage> {
  late CarModel car;

  final _key = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final controller = GetIt.I.get<AppController>();

  List<ItensChangesModel> checkListSection = [
    ItensChangesModel(description: "SISTEMA ÉLETRICO", itens: List.from(listItensEletric)),
    ItensChangesModel(description: "EQUIPAMENTO", itens: List.from(listItensEquip)),
    ItensChangesModel(description: "ACESSÓRIOS", itens: [])
  ];

  @override
  void initState() {
    super.initState();
    car = (widget.car == null
        ? CarModel(itens: checkListSection, changes: [], status: [], mapas: [], typeCar: carsType.first)
        : CarModel.copy(widget.car!));
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarCustom(),
          body: SingleChildScrollView(
            child: Form(
              key: _key,
              child: LayoutBuilder(
                builder: (context, constrains) {
                  double width = constrains.maxWidth > 500 ? constrains.maxWidth * 0.5 : constrains.maxWidth;

                  return Wrap(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PREFIXO",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.resgaste,
                              hint: "EX.: RESGATE 32",
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.resgaste = value ?? car.resgaste,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "MODELO",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.modelo,
                              hint: "EX.: RENAULT MASTER 2.3 2010",
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.modelo = value ?? car.modelo,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "PLACA",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.placa,
                              hint: "EX.: XXX 2345",
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.placa = value ?? car.placa,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "KM INICIAL",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.km,
                              hint: "EX.: 1234567",
                              inputType: TextInputType.number,
                              validation: Validation.validatorNumber,
                              onSaved: (value) => car.km = value ?? car.km,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "MODELO PNEU",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.modeloPneu,
                              hint: "EX.: 202/75 15",
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.modeloPneu = value ?? car.modeloPneu,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "NÚMERO CARTÃO DE ABASTECIMENTO",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.ticket,
                              hint: "EX.: 0000 0000 0000 0000",
                              inputType: TextInputType.number,
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.ticket = value ?? car.ticket,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "NÚMERO CARTÃO DE MANUTENÇÃO",
                              style: subtitle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            FieldText(
                              initValue: car.prime,
                              hint: "EX.: 0000 0000 0000 0000",
                              inputType: TextInputType.number,
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) => car.prime = value ?? car.prime,
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
                            Text(
                              "ITENS",
                              style: titleHint,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            ExpansionPanelList(
                              expandedHeaderPadding: const EdgeInsets.all(5),
                              expansionCallback: (item, value) {
                                setState(() {
                                  car.itens[item].value = !value;
                                });
                              },
                              children: List.generate(
                                car.itens.length,
                                (index) => ExpansionPanel(
                                    isExpanded: car.itens[index].value,
                                    headerBuilder: (context, isExpanded) {
                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          car.itens[index].description,
                                          style: subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                    body: changesListWidget(
                                        context: context,
                                        itensChanges: car.itens[index],
                                        onAdd: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    contentPadding: const EdgeInsets.all(6),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        FieldText(
                                                          controller: _textController,
                                                          hint: "DESCRIÇÃO",
                                                        ),
                                                        const SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        SizedBox(
                                                            height: 50.0,
                                                            width: double.infinity,
                                                            child: ElevatedButton(
                                                                onPressed: () {
                                                                  if (_textController.text.isNotEmpty) {
                                                                    setState(() {
                                                                      car.itens[index].itens.add(ItemModel(description: _textController.text));
                                                                    });
                                                                  }

                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text("INSERIR", style: titleButton)))
                                                      ],
                                                    ),
                                                  ));
                                          _textController.clear();
                                        },
                                        onDelete: (i) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertMessage(
                                                  title: "Atenção",
                                                  message: "Deseja excluir o item ?",
                                                  cancel: true,
                                                  onPressedCancel: () => Navigator.of(context).pop(),
                                                  onPressedOK: () {
                                                    setState(() {
                                                      car.itens[index].itens.removeAt(i);
                                                    });

                                                    Navigator.of(context).pop();
                                                  }));
                                        })),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "TIPO DE VEÍCULO",
                              style: titleHint,
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                      child: DropdownButton<String>(
                                          value: car.typeCar,
                                          onChanged: (value) {
                                            setState(() {
                                              car.typeCar = value ?? carsType.first;
                                            });
                                          },
                                          underline: Container(),
                                          isExpanded: true,
                                          items: List.generate(
                                              carsType.length,
                                              (index) => DropdownMenuItem<String>(
                                                    child: Text(
                                                      carsType[index],
                                                      style: subtitle,
                                                    ),
                                                    value: carsType[index],
                                                  ))),
                                    ),
                                  ),
                                ),
                                Checkbox(
                                    value: car.adm,
                                    onChanged: (value) {
                                      setState(() {
                                        car.adm = value ?? false;
                                      });
                                    }),
                                Text(
                                  "ADM",
                                  style: title.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CarChangesWidget(
                              initValue: car.changes,
                              remove: true,
                              user: controller.user,
                              update: true,
                              onAdd: (change) {
                                setState(() {
                                  car.changes.add(change);
                                });
                              },
                              onRemove: (index) {
                                setState(() {
                                  car.changes.removeAt(index);
                                });
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                height: 45.0,
                                width: 150.0,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      if (_key.currentState!.validate()) {
                                        _key.currentState!.save();

                                        controller.saveCar(car: car, id: (widget.car != null) ? widget.car!.id : null).then((value) async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertMessage(
                                                  title: "Atenção",
                                                  message: value ? "Cadastro realizado com sucesso." : "Ops ! Erro ao tentar realizar o cadastro.",
                                                  onPressedOK: () => Navigator.of(context).pop()));

                                          if (value) Navigator.of(context).pop();
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
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
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
    );
  }
}

Widget changesListWidget(
        {required ItensChangesModel itensChanges, required BuildContext context, required Function(int i) onDelete, required Function() onAdd}) =>
    SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                itensChanges.itens.length,
                (index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itensChanges.itens[index].description,
                              style: subtitle,
                            ),
                          ),
                          InkWell(
                            child: const Icon(
                              MdiIcons.delete,
                              color: Colors.grey,
                            ),
                            onTap: () => onDelete(index),
                          )
                        ],
                      ),
                    )),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: TextButton.icon(
                style: TextButton.styleFrom(side: BorderSide(color: Theme.of(context).primaryColor)),
                onPressed: onAdd,
                icon: Icon(
                  Icons.add,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                label: Text(
                  "Adicionar",
                  style: title.copyWith(color: Theme.of(context).primaryColor),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
