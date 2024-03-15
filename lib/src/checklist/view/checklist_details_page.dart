import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/car_supply_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';

import '../controller/checklist_controller.dart';
import '../repository/checklist_repository.dart';
import 'widget/fluids_widget.dart';

class ChecklistDetailsPage extends StatefulWidget {
  final String checkListId;
  const ChecklistDetailsPage({Key? key, required this.checkListId})
      : super(key: key);

  @override
  State<ChecklistDetailsPage> createState() => _ChecklistDetailsPageState();
}

class _ChecklistDetailsPageState extends State<ChecklistDetailsPage> {
  late CheckListModel checklist;
  late ReactionDisposer rec;

  final _controller = TextEditingController();
  final _key = GlobalKey<FormState>();

  final app = GetIt.I.get<AppController>();
  late CheckListController controller;

  @override
  void initState() {
    super.initState();

    rec = autorun((_) {
      setState(() {
        checklist =
            app.checkLists.firstWhere((e) => e.id == widget.checkListId);
        checklist.enable = (checklist.enable &&
            (checklist.user.matricula == controller.user.matricula));
      });
    });

    controller = CheckListController(
        checklist: checklist,
        cars: app.cars,
        user: app.user,
        app: app,
        repository: CheckListRepository());
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
          contentPadding: const EdgeInsets.all(10),
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
    var itens = List<ItensChangesModel>.from(
        checklist.checkCar.car.itens.where((i) => i.itens.isNotEmpty).toList());
    final color =
        checklist.enable ? Theme.of(context).primaryColor : Colors.grey;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBarCustom(
                onBack: () => Navigator.of(context).pop(),
                titlePage: 'DETALHES DO CHECKLIST',
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: LayoutBuilder(builder: (context, constrains) {
                    double width =
                        constrains.maxWidth > 500 ? 500.0 : constrains.maxWidth;

                    return Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CHECKLIST VEICULAR",
                                        style: title.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        formatDate(checklist.date),
                                        style: subtitleHint,
                                      ),
                                    ],
                                  )),
                                  checklist.enable
                                      ? Row(
                                          children: [
                                            TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    side: BorderSide(
                                                        color: color)),
                                                onPressed: () async {
                                                  await Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ChecklistRegisterPage(
                                                                    checkList:
                                                                        checklist,
                                                                  )));
                                                },
                                                icon: Icon(
                                                  MdiIcons.bookEdit,
                                                  size: 20,
                                                  color: color,
                                                ),
                                                label: Text(
                                                  "Editar",
                                                  style: title.copyWith(
                                                      color: color),
                                                )),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    side: BorderSide(
                                                        color: color)),
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              finishWidget(
                                                                onFinish:
                                                                    (value) async {
                                                                  await controller.finish(
                                                                      kmFinal:
                                                                          value,
                                                                      checkList:
                                                                          checklist);
                                                                },
                                                              ));
                                                },
                                                icon: Icon(
                                                  MdiIcons.checkAll,
                                                  size: 20,
                                                  color: color,
                                                ),
                                                label: Text(
                                                  "Finalizar",
                                                  style: title.copyWith(
                                                      color: color),
                                                ))
                                          ],
                                        )
                                      : Container(),
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
                                            "${checklist.prefix} - ${checklist.alfa}",
                                            style: title.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(
                                          checklist.pb,
                                          style: title.copyWith(
                                              fontWeight: FontWeight.bold),
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
                                      "${checklist.user.name} - ${checklist.user.matricula}",
                                      style: title.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "KM Inicial",
                                                style: subtitleHint,
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                checklist.kmStart,
                                                style: title.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "KM Final",
                                                style: subtitleHint,
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                checklist.kmFinal.isEmpty
                                                    ? "---"
                                                    : checklist.kmFinal,
                                                style: title.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: IgnorePointer(
                                        ignoring: true,
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
                                    ),
                                    Wrap(
                                        children: List.generate(
                                            itens.length,
                                            (index) => changesListWidget(
                                                itensChanges: itens[index]))),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
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
                                        checklist.enable
                                            ? TextButton.icon(
                                                style: TextButton.styleFrom(
                                                    side: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                                onPressed: () async {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          SupplyWidget(
                                                            user:
                                                                checklist.user,
                                                            onInsert: checklist
                                                                    .enable
                                                                ? (value) async {
                                                                    await app.saveSupplies(
                                                                        supply:
                                                                            value,
                                                                        checklist:
                                                                            checklist);
                                                                  }
                                                                : null,
                                                          ));
                                                },
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                label: Text(
                                                  "Adicionar",
                                                  style: title.copyWith(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ))
                                            : Container(),
                                      ],
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    (checklist.supply.isEmpty)
                                        ? Center(
                                            child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                                "Ops ! Nenhum registro encontrado.",
                                                style: title),
                                          ))
                                        : Column(
                                            children: List.generate(
                                                checklist.supply.length,
                                                (index) => CardCarSupply(
                                                      supply: checklist
                                                          .supply[index],
                                                      onTap: checklist.enable
                                                          ? () async {
                                                              await app.deleteSupply(
                                                                  supply: checklist
                                                                          .supply[
                                                                      index],
                                                                  checklist:
                                                                      checklist);
                                                            }
                                                          : null,
                                                      details: true,
                                                    )),
                                          ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Center(
                                      child: CarChangesWidget(
                                        add: false,
                                        user: checklist.user,
                                        initValue:
                                            checklist.checkCar.car.changes,
                                      ),
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
                                      checklist.obs,
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
                        (checklist.dateFinish == null)
                            ? Container()
                            : Text(
                                "Checklist finalizado em ${formatDate(checklist.dateFinish!)}",
                                style: subtitleHint,
                              ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
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

Widget changesListWidget({required ItensChangesModel itensChanges}) => Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itensChanges.description,
            style: titleHint,
          ),
          const Divider(),
          Column(
            children: List.generate(
                itensChanges.itens.length,
                (index) => Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(2)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              itensChanges.itens[index].description,
                              style: subtitle,
                            ),
                          ),
                          itensChanges.itens[index].value
                              ? Icon(MdiIcons.checkCircle,
                                  size: 20.0, color: Colors.green)
                              : Icon(MdiIcons.closeCircle,
                                  size: 20.0, color: Colors.red),
                        ],
                      ),
                    )),
          ),
          itensChanges.obs.isEmpty
              ? Container()
              : Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5)),
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
                      const SizedBox(
                        height: 5.0,
                      ),
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

class SupplyWidget extends StatefulWidget {
  final UserModel user;
  final Function(SupplyModel supply)? onInsert;
  const SupplyWidget({Key? key, this.onInsert, required this.user})
      : super(key: key);

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
        contentPadding: const EdgeInsets.all(10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FieldText(
              hint: "QUILÔMETRAGEM",
              validation: Validation.validatorNumber,
              inputType: TextInputType.number,
              onSaved: (value) {
                supply.kmSupply = value!;
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
                        if (widget.onInsert != null) {
                          widget.onInsert!(supply);
                        }
                      }
                    },
                    child: Text("INSERIR", style: titleButton)))
          ],
        ),
      ),
    );
  }
}
