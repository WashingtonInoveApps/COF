import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/car_changes_widget.dart';
import '../../widgets/textfield_widget.dart';
import '../controller/car_controller.dart';
import 'widgets/itens_section_widget.dart';
import 'widgets/section_widget.dart';

class CarRegisterPage extends StatefulWidget {
  final CarModel? car;
  const CarRegisterPage({Key? key, this.car}) : super(key: key);

  @override
  State createState() => _CarRegisterPageState();
}

class _CarRegisterPageState extends State<CarRegisterPage> {
  final app = GetIt.I.get<AppController>();

  late CarModel car;
  late CarController controller;

  final _key = GlobalKey<FormState>();
  final carTypeController = TextEditingController();

  final maskReference = MaskTextInputFormatter(
      mask: '###/## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final maskCard = MaskTextInputFormatter(
      mask: '#### #### #### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<dynamic> images = [];

  @override
  void initState() {
    super.initState();

    controller = CarController(
      config: config,
      user: app.user,
    );

    controller.cleanSections(list: controller.sectionsItens);
    controller.cleanSections(list: controller.sectionsMaterials);
    controller.cleanSections(list: controller.sectionsMaterialsConsumable);

    controller.setOBM(app.obms.firstWhere((e) => e.id == app.user.obmID));

    if (widget.car != null) {
      controller.setTypeCar(widget.car?.type);
      controller.setFunctionCar(widget.car?.function);

      controller.cleanSections(list: controller.sectionsItens);
      controller.cleanSections(list: controller.sectionsMaterials);
      controller.cleanSections(list: controller.sectionsMaterialsConsumable);

      car = CarModel.copy(widget.car!);
      for (final itens in car.itens) {
        controller.addSections(
            list: controller.sectionsItens,
            value: itens.copyWith(value: false));
      }

      for (final itens in car.materials) {
        controller.addSections(
            list: controller.sectionsMaterials,
            value: itens.copyWith(value: false));
      }

      for (final itens in car.materialsConsumable) {
        controller.addSections(
            list: controller.sectionsMaterialsConsumable,
            value: itens.copyWith(value: false));
      }

      controller.onChangesCar(widget.car?.changes ?? []);
    } else {
      car = CarModel(
          images: [],
          itens: [],
          materials: [],
          materialsConsumable: [],
          changes: [],
          status: [],
          mapas: [],
          state: StatusCar.waiting,
          function: Constants.carsFunctions.first,
          type: app.carsTypes.first);

      controller.setTypeCar(app.carsTypes.first);
      controller.setFunctionCar(Constants.carsFunctions.first);
    }
  }

  @override
  void dispose() {
    super.dispose();
    carTypeController.dispose();
  }

  Widget listSections(
      {required BuildContext context, required List<ItensChangesModel> list}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        list.isEmpty
            ? Text(
                'Nenhum itens encontrado.',
                style: Constants.title,
              )
            : Column(
                children: List.generate(list.length, (index) {
                  final section = list[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Expanded(
                                  child: Text(
                                section.description,
                                style: Constants.title,
                              )),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: 'Atenção',
                                          message:
                                              'Deseja excluir essa categoria de itens ?',
                                          cancel: true,
                                          titleOK: 'Sim',
                                          onPressedCancel: () =>
                                              Navigator.of(context).pop(false),
                                          onPressedOK: () =>
                                              Navigator.of(context)
                                                  .pop(true))).then((value) {
                                    if (value ?? false) {
                                      controller.removeSections(
                                          list: list, index: index);
                                    }
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.remove,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                            child: SectionWidget(
                                              section: section,
                                              onChange: (value) {
                                                controller.editSections(
                                                    list: list,
                                                    index: index,
                                                    value: value);
                                              },
                                            ),
                                          ));
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.edit,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => controller.expansionSections(
                                    list: list, index: index),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    section.value
                                        ? Icons.keyboard_arrow_up_outlined
                                        : Icons.keyboard_arrow_down_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                              visible: section.value,
                              child: SizedBox(
                                height: 300,
                                child: changesListWidget(
                                    section: section,
                                    context: context,
                                    onDelete: (indexItem) =>
                                        controller.removeItensSection(
                                            list: list,
                                            index: index,
                                            indexItem: indexItem),
                                    onAdd: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                                child: ItensSectionWidget(
                                                  onChange: (value) {
                                                    controller.addItensSection(
                                                        list: list,
                                                        index: index,
                                                        value: value);
                                                  },
                                                ),
                                              ));
                                    },
                                    onEdit: (item, indexItem) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                                child: ItensSectionWidget(
                                                  item: item,
                                                  onChange: (value) {
                                                    controller.editItensSection(
                                                        list: list,
                                                        index: index,
                                                        indexItem: indexItem,
                                                        value: value);
                                                  },
                                                ),
                                              ));
                                    },
                                    onMove: (indexItem, position) {
                                      controller.moveItensSection(
                                          list: list,
                                          index: index,
                                          indexItem: indexItem,
                                          position: position);
                                    }),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
              ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => Center(
                          child: SectionWidget(
                            onChange: (value) {
                              controller.addSections(list: list, value: value);
                            },
                          ),
                        ));
              },
              style: IconButton.styleFrom(backgroundColor: Constants.primary),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              )),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _key,
          child: BackgraundPage(
            menu: (widget.car == null),
            onBack:
                (widget.car == null) ? null : () => Navigator.of(context).pop(),
            top: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registro de veículo',
                  style: Constants.title.copyWith(fontSize: 18),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            childLeft: Column(
              spacing: 10,
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
                Text(
                  "ORGANIZAÇÃO",
                  style: Constants.titleHint,
                ),
                Container(
                  height: 50.0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Observer(builder: (_) {
                    return IgnorePointer(
                      ignoring: !app.user.admin,
                      child: DropdownButton<OBMModel>(
                          isExpanded: true,
                          value: controller.obm,
                          underline: Container(),
                          onChanged: controller.setOBM,
                          items: app.obms
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                              .toList()),
                    );
                  }),
                ),
                Observer(builder: (context) {
                  return Visibility(
                      visible: (controller.cia != null),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COMPANHIA",
                            style: Constants.titleHint,
                          ),
                          Container(
                            height: 50.0,
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
                Text(
                  "PREFIXO",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.prefix,
                  hint: "EX.: RESGATE 32",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.prefix = value ?? car.prefix,
                  upper: true,
                ),
                Text(
                  "MODELO",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.model,
                  hint: "EX.: RENAULT MASTER 2.3 2010",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.model = value ?? car.model,
                  upper: true,
                ),
                Text(
                  "PLACA",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.plate,
                  hint: "EX.: XXX2X45",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.plate = value ?? car.plate,
                  upper: true,
                ),
                Text(
                  "KM INICIAL",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.km.toString(),
                  hint: "EX.: 1234567",
                  inputType: TextInputType.number,
                  validation: Validation.validatorNumber,
                  onSaved: (value) => car.km = int.parse(value!),
                ),
                Text(
                  "MODELO DO PNEU",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.modelPneu,
                  hint: "EX.: 202/75 15",
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.modelPneu = value ?? car.modelPneu,
                  upper: true,
                  mask: [maskReference],
                ),
                Text(
                  "NÚMERO DO CARTÃO",
                  style: Constants.titleHint,
                ),
                FieldText(
                  initValue: car.ticket,
                  hint: "EX.: 0000 0000 0000 0000",
                  inputType: TextInputType.number,
                  validation: Validation.validatorPreenchimento,
                  onSaved: (value) => car.ticket = value ?? car.ticket,
                  mask: [maskCard],
                ),
                Text(
                  "FUNÇÃO",
                  style: Constants.titleHint,
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
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: controller.function,
                        underline: Container(),
                        onChanged: (value) {
                          controller.setFunctionCar(value);

                          FocusScope.of(context).unfocus();
                        },
                        items: Constants.carsFunctions
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(e.toUpperCase(),
                                        style: Constants.title),
                                  ),
                                ))
                            .toList());
                  }),
                ),
                Text(
                  "TIPO DE VEÍCULO",
                  style: Constants.titleHint,
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
                    return DropdownButton<String?>(
                        isExpanded: true,
                        value: controller.type,
                        underline: Container(),
                        onChanged: (value) {
                          controller.setTypeCar(value);
                          carTypeController.text = '';

                          FocusScope.of(context).unfocus();
                        },
                        items: app.carsTypes
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(e.toUpperCase(),
                                        style: Constants.title),
                                  ),
                                ))
                            .toList());
                  }),
                ),
                Observer(builder: (_) {
                  return controller.fieldCarTypeVisible
                      ? FieldText(
                          controller: carTypeController,
                          hint: "TIPO DE VEÍCULO",
                          validation: Validation.validatorPreenchimento,
                        )
                      : Container();
                }),
              ],
            ),
            childRight: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Constants.primary,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "ITENS OU ACESSÓRIOS",
                    style: Constants.titleButton,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Observer(builder: (context) {
                  return listSections(
                      context: context, list: controller.sectionsItens);
                }),
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
                    "MATERIAIS PERMANENTES",
                    style: Constants.titleButton,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Observer(builder: (context) {
                  return listSections(
                      context: context, list: controller.sectionsMaterials);
                }),
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
                    "MATERIAIS DE CONSUMO",
                    style: Constants.titleButton,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Observer(builder: (context) {
                  return listSections(
                      context: context,
                      list: controller.sectionsMaterialsConsumable);
                }),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Observer(builder: (_) {
                    final resultCar = car.copyWith(
                        changes: controller.carChanges
                            .toList()); //toList() para vê as mudanças

                    return CarChangesWidget(
                      car: resultCar,
                      remove: true,
                      register: true,
                      user: app.user,
                      update: true,
                      onChange: controller.onChangesCar,
                      onChangeImages: (value) {
                        images
                          ..clear()
                          ..addAll(value);
                      },
                    );
                  }),
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
                          if (_key.currentState?.validate() ?? false) {
                            _key.currentState!.save();

                            controller
                                .save(
                                    car: car.copyWith(
                                        type: controller.fieldCarTypeVisible
                                            ? carTypeController.text
                                            : controller.type),
                                    images: images)
                                .then((value) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      title: "Atenção",
                                      message:
                                          "Cadastro realizado com sucesso.",
                                      onPressedOK: () =>
                                          Navigator.of(context).pop()));

                              if (value) {
                                Navigator.of(context).pop();
                              }
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
                        },
                        child: Text(
                          (widget.car == null) ? "Salvar" : "Alterar",
                          style: Constants.titleButton,
                        )),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
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
                valueColor: AlwaysStoppedAnimation<Color>(
                    controller.loading ? Colors.white : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}

