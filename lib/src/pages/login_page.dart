import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  final bool exit;
  const LoginPage({Key? key, this.exit = false}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();

  final controller = GetIt.I.get<AppController>();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    controllerEmail.text = controller.user.email;
  }

  @override
  void dispose() {
    super.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgraundPage(
          login: true,
          bottom: Text(
            'Develop by SD Washington ${controller.version}',
            style: Constants.subtitle.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          childLeft: Container(
            height: (MediaQuery.of(context).size.height - 200),
            constraints: const BoxConstraints(minHeight: 300),
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'COF',
                    style: Constants.title
                        .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Controler Operacional de Frota',
                    style: Constants.title.copyWith(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _key,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FieldText(
                            controller: controllerEmail,
                            // upper: false,
                            hint: 'Digite seu e-mail',
                            label: 'E-mail',
                            validation: Validation.validatorEmail,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          FieldText(
                            controller: controllerPassword,
                            hint: 'Digite sua senha',
                            label: 'Senha',
                            inputType: TextInputType.visiblePassword,
                            obscure: true,
                            // upper: false,
                            validation: Validation.validatorPassoword,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 50.0,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  controller
                                      .login(
                                          email: controllerEmail.text,
                                          senha: controllerPassword.text)
                                      .then((value) async {
                                    if (!controller.user.enable) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertMessage(
                                              title: "Atenção",
                                              message:
                                                  "Ops ! Acesso ainda não liberado, contate o administrador.",
                                              onPressedOK: () =>
                                                  Navigator.of(context).pop()));
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
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
                                "ENTRAR",
                                style: Constants.titleButton,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () async {
                                if (controllerEmail.text.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: "Atenção",
                                          message:
                                              "Digite o e-mail para recuperação de senha.",
                                          onPressedOK: () =>
                                              Navigator.of(context).pop()));
                                } else {
                                  controller
                                      .recuperarPassword(
                                          email: controllerEmail.text)
                                      .then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                            title: "Atenção",
                                            message: value
                                                ? "E-mail de recuperação de senha enviado para sua caixa de entrada."
                                                : "Ops ! Falha ao tentar recuperar senha.",
                                            onPressedOK: () =>
                                                Navigator.of(context).pop()));
                                  });
                                }
                              },
                              child: Text(
                                "Esqueci minha senha",
                                style: Constants.title.copyWith(
                                    color: Theme.of(context).primaryColor),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
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
