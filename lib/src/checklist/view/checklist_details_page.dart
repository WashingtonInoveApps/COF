import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:bsu_control/model/supply_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/src/checklist/view/widget/fuel_widget.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/car_changes_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:signature/signature.dart';

import '../controller/checklist_controller.dart';

class ChecklistDetailsPage extends StatefulWidget {
  final String checklistID;
  const ChecklistDetailsPage({Key? key, required this.checklistID})
      : super(key: key);

  @override
  State<ChecklistDetailsPage> createState() => _ChecklistDetailsPageState();
}

class _ChecklistDetailsPageState extends State<ChecklistDetailsPage> {
  final app = GetIt.I.get<AppController>();

  late StreamSubscription subscription;
  late CheckListController controller;

  final signatureController = SignatureController();
  final endKMController = TextEditingController();
  final key = GlobalKey<FormState>();

  late CheckListModel checklist;
  bool loadingPage = true;

  @override
  void initState() {
    super.initState();
    controller = CheckListController(init: null, app: app);

    subscription = controller
        .streamChecklistByID(checklistID: widget.checklistID)
        .listen((value) {
      setState(() {
        checklist = value;
        loadingPage = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    endKMController.dispose();
    subscription.cancel();
    signatureController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loadingPage) {
      return const BackgraundPage(
          menu: false,
          childLeft: Center(
            child: CircularProgressIndicator(),
          ));
    }

    final obm = app.obms.firstWhere((e) => e.id == checklist.obmID);
    final car = app.cars.firstWhere((e) => e.id == checklist.checkCar.car.id);

    final listStates = List<StatesChecklist>.from(checklist.states);
    listStates.sort((a, b) => a.date.compareTo(b.date));

    final enable = ((listStates.first.state == StateChecklist.inprogress) &&
        checklist.enable &&
        (checklist.userID == app.user.id));

    return Stack(
      children: [
        BackgraundPage(
          menu: false,
          onBack: () => Navigator.of(context).pop(),
          top: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        obm.prefix,
                        style: Constants.title
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        checklist.cia.toUpperCase(),
                        style: Constants.title,
                      ),
                    ],
                  )),
                  enable
                      ? Row(
                          spacing: 10,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ChecklistRegisterPage(
                                            checklist: checklist,
                                          )));
                                },
                                child: Text(
                                  'Editar',
                                  style: Constants.titleButton,
                                )),
                            ElevatedButton(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      // isDismissible: false,
                                      builder: (context) => Padding(
                                            padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15,
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom +
                                                  15, // 🔥 SOBE COM TECLADO
                                            ),
                                            child: finishWidget(
                                              key: key,
                                              controller: endKMController,
                                              signatureController:
                                                  signatureController,
                                              onFinish: (value) async {
                                                Navigator.of(context).pop();

                                                controller.setLoading(true);
                                                final image =
                                                    await signatureController
                                                        .toPngBytes();

                                                await controller
                                                    .finish(
                                                        checklist:
                                                            checklist.copyWith(
                                                                endKM: value),
                                                        image: image)
                                                    .then((_) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              title: "Atenção",
                                                              message:
                                                                  'Parabéns ! Seu registro foi finalizado com sucesso.',
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                }).catchError((err) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              title: "Atenção",
                                                              message: err
                                                                  .toString(),
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                });
                                              },
                                            ),
                                          ));
                                },
                                child: Text(
                                  'Finalizar',
                                  style: Constants.titleButton,
                                )),
                          ],
                        )
                      : (app.user.admin)
                          ? ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Excluir',
                                style: Constants.titleButton,
                              ))
                          : Container(),
                ],
              ),
              const Divider()
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5)),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: listStates
                      .map((e) {
                        final state =
                            EnumCore.statusChecklistFromString(e.state.name);
                        return SizedBox(
                          width: 165,
                          child: Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(state.icon, color: state.color),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.label,
                                      style: Constants.subtitle,
                                    ),
                                    Text(
                                      Core.formatDate(e.date, shortHour: true),
                                      style: Constants.subtitle
                                          .copyWith(color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                      .expand((widget) => [widget, const VerticalDivider()])
                      .toList()
                    ..removeLast(),
                ),
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
                  "INFORMAÇÕES BÁSICAS",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10,
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
                          checklist.startKM,
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
                          (checklist.endKM.isEmpty ? ' - ' : checklist.endKM),
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
                  "NÍVEIS DE FLUIDOS",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: FluidsWidget(
                  oil: checklist.checkCar.oil,
                  hidra: checklist.checkCar.hidra,
                  fr: checklist.checkCar.fr,
                  arref: checklist.checkCar.arref,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  child: FuelWidget(fuel: checklist.checkCar.fuel)),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Constants.primary,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "ALTERAÇÕES",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                '${checklist.changes.length} alteração registrada',
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 10,
              ),
              CarChangesWidget(
                add: false,
                car: car,
                user: checklist.user,
                checklistID: checklist.id,
              ),
            ],
          ),
          childRight: Column(
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
                  "ITENS",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              (checklist.checkCar.car.itens.isEmpty)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : changesListWidget(
                      context: context,
                      categories: checklist.checkCar.car.itens,
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
                  "MATERIAIS",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              (checklist.checkCar.car.materials.isEmpty)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.title,
                    )
                  : changesListWidget(
                      context: context,
                      categories: checklist.checkCar.car.materials,
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
                  "OBSERVAÇÕES GERAL",
                  style: Constants.titleButton,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                checklist.obs.isEmpty
                    ? 'Nenhuma observação geral registrada.'
                    : checklist.obs,
                style: Constants.title,
              ),
              (checklist.signature != null)
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 50, bottom: 20),
                      child: Column(
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: checklist.signature!.url,
                              height: 60,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    color: Constants.primary,
                                    value: downloadProgress.progress),
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Core.boldFirstName(
                              graduation: checklist.user.graduation,
                              name: checklist.user.name,
                              fullName: checklist.user.fullname),
                          Text(
                            'Serviço finalizado em ${Core.formatDate(checklist.dateFinish!, largeDayHour: true)}',
                            style: Constants.subtitleHint,
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
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

Widget finishWidget(
    {required GlobalKey<FormState> key,
    required TextEditingController controller,
    required SignatureController signatureController,
    required Function(String value) onFinish}) {
  controller.clear();
  String label = '';

  return StatefulBuilder(builder: (context, setState) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 350),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  FieldText(
                    controller: controller,
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
              const SizedBox(
                height: 10.0,
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
                      'Insira sua assinatura',
                      style: Constants.subtitleHint,
                    ),
                    Stack(
                      children: [
                        Signature(
                          controller: signatureController,
                          height: 200,
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
                  ],
                ),
              ),
              Visibility(
                visible: label.isNotEmpty,
                child: Text(
                  'Insira sua assinatura',
                  style: Constants.titleHint,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  height: 50.0,
                  width: double.infinity,
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
                          }

                          onFinish(controller.text);
                        }
                      },
                      child: Text("FINALIZAR", style: Constants.titleButton)))
            ],
          ),
        ),
      ),
    );
  });
}

