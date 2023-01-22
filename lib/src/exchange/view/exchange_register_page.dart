import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/exchange_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/exchange/controller/exchange_controller.dart';
import 'package:bsu_control/src/exchange/repository/exchange_repository.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
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

  late ExchangeController controller;
  late ExchangeModel exchange;

  @override
  void initState() {
    super.initState();
    controller = ExchangeController(app: app, repository: ExchangeRepository());
    controller.setRequested(app.usersValidations.first);

    exchange = ExchangeModel(
        date: DateTime.now(),
        requester: app.user,
        requested: controller.requested,
        dateFirst: controller.dateFirst,
        dateLast: controller.dateLast);
  }

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
                      Text(
                        'PERMUTA SAMU/CE',
                        style: titleHint,
                      ),
                      const Divider(),
                      Text(
                        'SOLICITANTE ${app.user.graduacao.toUpperCase()} ${app.user.name.toUpperCase()}',
                        style: title,
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
                              },
                              underline: Container(),
                              isExpanded: true,
                              items: List.generate(
                                  app.usersValidations.length,
                                  (index) => DropdownMenuItem<UserModel>(
                                        value: app.usersValidations[index],
                                        child: Text(
                                          '${app.usersValidations[index].graduacao.toUpperCase()} ${app.usersValidations[index].name.toUpperCase()}',
                                          style: subtitle,
                                        ),
                                      ))),
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'BASE ORIGEM',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Observer(builder: (_) {
                            return Container(
                              color: Colors.white,
                              height: 60,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      side: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  onPressed: () async {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2021),
                                            lastDate: DateTime(2050))
                                        .then((value) {
                                      if (value != null) {
                                        controller.setDateFirst(value);
                                        exchange.dateFirst = value;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      formatDate(controller.dateFirst,
                                          outher: true),
                                      style: title,
                                    ),
                                  )),
                            );
                          }),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: FieldText(
                              hint: 'EX.: USB MARANGUAPE',
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) {
                                exchange.baseFirst = value ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'BASE DESTINO',
                        style: titleHint,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Observer(builder: (_) {
                            return Container(
                              color: Colors.white,
                              height: 60,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      side: const BorderSide(
                                          width: 1, color: Colors.grey)),
                                  onPressed: () async {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2021),
                                            lastDate: DateTime(2050))
                                        .then((value) {
                                      if (value != null) {
                                        controller.setDateLast(value);
                                        exchange.dateLast = value;
                                      }
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      formatDate(controller.dateLast,
                                          outher: true),
                                      style: title,
                                    ),
                                  )),
                            );
                          }),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: FieldText(
                              hint: 'EX.: USB CAPISTRANO',
                              validation: Validation.validatorPreenchimento,
                              onSaved: (value) {
                                exchange.baseLast = value ?? '';
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Observer(builder: (_) {
                            return Checkbox(
                                value: controller.checkConfirm,
                                onChanged: (value) {
                                  controller.setCheckConfirm(value);
                                  exchange.requesterAuthorizedDate =
                                      DateTime.now();
                                });
                          }),
                          Expanded(
                            child: Text(
                              'O militar fica responsável para executar o respesctivo serviço estando sujeito a inteira responsábilidade inerente a sua execução. Confirmo e autorizo a permuta.',
                              style: title,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 45.0,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (controller.checkConfirm) {
                                  if (keyForm.currentState?.validate() ??
                                      false) {
                                    keyForm.currentState?.save();
                                    final result = await controller.save(
                                        exchange: exchange);

                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                            title: '',
                                            message: result
                                                ? 'Sua solicitação de permuta foi criada, aguarde autorização.'
                                                : 'Ops ! Falha ao solicitar permuta, entre em contato com o gestor.',
                                            onPressedOK: () =>
                                                Navigator.of(context)
                                                  ..pop()
                                                  ..pop()));
                                  }
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: '',
                                          message:
                                              'Confirme e autorize a solicitação da permuta antes de continuar.',
                                          onPressedOK: () =>
                                              Navigator.of(context).pop()));
                                }
                              },
                              child: Text(
                                "SOLICITAR PERMUTA",
                                style: titleButton,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
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
