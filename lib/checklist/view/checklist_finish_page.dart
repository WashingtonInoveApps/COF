import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/checklist/controller/checklist_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/model/checklist_model.dart';
import 'package:bsu_control/model/material_checklist_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/widgets/alert_message.dart';
import 'package:bsu_control/widgets/alert_mult_message.dart';
import 'package:bsu_control/widgets/itens_section_widget.dart';
import 'package:bsu_control/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:signature/signature.dart';

import '../../model/item_model.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/container_custom_widget.dart';
import '../../widgets/textfield_widget.dart';

class ChecklistFinishPage extends StatefulWidget {
  final CheckListController controller;
  final ChecklistModel checklist;
  const ChecklistFinishPage(
      {Key? key, required this.checklist, required this.controller})
      : super(key: key);

  @override
  State<ChecklistFinishPage> createState() => _ChecklistFinishPageState();
}

class _ChecklistFinishPageState extends State<ChecklistFinishPage> {
  final app = GetIt.I.get<AppController>();

  final signatureController = SignatureController();
  final endKMController = TextEditingController();
  final obsController = TextEditingController();

  late CheckListController controller;
  late ChecklistModel checklist;

  UserModel? userSubstitute;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    checklist = widget.checklist;

    controller.clearMaterialsConsumed();
  }

  @override
  void dispose() {
    super.dispose();
    endKMController.dispose();
    signatureController.dispose();
    obsController.dispose();
  }

  Future<ChecklistModel> finish() async {
    try {
      widget.controller.setLoading(true);
      final image = await signatureController.toPngBytes();

      final result = await controller.finish(
        checklist: checklist.copyWith(
          material: checklist.material?.copyWith(
            materialsConsumed: controller.materialsConsumable,
          ),
          endKM: endKMController.text.isEmpty
              ? 0
              : int.parse(endKMController.text),
          obs: obsController.text,
          userSubstitute: userSubstitute,
        ),
        image: image,
      );

      widget.controller.setLoading(false);
      return result;
    } catch (e) {
      controller.setLoading(false);
      rethrow;
    }
  }

  List<ItemModel>? processItens(MaterialChecklistModel? model) {
    if (model == null) return null;

    Map<String, ItemModel> list = {};

    if (model.materials?.isEmpty ?? true) return [];

    for (final material in model.materials!) {
      for (final item in material.itens) {
        list[item.id] = item.copyWith(quantity: 0, quantityMarked: 0);
      }
    }

    return list.entries.map((e) => e.value).toList();
  }

  List<String> validationForm(ChecklistType type) {
    List<String> messagesError = [];

    if (type == ChecklistType.vehicular) {
      if (Validation.validatorNumber(endKMController.text) != null) {
        messagesError
            .add('Insira o KM final válido da viatura antes de continuar.');
      }
    }

    if (userSubstitute == null) {
      messagesError.add('Selecione seu substituto antes de continuar.');
    }

    if (signatureController.isEmpty) {
      messagesError.add('Insira sua assinatura antes de continuar.');
    }

    return messagesError;
  }

  @override
  Widget build(BuildContext context) {
    final vehicular = checklist.type == ChecklistType.vehicular;
    final materials = processItens(checklist.material?.material);

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
              const SizedBox(
                height: 5,
              ),
            ],
          ),
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(
                label: "INFORMAÇÕES BÁSICAS",
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                checklist.obm?.name.toUpperCase() ?? '',
                style: Constants.title.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                checklist.cia?.name.toUpperCase() ?? '',
                style: Constants.title,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '${checklist.pb} - ${checklist.team?.name ?? ''}',
                style: Constants.title,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Responsável",
                style: Constants.titleHint,
              ),
              const SizedBox(
                height: 2,
              ),
              Core.boldFirstName(
                graduation: checklist.user.graduation,
                name: checklist.user.name,
                fullName: checklist.user.fullname,
                style: Constants.title,
              ),
              Text(
                checklist.user.registration,
                style: Constants.titleHint,
              ),
              const SizedBox(
                height: 10,
              ),
              if (!vehicular)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ContainerCustom(label: "MATERIAIS UTILIZADOS"),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Insira os materiais consumidos durante o serviço.',
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Observer(builder: (context) {
                      return (controller.materialsConsumable.isEmpty)
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 10, left: 5, right: 5),
                              child: Column(
                                children: List.generate(
                                        controller.materialsConsumable.length,
                                        (index) {
                                  final material =
                                      controller.materialsConsumable[index];
                                  return Row(
                                    children: [
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      )),
                                      IconButton(
                                        onPressed: () {
                                          widget.controller
                                              .deleteMaterialConsumed(
                                            index,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  );
                                })
                                    .expand(
                                        (widget) => [widget, const Divider()])
                                    .toList()
                                  ..removeLast(),
                              ),
                            );
                    }),
                    Center(
                      child: IconButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: ItensSectionWidget(
                                        itensMaterials: materials,
                                        onChange:
                                            controller.addMaterialConsumed,
                                        obmID: 'obmID',
                                        ciaID: 'ciaID'),
                                  );
                                });
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Constants.primary),
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          )),
                    ),
                  ],
                ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
          childRight: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContainerCustom(label: "INFORMAÇÕES FINAIS"),
              Text(
                'Substituto',
                style: Constants.subtitleHint,
              ),
              ListWidget<UserModel>(
                value: userSubstitute,
                list: app.users,
                hint: 'Selecione o seu substituto',
                searchText: (user) {
                  return '${user.name} ${user.fullname} ${user.registration.replaceAll('.', '').replaceAll('-', '')}';
                },
                onSelect: (user) {
                  setState(() {
                    userSubstitute = user;
                  });
                },
                child: (user) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Core.boldFirstName(
                      name: user.name,
                      fullName: user.fullname,
                      style: Constants.title,
                      graduation: user.graduation,
                      over: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
              if (vehicular)
                Stack(
                  children: [
                    FieldText(
                      controller: endKMController,
                      hint: 'Ex.: 12345',
                      inputType: TextInputType.number,
                    ),
                    Positioned(
                        top: 0,
                        right: 10,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            'KM Final',
                            style: Constants.subtitleHint,
                          ),
                        ))
                  ],
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
                      'Assinatura digital',
                      style: Constants.titleHint,
                    ),
                    Stack(
                      children: [
                        Signature(
                          controller: signatureController,
                          height: 200,
                          width: double.infinity,
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
              const ContainerCustom(
                label: 'OBSERVAÇÕES GERAIS',
              ),
              FieldText(
                controller: obsController,
                hint: "EX.: Alguma informação importante",
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                        onPressed: () {
                          final messages = validationForm(checklist.type);

                          if (messages.isEmpty) {
                            finish().then((value) {
                              app.clearChecklistUser(value);

                              Navigator.of(context).pop();
                            }).catchError((err) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                      title: "Atenção",
                                      message: err.toString(),
                                      onPressedOK: () =>
                                          Navigator.of(context).pop()));
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertMultMessage(messages: messages));
                          }
                        },
                        child:
                            Text("Finalizar", style: Constants.titleButton))),
              )
            ],
          ),
        ),
        Observer(builder: (_) {
          return IgnorePointer(
            ignoring: !widget.controller.loading,
            child: Container(
              color: widget.controller.loading
                  ? Colors.black54
                  : Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    widget.controller.loading
                        ? Colors.white
                        : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}
