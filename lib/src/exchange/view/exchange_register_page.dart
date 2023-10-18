import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/exchange/controller/exchange_controller.dart';
import 'package:bsu_control/src/exchange/repository/exchange_repository.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class ExchangeRegisterPage extends StatefulWidget {
  const ExchangeRegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _ExchangeRegisterPageState();
}

class _ExchangeRegisterPageState extends State<ExchangeRegisterPage> {
  final controllerCOD = TextEditingController();
  final app = GetIt.I.get<AppController>();
  final keyForm = GlobalKey<FormState>();

  final unidad = ['QUARTEL', 'SAMU'];

  final function = [
    'OFICIAL DE DIA',
    'CONDUTOR/SOCORRISTA',
    'ADJ. OFICIAL DE DIA'
  ];

  final types = ['SIMPLES', 'DUPLA'];

  late ExchangeController controller;
  late ExchangeModel exchange;

  @override
  void initState() {
    super.initState();
    controller = ExchangeController(app: app, repository: ExchangeRepository());

    controller.setRequested(app.usersValidations.first);
    controller.setUnidad(unidad.first);
    controller.setFunction(function.first);
    controller.setType(types.first);
    controller.setSamu(false);

    exchange = ExchangeModel(
        requesterID: app.user.id,
        unidad: controller.unidad,
        type: controller.type,
        function: controller.function,
        date: controller.referenceDate,
        requester: app.user,
        requested: controller.requested,
        firstDateFirst: controller.firstDateFirst,
        lastDateFirst: controller.lastDateFirst,
        firstDateLast: controller.firstDateLast,
        lastDateLast: controller.lastDateLast);
  }

