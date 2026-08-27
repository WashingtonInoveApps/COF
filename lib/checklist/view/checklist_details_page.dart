import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/view/checklist_finish_page.dart';
import 'package:bsu_control/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/checklist/view/widget/fluids_widget.dart';
import 'package:bsu_control/checklist/view/widget/fuel_widget.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/section_itens_model.dart';
import 'package:bsu_control/widgets/container_custom_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../widgets/alert_message.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/car_changes_widget.dart';
import '../../widgets/card_outhers_widget.dart';
import '../../widgets/tag_widget.dart';
import '../controller/checklist_controller.dart';

class ChecklistDetailsPage extends StatefulWidget {
  final ChecklistModel checklist;
  const ChecklistDetailsPage({Key? key, required this.checklist})
      : super(key: key);

  @override
  State<ChecklistDetailsPage> createState() => _ChecklistDetailsPageState();
}

class _ChecklistDetailsPageState extends State<ChecklistDetailsPage> {
  final app = GetIt.I.get<AppController>();

  late StreamSubscription subscription;
  late CheckListController controller;
  late ChecklistModel checklist;

  @override
  void initState() {
    super.initState();
    checklist = ChecklistModel.fromMap(widget.checklist.toMap());

    controller = CheckListController(
      config: config,
      checklistTodays: app.checklistsOperationDay,
    );

    subscription = controller
        .streamChecklistByID(checklistID: widget.checklist.id!)
        .listen((value) {
      setState(() {
        checklist = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Widget stateWidget(List<StatesChecklist> list) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: list
            .map((value) {
              return SizedBox(
                width: 250,
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TagWidget(
                      label: value.state.label,
                      color: value.state.color,
                      icon: value.state.icon,
                    ),
                    Text(
                      Core.formatDate(value.date, largeDayHour: true),
                      style: Constants.subtitleHint.copyWith(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            })
            .expand((widget) => [widget, const VerticalDivider()])
            .toList()
          ..removeLast(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obm = app.obms.firstWhere((e) => e.id == checklist.obmID);

    final car = app.cars.cast<CarModel?>().firstWhere(
        (e) => e?.id == checklist.vehicular?.car.id,
        orElse: () => null);

    final listStates = List<StatesChecklist>.from(checklist.states);
    listStates.sort((a, b) => a.date.compareTo(b.date));

    final vehicular = checklist.type == ChecklistType.vehicular;

    final itens = (vehicular
            ? checklist.vehicular?.car.itens
            : checklist.material?.material.itens) ??
        [];

    final List<SectionItensModel> materials =
        (!vehicular ? checklist.material?.material.materials : []) ?? [];

    final enable = checklist.enable && (checklist.userID == app.user.id);

    return Stack(
      children: [
        BackgraundPage(
          menu: false,
          onBack: () => Navigator.of(context).pop(),
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicular ? 'CHECKLIST VEICULAR' : 'CHECKLIST MATERIAL',
                style: Constants.title.copyWith(fontSize: 18),
              ),
              Text(
                Core.formatDate(checklist.date, largeDayHour: true),
                style: Constants.titleHint,
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              stateWidget(listStates),
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(label: 'INFORMAÇÕES BÁSICAS'),
              const SizedBox(
                height: 10,
              ),
              Text(
                'OBM',
                style: Constants.titleHint,
              ),
              Text(
                (checklist.obm != null)
                    ? '${checklist.obm?.prefix} - ${checklist.obm?.name ?? ''}'
                    : '-',
                style: Constants.title,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Companhia',
                style: Constants.titleHint,
              ),
              Text(
                (checklist.cia != null) ? checklist.cia?.name ?? '' : '-',
                style: Constants.title,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Prefixo',
                style: Constants.titleHint,
              ),
              Text(
                checklist.prefix.isEmpty ? '-' : checklist.prefix,
                style: Constants.title,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Guarnição',
                style: Constants.titleHint,
              ),
              Text(
                (checklist.team != null) ? checklist.team?.name ?? '' : '-',
                style: Constants.title,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Responsável',
                style: Constants.titleHint,
              ),
              Core.boldFirstName(
                name: checklist.user.name,
                fullName: checklist.user.fullname,
                style: Constants.title,
              ),
              Text(
                checklist.user.graduation,
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Matrícula',
                style: Constants.titleHint,
              ),
              Text(
                checklist.user.registration,
                style: Constants.title,
              ),
              const SizedBox(
                height: 10,
              ),
              if (vehicular)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
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
                ),
              if (checklist.type == ChecklistType.vehicular)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ContainerCustom(label: "NÍVEIS DE FLUIDOS"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Combustível',
                      style: Constants.titleHint,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child:
                            FuelWidget(fuel: checklist.vehicular?.fuel ?? 0.0)),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Níveis de Fluídos',
                      style: Constants.titleHint,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: FluidsWidget(
                        oil: checklist.vehicular?.oil ?? 0,
                        hidra: checklist.vehicular?.hidra ?? 0,
                        fr: checklist.vehicular?.fr ?? 0,
                        arref: checklist.vehicular?.arref ?? 0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ContainerCustom(label: "ALTERAÇÕES"),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${checklist.vehicular?.changes?.length ?? 0} alterações registradas.',
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CarChangesWidget(
                      add: false,
                      car: car!,
                      user: checklist.user,
                      checklistID: checklist.id,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
            ],
          ),
          childRight: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(
                label: 'OUTRAS ALTERAÇÕES',
              ),
              const SizedBox(
                height: 10,
              ),
              (checklist.others?.isEmpty ?? true)
                  ? Text(
                      'Nenhuma outra alteração encontrada',
                      style: Constants.titleHint,
                    )
                  : Column(
                      children:
                          List.generate(checklist.others!.length, (index) {
                        final other = checklist.others![index];
                        return CardOutherChange(other: other);
                      }).expand((widget) => [widget, const Divider()]).toList()
                            ..removeLast(),
                    ),
              const SizedBox(
                height: 15,
              ),
              const ContainerCustom(label: "ITENS OU ACESSÓRIOS"),
              const SizedBox(
                height: 10,
              ),
              (itens.isEmpty)
                  ? Text(
                      'Nenhum registro de itens encontrado.',
                      style: Constants.titleHint,
                    )
                  : changesListWidget(context: context, categories: itens),
              if (checklist.vehicular?.obs.isNotEmpty ?? false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Observações',
                      style: Constants.subtitleHint,
                    ),
                    Text(
                      checklist.vehicular?.obs ?? '',
                      style: Constants.title,
                    ),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              if (!vehicular)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ContainerCustom(label: 'MATERIAIS'),
                    const SizedBox(
                      height: 10,
                    ),
                    (materials.isEmpty)
                        ? Text(
                            'Nenhum registro de materiais encontrado.',
                            style: Constants.titleHint,
                          )
                        : changesListWidget(
                            context: context, categories: materials),
                    if (checklist.material?.obs.isNotEmpty ?? false)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Observações',
                            style: Constants.subtitleHint,
                          ),
                          Text(
                            checklist.material?.obs ?? '',
                            style: Constants.title,
                          ),
                        ],
                      ),
                  ],
                ),
              if (!vehicular)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const ContainerCustom(
                      label: "MATERIAIS UTILIZADOS",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (checklist.material?.materialsConsumed?.isEmpty ?? true)
                        ? Text(
                            'Nenhum material utilizado registrado.',
                            style: Constants.titleHint,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                    checklist.material!.materialsConsumed!
                                        .length, (index) {
                              final material =
                                  checklist.material!.materialsConsumed![index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                              );
                            })
                                .expand((widget) => [widget, const Divider()])
                                .toList()
                              ..removeLast(),
                          ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
              const ContainerCustom(label: "OBSERVAÇÕES GERAIS"),
              const SizedBox(
                height: 10,
              ),
              Text(
                checklist.obs.isEmpty
                    ? 'Nenhum registro encontrado.'
                    : checklist.obs,
                style: checklist.obs.isEmpty
                    ? Constants.titleHint
                    : Constants.title,
              ),
              const SizedBox(
                height: 10,
              ),
              if (checklist.signature != null)
                Container(
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
                        fullName: checklist.user.fullname,
                        style: Constants.title,
                      ),
                      Text(
                        'Serviço finalizado em ${Core.formatDate(checklist.dateFinish!, largeDayHour: true)}',
                        style: Constants.subtitleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (checklist.userSubstitute != null)
                        Column(
                          children: [
                            Core.boldFirstName(
                              graduation: checklist.userSubstitute!.graduation,
                              name: checklist.userSubstitute!.name,
                              fullName: checklist.userSubstitute!.fullname,
                              style: Constants.title,
                            ),
                            Text(
                              'Substituto',
                              style: Constants.subtitleHint,
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 5,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.end,
                  children: [
                    if (app.user.admin || app.user.managerFleet)
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      title: 'Atenção',
                                      message:
                                          'Você perderá todas as alterações realizadas neste registro. Deseja realmente excluí-lo?',
                                      titleOK: 'Sim',
                                      cancel: true,
                                      onPressedCancel: () =>
                                          Navigator.of(context).pop(false),
                                      onPressedOK: () => Navigator.of(context)
                                          .pop(true))).then((value) {
                                if (value ?? false) {
                                  controller
                                      .delete(checklist: checklist)
                                      .then((_) {
                                    Navigator.of(context).pop();
                                  }).catchError((err) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                            title: 'Atenção',
                                            message: err.toString(),
                                            onPressedOK: () =>
                                                Navigator.of(context).pop()));
                                  });
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text(
                              'Excluir',
                              style: Constants.titleButton,
                            )),
                      ),
                    if (enable)
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChecklistRegisterPage(
                                        type: checklist.type,
                                        checklist: checklist,
                                      )));
                            },
                            child: Text(
                              'Editar',
                              style: Constants.titleButton,
                            )),
                      ),
                    if (enable)
                      SizedBox(
                        width: 120,
                        child: ElevatedButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      message:
                                          'Deseja realmente finalizar este checklist?',
                                      titleOK: 'Sim',
                                      cancel: true,
                                      onPressedCancel: () =>
                                          Navigator.of(context).pop(false),
                                      onPressedOK: () => Navigator.of(context)
                                          .pop(true))).then((result) {
                                if (result ?? false) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChecklistFinishPage(
                                            controller: controller,
                                            checklist: checklist,
                                          )));
                                }
                              });
                            },
                            child: Text(
                              'Finalizar',
                              style: Constants.titleButton,
                            )),
                      ),
                  ],
                ),
              ),
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

Widget changesListWidget(
    {required BuildContext context,
    required List<SectionItensModel> categories}) {
  final list = List<SectionItensModel>.from(categories);

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
                    style: Constants.title,
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
                    category.obs.isEmpty
                        ? Text(
                            'Nenhuma observação geral registrada.',
                            style: Constants.titleHint,
                          )
                        : Text(
                            category.obs,
                            style: Constants.title,
                          ),
                  ],
                ),
              ));
        }).toList(),
      );
    },
  );
}
