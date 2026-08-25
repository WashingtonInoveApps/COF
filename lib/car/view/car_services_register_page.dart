import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/controller/car_controller.dart';
import 'package:bsu_control/car/controller/car_service_register_controller.dart';
import 'package:bsu_control/car/view/car_services_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/car_service_model.dart';
import 'package:bsu_control/model/file_model.dart';
import 'package:bsu_control/widgets/backgraund_page.dart';
import 'package:bsu_control/widgets/container_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../../widgets/textfield_widget.dart';
import '../../enum/car_enum.dart';
import '../../widgets/alert_message.dart';
import '../../widgets/alert_mult_message.dart';
import 'widgets/card_imagem_service_widget.dart';

class CarServiceRegisterPage extends StatefulWidget {
  final CarServiceModel? service;
  const CarServiceRegisterPage({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  State<CarServiceRegisterPage> createState() => _CarServiceRegisterPageState();
}

class _CarServiceRegisterPageState extends State<CarServiceRegisterPage> {
  final app = GetIt.I.get<AppController>();
  late CarController controller;
  late CarServiceRegisterController register;

  @override
  void initState() {
    super.initState();
    controller = CarController(config: config, user: app.user);

    register = CarServiceRegisterController(
      user: app.user,
      init: widget.service,
      cars: app.cars,
    );
  }

  @override
  Widget build(BuildContext context) {
    final update = (widget.service != null);
    return Stack(
      children: [
        BackgraundPage(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${update ? 'Alterar' : 'Novo'} Registro de Serviço',
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childLeft: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(label: 'INFORMAÇÕES BÁSICAS'),
              const SizedBox(
                height: 10,
              ),
              Observer(builder: (_) {
                return InkWell(
                  onTap: () {
                    showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 1)),
                            lastDate: DateTime.now())
                        .then(register.changeDate);
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Data',
                          style: Constants.titleHint,
                        ),
                        Expanded(
                          child: Text(
                            Core.formatDate(register.date, largeDay: true),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 25,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(text: "PREFIXO ", children: [
                  TextSpan(
                      text: '*',
                      style: Constants.title.copyWith(color: Colors.red))
                ]),
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 5,
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
                  return DropdownButton<CarModel?>(
                      isExpanded: true,
                      value: register.car,
                      underline: Container(),
                      onChanged: register.setCar,
                      items: [
                        DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Selecione',
                              style: Constants.title,
                            )),
                        ...app.carsUsers
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(
                                      e.prefix,
                                      style: Constants.title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList()
                      ]);
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(text: "MOTIVO ", children: [
                  TextSpan(
                      text: '*',
                      style: Constants.title.copyWith(color: Colors.red))
                ]),
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                child: Observer(builder: (_) {
                  return DropdownButton<StateCarProblems>(
                      value: register.problem,
                      onChanged: register.setProblem,
                      underline: Container(),
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Selecione',
                              style: Constants.title,
                            )),
                        ...List.generate(StateCarProblems.values.length,
                            (index) {
                          return DropdownMenuItem<StateCarProblems>(
                            value: StateCarProblems.values[index],
                            child: Text(
                              StateCarProblems.values[index].label,
                              style: Constants.title,
                            ),
                          );
                        })
                      ]);
                }),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text.rich(
                TextSpan(text: "DESCRIÇÃO ", children: [
                  TextSpan(
                      text: '*',
                      style: Constants.title.copyWith(color: Colors.red))
                ]),
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 5,
              ),
              FieldText(
                initValue: register.description,
                hint: "Desccrição do registro.",
                onChange: register.changeDescription,
                maxLines: null,
              ),
              const SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(text: "LOCAL ", children: [
                  TextSpan(
                      text: '*',
                      style: Constants.title.copyWith(color: Colors.red))
                ]),
                style: Constants.subtitleHint,
              ),
              const SizedBox(
                height: 5,
              ),
              FieldText(
                initValue: register.local,
                hint: "Local",
                onChange: register.changeLocal,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 55.0,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      "Garantia",
                      style: Constants.titleHint,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year),
                                  lastDate: DateTime(DateTime.now().year + 5))
                              .then((value) {
                            if (value != null) {
                              register.changeExpireted(value);
                            }
                          });
                        },
                        onLongPress: () {
                          register.changeExpireted(null);
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Observer(builder: (context) {
                                return (register.expireted == null)
                                    ? Text(
                                        'Sem validade',
                                        style: Constants.subtitleHint,
                                        textAlign: TextAlign.right,
                                      )
                                    : Text(
                                        Core.formatDate(register.expireted!,
                                            largeDay: true),
                                        textAlign: TextAlign.right,
                                        style: Constants.title,
                                        overflow: TextOverflow.ellipsis,
                                      );
                              }),
                            ),
                            if ((register.expireted != null))
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey.shade700,
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          childRight: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(label: 'IMAGENS'),
              const SizedBox(
                height: 10,
              ),
              Observer(builder: (context) {
                return register.images.isEmpty
                    ? Text(
                        'Nenhuma imagem encontrada.',
                        style: Constants.titleHint,
                      )
                    : SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(register.images.length, (index) {
                            final image = register.images[index];

                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: CardServiceImageWidget(
                                  value: image,
                                  onDelete: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                              message:
                                                  'Deseja deletar essa imagem ?',
                                              cancel: true,
                                              titleOK: 'Sim',
                                              onPressedOK: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              onPressedCancel: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                            )).then((result) {
                                      if (result ?? false) {
                                        register.removeImage(index);
                                      }
                                    });
                                  }),
                            );
                          })
                                  .expand((widget) => [widget, const Divider()])
                                  .toList()
                                ..removeLast(),
                        ),
                      );
              }),
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: IconButton(
                      onPressed: () async {
                        Core.pickerImage(context: context, aspectRatio: null)
                            .then((result) {
                          if (result != null) {
                            register.addImage(FileModel(
                              id: const Uuid().v4(),
                              name: 'service',
                              url: '',
                              path: '',
                              data: result,
                            ));
                          }
                        });
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Constants.primary),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ))),
              const SizedBox(
                height: 10,
              ),
              const ContainerCustom(label: 'OBSERVAÇÕES IMPORTANTES'),
              const SizedBox(
                height: 10,
              ),
              FieldText(
                initValue: register.obs,
                hint: 'Observações importantes',
                onChange: register.changeOBS,
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "Cancelar",
                          style: Constants.titleButton,
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          final messagesValidation = register.validationForm();

                          if (messagesValidation.isEmpty) {
                            controller
                                .saveService(service: register.service)
                                .then((_) {
                              if (update) {
                                Navigator.of(context).pop();
                              } else {
                                app.setRouter(7);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CarServicesPage()));
                              }
                            }).catchError((err) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertMessage(
                                        title: 'Atenção',
                                        message: err.toString(),
                                        onPressedOK: () =>
                                            Navigator.of(context).pop(),
                                      ));
                            });
                          } else {
                            await showDialog(
                                context: context,
                                builder: (context) => AlertMultMessage(
                                    messages: messagesValidation));
                          }
                        },
                        child: Text(
                          update ? "Alterar" : "Salvar",
                          style: Constants.titleButton,
                        )),
                  ],
                ),
              )
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