  Widget dateTimeWidget(
          {required DateTime date,
          bool next = false,
          required Function(DateTime) onDate}) =>
      Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              next ? 'às' : 'De',
              style: titleHint,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Observer(builder: (_) {
              return Container(
                color: Colors.white,
                height: 60,
                child: TextButton(
                    style: TextButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.grey)),
                    onPressed: () async {
                      showTimePicker(
                              context: context, initialTime: TimeOfDay.now())
                          .then((value) {
                        if (value != null) {
                          onDate(
                              controller.processDate(date: date, hour: value));
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        formatHour(
                            TimeOfDay(hour: date.hour, minute: date.minute)),
                        style: title,
                      ),
                    )),
              );
            }),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'do dia',
            style: titleHint,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Observer(builder: (_) {
              return Container(
                color: Colors.white,
                height: 60,
                child: TextButton(
                    style: TextButton.styleFrom(
                        side: const BorderSide(width: 1, color: Colors.grey)),
                    onPressed: () async {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2050))
                          .then((value) {
                        if (value != null) {
                          onDate(controller.processDate(
                              date: value,
                              hour: TimeOfDay(
                                  hour: date.hour, minute: date.minute)));
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        formatDate(date, outher: true),
                        style: title,
                      ),
                    )),
              );
            }),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarCustom(
                menu: false,
              ),
              Expanded(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: keyForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(text: 'SOLICITANTE ', children: [
                          TextSpan(
                              text:
                                  '${app.user.graduacao.toUpperCase()} ${app.user.name.toUpperCase()}',
                              style:
                                  title.copyWith(fontWeight: FontWeight.bold))
                        ]),
                        style: title.copyWith(color: Colors.grey),
                      ),
                      Text(
                        'MATRICULA ${app.user.matricula.toUpperCase()}',
                        style: titleHint,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'UNIDADE',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Observer(builder: (_) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                              value: controller.unidad,
                              onChanged: (value) {
                                controller.setUnidad(value);
                                controller.setSamu(value == 'SAMU');
                                exchange.unidad = value ?? '';
                              },
                              underline: Container(),
                              isExpanded: true,
                              items: List.generate(
                                  unidad.length,
                                  (index) => DropdownMenuItem<String>(
                                        value: unidad[index],
                                        child: Text(
                                          unidad[index],
                                          style: title,
                                        ),
                                      ))),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'FUNÇÃO',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Observer(builder: (_) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                              value: controller.function,
                              onChanged: (value) {
                                controller.setFunction(value);
                                exchange.function = value ?? '';
                              },
                              underline: Container(),
                              isExpanded: true,
                              items: List.generate(
                                  function.length,
                                  (index) => DropdownMenuItem<String>(
                                        value: function[index],
                                        child: Text(
                                          function[index],
                                          style: title,
                                        ),
                                      ))),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'MOTIVO',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FieldText(
                        hint: 'EX.: DE SERVIÇO NO QUARTEL',
                        validation: Validation.validatorPreenchimento,
                        onSaved: (value) {
                          exchange.reason = value ?? '';
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'SOLICITADO',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Observer(builder: (_) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<UserModel>(
                              value: controller.requested,
                              onChanged: (value) {
                                controller.setRequested(value);
                                exchange.requested = value;
                                exchange.requestedID = value?.id ?? '';
                              },
                              underline: Container(),
                              isExpanded: true,
                              items: List.generate(
                                  app.usersValidations.length,
                                  (index) => DropdownMenuItem<UserModel>(
                                        value: app.usersValidations[index],
                                        child: Text(
                                          '${app.usersValidations[index].graduacao.toUpperCase()} ${app.usersValidations[index].name.toUpperCase()}',
                                          style: title,
                                        ),
                                      ))),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'TIPO',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Observer(builder: (_) {
                        return IgnorePointer(
                          ignoring: controller.isSamu,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton<String>(
                                value: controller.type,
                                onChanged: (value) {
                                  controller.setType(value);
                                  controller.setSimple(value == 'SIMPLES');
                                  exchange.type = value ?? '';
                                },
                                underline: Container(),
                                isExpanded: true,
                                items: List.generate(
                                    types.length,
                                    (index) => DropdownMenuItem<String>(
                                          value: types[index],
                                          child: Text(
                                            types[index],
                                            style: title,
                                          ),
                                        ))),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Registro solicitação para executar o serviço no periodo:',
                        style: title,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Observer(
                          builder: (context) => dateTimeWidget(
                              date: controller.firstDateFirst,
                              onDate: (value) {
                                controller.setFirstDateFirst(value);
                                exchange.firstDateFirst = value;
                              })),
                      const SizedBox(
                        height: 10,
                      ),
                      Observer(
                          builder: (context) => dateTimeWidget(
                              next: true,
                              date: controller.lastDateFirst,
                              onDate: (value) {
                                controller.setLastDateFirst(value);
                                exchange.lastDateFirst = value;
                              })),
                      Observer(builder: (_) {
                        return Visibility(
                            visible: !controller.isSimple,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'E para este militar executar meu serviço no periodo:',
                                  style: title,
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 5,
                                ),
                                dateTimeWidget(
                                    date: controller.firstDateLast,
                                    onDate: (value) {
                                      controller.setFirstDateLast(value);
                                      exchange.firstDateLast = value;
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                dateTimeWidget(
                                    next: true,
                                    date: controller.lastDateLast,
                                    onDate: (value) {
                                      controller.setLastDateLast(value);
                                      exchange.lastDateLast = value;
                                    }),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ));
                      }),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 45.0,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (keyForm.currentState?.validate() ?? false) {
                                  keyForm.currentState?.save();
                                  debugPrint(exchange.toJson());
                                  // controller
                                  //     .save(exchange: exchange)
                                  //     .then((result) {
                                  //   if (!result) {
                                  //     showDialog(
                                  //         context: context,
                                  //         builder: (context) => AlertMessage(
                                  //             title: '',
                                  //             message:
                                  //                 'Ops ! Falha ao solicitar permuta, entre em contato com o gestor.',
                                  //             onPressedOK: () =>
                                  //                 Navigator.of(context).pop()));
                                  //   }
                                  // });
                                }
                              },
                              child: Text(
                                "GERAR PERMUTA",
                                style: title.copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              )),
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