Widget changesListWidget(
    {required ItensChangesModel section,
    required BuildContext context,
    required Function(ItemModel, int) onEdit,
    required Function(int i) onDelete,
    required void Function(int, bool) onMove,
    required Function() onAdd}) {
  return Column(
    children: [
      const SizedBox(
        height: 5,
      ),
      const Divider(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
                section.itens.length,
                (index) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        spacing: 5,
                        children: [
                          Row(
                            spacing: 5,
                            children: [
                              Expanded(
                                child: Text(
                                  section.itens[index].description,
                                  style: Constants.subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Text(
                                '${section.itens[index].quantity} unids.',
                                style: Constants.subtitleHint,
                              )
                            ],
                          ),
                          Row(
                            spacing: 5,
                            children: [
                              InkWell(
                                onTap: (index == 0)
                                    ? null
                                    : () => onMove(index, true),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: (index == 0)
                                      ? Colors.grey
                                      : Constants.primary,
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: (index < (section.itens.length - 1))
                                    ? () => onMove(index, false)
                                    : null,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      (index < (section.itens.length - 1))
                                          ? Constants.primary
                                          : Colors.grey,
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                              InkWell(
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                onTap: () =>
                                    onEdit(section.itens[index], index),
                              ),
                              InkWell(
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                                onTap: () => onDelete(index),
                              ),
                            ],
                          )
                        ],
                      ),
                    )).expand((widget) => [widget, const Divider()]).toList()
              ..removeLast(),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Center(
        child: InkWell(
          onTap: onAdd,
          child: const CircleAvatar(
            radius: 15,
            backgroundColor: Constants.primary,
            child: Icon(
              Icons.add,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}
