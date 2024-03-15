import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/src/checklist/view/checklist_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
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
        Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Observer(builder: (_) {
              return Text(
                'Develop by Washington, ${controller.version}',
                style: subtitle.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              );
            }),
          ),
          body: Column(
            children: [
              const AppBarCustom(
                menu: false,
                page: 3,
                back: false,
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 5,
                        left: 10,
                        right: 10,
                        child: Center(
                          child: Opacity(
                              opacity: 0.1,
                              child: Image.asset(
                                'assets/bsu.png',
                                width: 230,
                                fit: BoxFit.cover,
                              )),
                        )),
                    Center(
                      child: Form(
                        key: _key,
                        child: SizedBox(
                          width: 320.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FieldText(
                                controller: controllerEmail,
                                upper: false,
                                hint: "E-MAIL",
                                validation: Validation.validatorEmail,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              FieldText(
                                controller: controllerPassword,
                                hint: "SENHA",
                                inputType: TextInputType.visiblePassword,
                                obscure: true,
                                upper: false,
                                validation: Validation.validatorPassoword,
                              ),
                              const SizedBox(
                                height: 15.0,
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
                                        if (!value) {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertMessage(
                                                  title: "Atenção",
                                                  message:
                                                      "Ops ! Falha ao tentar realizar o login.",
                                                  onPressedOK: () =>
                                                      Navigator.of(context)
                                                          .pop()));
                                        } else {
                                          if (!controller.user.enable) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: "Atenção",
                                                    message:
                                                        "Ops ! Acesso ainda não liberado, contate o administrador.",
                                                    onPressedOK: () =>
                                                        Navigator.of(context)
                                                            .pop()));
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ChecklistPage()));
                                          }
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    "ENTRAR",
                                    style: titleButton,
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
                                                    Navigator.of(context)
                                                        .pop()));
                                      });
                                    }
                                  },
                                  child: Text(
                                    "Esqueci minha senha",
                                    style: title.copyWith(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ],
                          ),
                        ),
                      ),
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
