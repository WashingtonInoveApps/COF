import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/user/repository/user_repository.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../controller/user_controller.dart';

class UserPageRegister extends StatefulWidget {
  final UserModel? user;
  const UserPageRegister({Key? key, this.user}) : super(key: key);

  @override
  State createState() => _UserPageRegisterState();
}

class _UserPageRegisterState extends State<UserPageRegister> {
  
  late UserController controller;
  final _key = GlobalKey<FormState>();
  final app = GetIt.I.get<AppController>();

  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    controller = UserController(app: app, repository: UserRepository());

    controller.setGraduacao((widget.user?.graduacao.isNotEmpty ?? false)
        ? widget.user?.graduacao
        : graduacao.first);

    if (widget.user != null) user = UserModel.fromMap(widget.user!.toMap());
  }

  @override
  void dispose() {
    super.dispose();
    controller.controllerPassword.dispose();
    controller.controllerPasswordConfirme.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(
            menu: false,
          ),
          Expanded(
            child: Stack(
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
                            height: 5.0,
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
                                  Card(
                                    margin: EdgeInsets.zero,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Observer(builder: (_) {
                                        return DropdownButton<String>(
                                            value: controller.graduacao,
                                            onChanged: controller.setGraduacao,
                                            underline: Container(),
                                            isExpanded: true,
                                            items: List.generate(
                                                graduacao.length,
                                                (index) =>
                                                    DropdownMenuItem<String>(
                                                      value: graduacao[index],
                                                      child: Text(
                                                        graduacao[index],
                                                        style: subtitle,
                                                      ),
                                                    )));
                                      }),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FieldText(
                                    initValue: user.name,
                                    hint: "QRA",
                                    validation:
                                        Validation.validatorPreenchimento,
                                    onSaved: (text) {
                                      user.name = text!;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  FieldText(
                                    initValue: user.matricula,
                                    inputType: TextInputType.number,
                                    hint: "MATRÍCULA",
                                    validation:
                                        Validation.validatorPreenchimento,
                                    onSaved: (text) {
                                      user.matricula = text!;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  FieldText(
                                    initValue: user.contato,
                                    inputType: TextInputType.phone,
                                    hint: "CONTATO WHATSAP",
                                    validation: Validation.validatorPhone,
                                    mask: [controller.maskFormatter],
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
                                    initValue: user.email,
                                    inputType: TextInputType.emailAddress,
                                    hint: "E-MAIL",
                                    validation: Validation.validatorEmail,
                                    upper: false,
                                    onSaved: (text) {
                                      user.email = text!;
                                    },
                                  ),

                                  // const SizedBox(
                                  //   height: 15.0,
                                  // ),
                                  // FieldText(
                                  //   controller: _controllerPassword,
                                  //   hint: "SENHA",
                                  //   inputType: TextInputType.visiblePassword,
                                  //   obscure: true,
                                  //   validation: Validation.validatorPassoword,
                                  // ),
                                  // const SizedBox(
                                  //   height: 15.0,
                                  // ),
                                  // FieldText(
                                  //   controller: _controllerPasswordConfirme,
                                  //   inputType: TextInputType.visiblePassword,
                                  //   hint: "CONFIRMAR SENHA",
                                  //   obscure: true,
                                  //   validation: (text) => Validation.validatorConfirmePassoword(_controllerPassword.text, _controllerPasswordConfirme.text),
                                  // ),
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
                                    final value = await controller.create(
                                        user: user,
                                        update: widget.user != null);

                                    await showDialog(
                                        context: context,
                                        builder: (context) => AlertMessage(
                                            title: "Atenção",
                                            message: value
                                                ? ((widget.user == null)
                                                    ? "Cadastro foi realizado com sucesso, aguarde liberação."
                                                    : "Cadastro foi alterado com sucesso.")
                                                : "Ops ! Falha ao realizar cadastro.",
                                            onPressedOK: () =>
                                                Navigator.of(context).pop()));

                                    // ignore: use_build_context_synchronously
                                    if (value) Navigator.of(context).pop();
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
                      color: controller.loading
                          ? Colors.black54
                          : Colors.transparent,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            controller.loading
                                ? Colors.white
                                : Colors.transparent),
                      )),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
