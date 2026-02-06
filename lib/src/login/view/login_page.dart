import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get_it/get_it.dart';

import '../../../core/constants.dart';
import '../../home/home_page.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  final bool exit; //usado para não fazer o login automatico
  const LoginPage({Key? key, this.exit = false}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginController controller;

  final app = GetIt.I.get<AppController>();
  final formKey = GlobalKey<FormState>();

  final formKEY = GlobalKey<FormState>();
  final formKEYReset = GlobalKey<FormState>();

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = LoginController(app: app);

    controller.loginController((email) {
      controllerEmail.text = email;
      log(email);
    }).then((value) {
      if (widget.exit) {
        controller.setLoading(false);
        return;
      }

      if (value) {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const HomePage()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.primary,
      child: SafeArea(
        top: true,
        child: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            constraints: BoxConstraints(maxWidth: app.maxWidth),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/cbmcecabecalho2.png',
                    fit: BoxFit.fitHeight,
                    height: 70,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'COF',
                            style: Constants.title.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Controle Operacional de Frota',
                            style: Constants.title.copyWith(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Observer(builder: (context) {
                            if (controller.loading) {
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Constants.primary),
                              );
                            } else {
                              if (controller.state == LoginState.request) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Insira o código de verificação',
                                      style: Constants.title,
                                    ),
                                    VerificationCode(
                                      textStyle: Constants.title,
                                      keyboardType: TextInputType.number,
                                      length: 6,
                                      onCompleted: (value) {
                                        FocusScope.of(context).unfocus();
                                        controller
                                            .verifyCodePassword(code: value)
                                            .catchError((err) {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AlertMessage(
                                                      title: 'Atenção',
                                                      message: err.toString(),
                                                      onPressedOK: () =>
                                                          Navigator.of(context)
                                                              .pop()));
                                        });
                                      },
                                      onEditing: (value) {},
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ElevatedButton(
                                      onPressed: controller.cancelResetPassword,
                                      child: Text(
                                        'Cancelar',
                                        style: Constants.subtitle
                                            .copyWith(color: Colors.white),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          controller
                                              .requestPassword(
                                                  email: controllerEmail.text)
                                              .then((_) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: 'Atenção',
                                                    message:
                                                        'Entre em sua caixa de entrada no e-mail para ter acesso ao código de verificação.',
                                                    onPressedOK: () =>
                                                        Navigator.of(context)
                                                            .pop()));
                                          }).catchError((err) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertMessage(
                                                        title: 'Atenção',
                                                        message: err.toString(),
                                                        onPressedOK: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop()));
                                          });
                                        },
                                        child: Text(
                                          'Reenviar código',
                                          style: Constants.titleHint,
                                        )),
                                  ],
                                );
                              } else if (controller.state == LoginState.reset) {
                                return Form(
                                  key: formKEYReset,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints:
                                        const BoxConstraints(maxWidth: 400),
                                    child: Column(
                                      children: [
                                        FieldText(
                                          obscure: true,
                                          controller: controllerPassword,
                                          hint: 'Nova senha',
                                          validation:
                                              Validation.validatorPassoword,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FieldText(
                                          obscure: true,
                                          hint: 'Confirme sua senha',
                                          validation: (text) {
                                            if (controllerPassword.text ==
                                                    text &&
                                                controllerPassword
                                                    .text.isNotEmpty) {
                                              return null;
                                            }

                                            return 'Senhas não conferem';
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            child: Text(
                                              'REDEFINIR SENHA',
                                              style: Constants.titleButton,
                                            ),
                                            onPressed: () async {
                                              if (formKEYReset.currentState
                                                      ?.validate() ??
                                                  false) {
                                                controller
                                                    .resetPassword(
                                                        password:
                                                            controllerPassword
                                                                .text)
                                                    .catchError((err) {
                                                  if (mounted) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertMessage(
                                                                title:
                                                                    'Atenção',
                                                                message: err
                                                                    .toString(),
                                                                onPressedOK: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop()));
                                                  }
                                                });

                                                controllerPassword.clear();
                                              }
                                            },
                                          ),
                                        ),
                                        TextButton(
                                            onPressed:
                                                controller.cancelResetPassword,
                                            child: Text(
                                              'Cancelar',
                                              style: Constants.titleHint,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  constraints:
                                      const BoxConstraints(maxWidth: 400),
                                  child: Form(
                                    key: formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FieldText(
                                            controller: controllerEmail,
                                            hint: "Ex.: fulano@cb.ce.gov.br",
                                            label: 'E-mail',
                                            inputType:
                                                TextInputType.emailAddress,
                                            validation:
                                                Validation.validatorEmail,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          FieldText(
                                            controller: controllerPassword,
                                            inputType:
                                                TextInputType.visiblePassword,
                                            hint: "Senha",
                                            obscure: true,
                                            validation:
                                                Validation.validatorPassoword,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: SizedBox(
                                              height: 50.0,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    controller
                                                        .login(
                                                            email:
                                                                controllerEmail
                                                                    .text,
                                                            senha:
                                                                controllerPassword
                                                                    .text)
                                                        .then((_) async {
                                                      await Navigator.of(
                                                              context)
                                                          .pushReplacement(
                                                              CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const HomePage()));
                                                    }).catchError((err) async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) => AlertMessage(
                                                              title: "Atenção",
                                                              message: err
                                                                  .toString(),
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  "LOGIN",
                                                  style: Constants.titleButton,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                if (controllerEmail
                                                    .text.isEmpty) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              title: 'Atenção',
                                                              message:
                                                                  'Ops ! Insira seu e-mail para tentar recuperar sua senha.',
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                } else {
                                                  controller
                                                      .requestPassword(
                                                          email: controllerEmail
                                                              .text)
                                                      .then((_) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) => AlertMessage(
                                                            title: 'Atenção',
                                                            message:
                                                                'Entre em sua caixa de entrada no e-mail para ter acesso ao código de verificação.',
                                                            onPressedOK: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop()));
                                                  }).catchError((err) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertMessage(
                                                                title:
                                                                    'Atenção',
                                                                message: err
                                                                    .toString(),
                                                                onPressedOK: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop()));
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'Recuperar minha senha',
                                                style: Constants.titleHint,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Develop by SD BM Washington - BSU ${app.version}',
                  style: Constants.subtitle.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