Widget changesListWidget(
    {required BuildContext context,
    required List<ItensChangesModel> categories}) {
  final list = List<ItensChangesModel>.from(categories);

  return StatefulBuilder(
    builder: (context, setState) {
      return ExpansionPanelList(
        elevation: 2,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, expanded) {
          setState(() {
            list[panelIndex].value = expanded;
          });
        },
        children: list.map((category) {
          return ExpansionPanel(
              isExpanded: category.value,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                  contentPadding: const EdgeInsets.only(left: 10),
                  title: Text(
                    category.description,
                    style: Constants.titleHint,
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: category.itens
                          .map((item) {
                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.description,
                                        style: Constants.title,
                                      ),
                                      (item.quantity > 1)
                                          ? Text(
                                              '${item.quantity} unids.',
                                              style: Constants.titleHint,
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                (item.quantity > 1)
                                    ? Row(
                                        children: [
                                          Text(
                                            '${item.quantityMarked} unids. ',
                                            style: Constants.title,
                                          ),
                                          Icon(
                                            item.value
                                                ? Icons.check_circle
                                                : MdiIcons.closeCircle,
                                            size: 25,
                                            color: item.value
                                                ? Colors.green.shade700
                                                : Colors.red,
                                          ),
                                        ],
                                      )
                                    : Icon(
                                        item.value
                                            ? Icons.check_circle
                                            : MdiIcons.closeCircle,
                                        size: 25,
                                        color: item.value
                                            ? Colors.green.shade700
                                            : Colors.red,
                                      )
                              ],
                            );
                          })
                          .expand((widget) => [
                                widget,
                                const Divider(),
                              ])
                          .toList()
                        ..removeLast(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Observações',
                      style: Constants.subtitleHint,
                    ),
                    Text(
                      category.obs.isEmpty
                          ? 'Nenhuma observação registrada.'
                          : category.obs,
                      style: Constants.title,
                    ),
                  ],
                ),
              ));
        }).toList(),
      );
    },
  );
  // return Padding(
  //   padding: const EdgeInsets.only(top: 15),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         itensChanges.description,
  //         style: Constants.titleHint,
  //       ),
  //       const Divider(),
  //       Column(
  //         children: List.generate(
  //             itensChanges.itens.length,
  //             (index) => Container(
  //                   margin: const EdgeInsets.only(bottom: 5.0),
  //                   padding: const EdgeInsets.all(6),
  //                   decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.grey.shade300),
  //                       borderRadius: BorderRadius.circular(2)),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           itensChanges.itens[index].description,
  //                           style: Constants.subtitle,
  //                         ),
  //                       ),
  //                       itensChanges.itens[index].value
  //                           ? Icon(MdiIcons.checkCircle,
  //                               size: 20.0, color: Colors.green)
  //                           : Icon(MdiIcons.closeCircle,
  //                               size: 20.0, color: Colors.red),
  //                     ],
  //                   ),
  //                 )),
  //       ),
  //       itensChanges.obs.isEmpty
  //           ? Container()
  //           : Container(
  //               padding: const EdgeInsets.all(5),
  //               decoration: BoxDecoration(
  //                   border: Border.all(color: Colors.grey.shade300),
  //                   borderRadius: BorderRadius.circular(5)),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   const SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text(
  //                     "OBSERVAÇÃO",
  //                     style: Constants.subtitleHint,
  //                   ),
  //                   const SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Text(
  //                     itensChanges.obs,
  //                     style: Constants.title,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //     ],
  //   ),
  // );
}

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
                    child: Text("INSERIR", style: Constants.titleButton)))
          ],
        ),
      ),
    );
  }
}