// Widget cardImage(
//     {required FileModel value,
//     required Function() onDelete,
//     double heigth = 200,
//     double width = 200}) {
//   return Container(
//     margin: const EdgeInsets.only(right: 10),
//     child: Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadiusGeometry.circular(5),
//           child: value.data != null
//               ? Image.memory(
//                   value.data!,
//                   height: heigth,
//                   width: width,
//                   fit: BoxFit.cover,
//                 )
//               : kIsWeb
//                   ? Image.network(
//                       value.url,
//                       height: heigth,
//                       width: width,
//                       fit: BoxFit.cover,
//                     )
//                   : CachedNetworkImage(
//                       imageUrl: value.url,
//                       height: heigth,
//                       width: width,
//                       progressIndicatorBuilder:
//                           (context, url, downloadProgress) => Center(
//                         child: CircularProgressIndicator(
//                             color: Constants.primary,
//                             value: downloadProgress.progress),
//                       ),
//                       errorWidget: (context, url, error) => const Center(
//                           child: Icon(
//                         Icons.error,
//                         size: 60.0,
//                       )),
//                       fit: BoxFit.cover,
//                     ),
//         ),
//         Positioned(
//             top: 10,
//             right: 10,
//             child: InkWell(
//               onTap: onDelete,
//               child: const CircleAvatar(
//                 backgroundColor: Colors.black45,
//                 radius: 20,
//                 child: Icon(
//                   Icons.delete,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ))
//       ],
//     ),
//   );
// }
