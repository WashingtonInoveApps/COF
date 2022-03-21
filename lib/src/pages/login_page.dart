import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/pages/user_page.dart';
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
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();

  final controller = GetIt.I.get<AppController>();
  final _controllerEmail = TextEditingController();
  final _controllerSenha = TextEditingController();

  bool createUser = true;

  @override
  void initState() {
    super.initState();

    if (widget.exit) controller.deleteUserDBLocal().then((value) => null);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const AppBarCustom(
            menu: false,
            page: 3,
          ),
          body: FutureBuilder<bool>(
              future: controller.getUserDBLocal(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();

                if (snapshot.data ?? false) _controllerEmail.text = controller.user.email;

                return Center(
                  child: Form(
                    key: _key,
                    child: SizedBox(
                      width: 320.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          createUser
                              ? Row(
                                  children: [
                                    Text(
                                      "Ainda não possui cadastro ?",
                                      style: subtitleHint,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          _controllerEmail.clear();
                                          _controllerSenha.clear();
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserPage()));
                                        },
                                        child: Text(
                                          "Criar cadastro",
                                          style: title.copyWith(color: Theme.of(context).primaryColor),
                                        )),
                                  ],
                                )
                              : Container(),
                          FieldText(
                            controller: _controllerEmail,
                            upper: false,
                            hint: "E-MAIL",
                            validation: Validation.validatorEmail,
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          FieldText(
                            controller: _controllerSenha,
                            hint: "SENHA",
                            inputType: TextInputType.visiblePassword,
                            obscure: true,
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
                                  controller.login(email: _controllerEmail.text, senha: _controllerSenha.text).then((value) async {
                                    if (!value) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertMessage(
                                              title: "Atenção",
                                              message: "Ops ! Falha ao tentar realizar o login.",
                                              onPressedOK: () => Navigator.of(context).pop()));
                                    } else {
                                      if (!controller.user.enable) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertMessage(
                                                title: "Atenção",
                                                message: "Ops ! Acesso ainda não liberado, contate o administrador.",
                                                onPressedOK: () => Navigator.of(context).pop()));
                                      } else {
                                        await controller.saveUserDBLocal();
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage(home: true,)));
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
                          TextButton(
                              onPressed: () async {
                                if (_controllerEmail.text.isEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: "Atenção",
                                          message: "Digite o e-mail para recuperação de senha.",
                                          onPressedOK: () => Navigator.of(context).pop()));
                                } else {
                                  controller.recuperarPassword(email: controller.user.email).then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                            title: "Atenção",
                                            message: value
                                                ? "E-mail de recuperação de senha enviado para sua caixa de entrada."
                                                : "Ops ! Falha ao tentar recuperar senha.",
                                            onPressedOK: () => Navigator.of(context).pop()));
                                  });
                                }
                              },
                              child: Text(
                                "Esqueci minha senha",
                                style: subtitle.copyWith(color: Theme.of(context).primaryColor),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Observer(builder: (_) {
          return IgnorePointer(
            ignoring: !controller.loading,
            child: Container(
              color: controller.loading ? Colors.black54 : Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(controller.loading ? Colors.white : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}
