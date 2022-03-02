import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _key = GlobalKey<FormState>();
  final controller = GetIt.I.get<AppController>();

  final _controllerPassword = TextEditingController();
  final _controllerPasswordConfirme = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var maskMatricula = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  UserModel user = UserModel();

  @override
  void dispose() {
    super.dispose();
    _controllerPassword.dispose();
    _controllerPasswordConfirme.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(
        menu: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _key,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "INFORMAÇÕES DO USUÁRIO",
                      style: titleHint,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: 400.0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FieldText(
                              hint: "QRA",
                              validation: Validation.validatorPreenchimento,
                              onSaved: (text) {
                                user.name = text!;
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            FieldText(
                              inputType: TextInputType.number,
                              hint: "MATRÍCULA",
                              validation: Validation.validatorNumber,
                              onSaved: (text) {
                                user.matricula = text!;
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            FieldText(
                              inputType: TextInputType.phone,
                              hint: "CONTATO WHATSAP",
                              validation: Validation.validatorPhone,
                              mask: [maskFormatter],
                              onSaved: (text) {
                                user.contato = text!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "INFORMAÇÕES DE ACESSO",
                      style: titleHint,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: SizedBox(
                        width: 400.0,
                        child: Column(
                          children: [
                            FieldText(
                              inputType: TextInputType.emailAddress,
                              hint: "E-MAIL",
                              validation: Validation.validatorEmail,
                              upper: false,
                              onSaved: (text) {
                                user.email = text!;
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            FieldText(
                              controller: _controllerPassword,
                              hint: "SENHA",
                              inputType: TextInputType.visiblePassword,
                              obscure: true,
                              validation: Validation.validatorPassoword,
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            FieldText(
                              controller: _controllerPasswordConfirme,
                              inputType: TextInputType.visiblePassword,
                              hint: "CONFIRMAR SENHA",
                              obscure: true,
                              validation: (text) => Validation.validatorConfirmePassoword(_controllerPassword.text, _controllerPasswordConfirme.text),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Center(
                      child: SizedBox(
                        height: 50.0,
                        width: 400.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              
                              _key.currentState!.save();
                              controller.createUser(user: user, password: _controllerPassword.text).then((value) async {
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertMessage(
                                        title: "Atenção",
                                        message: value
                                            ? "Seu cadastro foi realizado com sucesso, aguarde liberação."
                                            : "Ops ! Falha ao realizar cadastro.",
                                        onPressedOK: () => Navigator.of(context).pop()));

                                if (value) Navigator.of(context).pop();
                              });
                            }
                          },
                          child: Text(
                            "CADASTRAR",
                            style: titleButton,
                          ),
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
                  valueColor: AlwaysStoppedAnimation<Color>(controller.loading ? Colors.white : Colors.transparent),
                )),
              ),
            );
          })
        ],
      ),
    );
  }
}
