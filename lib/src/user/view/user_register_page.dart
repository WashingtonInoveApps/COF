import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/validation.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/user/view/users_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

  final maskRegistration = MaskTextInputFormatter(
      mask: '###.###-#-#', type: MaskAutoCompletionType.lazy);

  final maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    controller = UserController(app: app, init: widget.user);
    user = widget.user ?? controller.userInit;
  }

  @override
  void dispose() {
    super.dispose();
    controller.controllerPassword.dispose();
    controller.controllerPasswordConfirme.dispose();
  }

  void closePage(BuildContext context) {
    controller.app.setRouter(6);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final register = (widget.user == null);
    final enable = (app.user.admin ||
        app.user.battalion ||
        app.user.company ||
        app.user.managerFleet);

    return PopScope(
      canPop: false,
      child: IgnorePointer(
        ignoring: ((widget.user?.admin ?? false) && !app.user.admin),
        child: Stack(
          children: [
            Form(
              key: _key,
              child: BackgraundPage(
                menu: register,
                onBack: register ? null : () => closePage(context),
                top: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      register
                          ? "Registro de usuário"
                          : "Informações do usuário",
                      style: Constants.title.copyWith(fontSize: 18),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                childLeft: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.primary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'INFORMAÇÕES BÁSICAS',
                        style: Constants.titleButton,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "ORGANIZAÇÃO",
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 5.0,
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
                        return IgnorePointer(
                          ignoring: !app.user.admin,
                          child: DropdownButton<OBMModel>(
                              isExpanded: true,
                              value: controller.obm,
                              underline: Container(),
                              onChanged: controller.setOBM,
                              items: app.obms
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                e.prefix,
                                                style: Constants.title,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                e.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Constants.subtitle
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        );
                      }),
                    ),
                    Observer(builder: (context) {
                      return Visibility(
                          visible: (controller.cia != null),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "COMPANHIA",
                                style: Constants.subtitleHint,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Container(
                                height: 50.0,
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: DropdownButton<String?>(
                                    isExpanded: true,
                                    value: controller.cia,
                                    underline: Container(),
                                    onChanged: controller.setCia,
                                    items: controller.obm.cias
                                        .map((e) => DropdownMenuItem(
                                              value: e,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Text(e.toUpperCase(),
                                                    style: Constants.title),
                                              ),
                                            ))
                                        .toList()),
                              ),
                            ],
                          ));
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "GRADUAÇÃO",
                      style: Constants.subtitleHint,
                    ),
                    const SizedBox(
                      height: 5.0,
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
                        return DropdownButton<String?>(
                            isExpanded: true,
                            value: controller.graduation,
                            underline: Container(),
                            onChanged: controller.setGraduation,
                            items: Constants.graduations
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Text(e.toUpperCase(),
                                            style: Constants.title),
                                      ),
                                    ))
                                .toList());
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FieldText(
                      initValue: user.name,
                      hint: "EX.: Fulano",
                      label: 'QRA',
                      validation: Validation.validatorPreenchimento,
                      onSaved: (text) {
                        user.name = text!;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FieldText(
                      initValue: user.fullname,
                      hint: "EX.: Fulano da Silva Lima",
                      label: 'Nome completo',
                      validation: Validation.validatorPreenchimento,
                      onSaved: (text) {
                        user.fullname = text!;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FieldText(
                      initValue: user.registration,
                      hint: "Ex.: 300.000-0-0",
                      label: 'Matrícula',
                      mask: [maskRegistration],
                      validation: Validation.validatorPreenchimento,
                      onSaved: (text) {
                        user.registration = text!;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FieldText(
                      initValue: user.contact,
                      inputType: TextInputType.phone,
                      hint: "EX.: (85) 90000-0000",
                      label: 'Contato',
                      validation: Validation.validatorPhone,
                      mask: [maskFormatter],
                      onSaved: (text) {
                        user.contact = text!;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                childRight: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.primary,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'INFORMAÇÕES DE ACESSO',
                        style: Constants.titleButton,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IgnorePointer(
                      ignoring: (widget.user != null && !enable),
                      child: FieldText(
                        initValue: user.email,
                        inputType: TextInputType.emailAddress,
                        hint: "Ex.: fulano@cb.ce.gov.br",
                        label: "E-mail",
                        validation: Validation.validatorEmail,
                        onSaved: (text) {
                          user.email = text!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Visibility(
                      visible: app.user.admin,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Função Administrador',
                                  style: Constants.title,
                                ),
                              ),
                              Observer(builder: (_) {
                                return Switch(
                                    value: controller.admin,
                                    activeThumbColor: Constants.primary,
                                    onChanged: controller.setAdmin);
                              }),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Gestor operacional',
                                  style: Constants.title,
                                ),
                              ),
                              Observer(builder: (_) {
                                return Switch(
                                    value: controller.managerOperational,
                                    activeThumbColor: Constants.primary,
                                    onChanged:
                                        controller.setManagerOperational);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: enable,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Comandante de batalhão',
                                  style: Constants.title,
                                ),
                              ),
                              Observer(builder: (_) {
                                return Switch(
                                    value: controller.battalion,
                                    activeThumbColor: Constants.primary,
                                    onChanged: controller.setBattalion);
                              }),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Comandante de companhia',
                                  style: Constants.title,
                                ),
                              ),
                              Observer(builder: (_) {
                                return Switch(
                                    value: controller.company,
                                    activeThumbColor: Constants.primary,
                                    onChanged: controller.setCompany);
                              }),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Gestor de frota',
                                  style: Constants.title,
                                ),
                              ),
                              Observer(builder: (_) {
                                return Switch(
                                    value: controller.managerFleet,
                                    activeThumbColor: Constants.primary,
                                    onChanged: controller.setManagerFleet);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                          visible: (widget.user != null && enable),
                          child: SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: 'Atenção',
                                          message:
                                              'Deseja excluir o registro desse usuário ?',
                                          titleOK: 'Sim',
                                          cancel: true,
                                          onPressedCancel: () =>
                                              Navigator.of(context).pop(false),
                                          onPressedOK: () =>
                                              Navigator.of(context)
                                                  .pop(true))).then((value) {
                                    if (value ?? false) {
                                      controller
                                          .delete(user: widget.user!)
                                          .then((value) {
                                        if (value) closePage(context);
                                      }).catchError((err) {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertMessage(
                                                title: 'Atenção',
                                                message:
                                                    'Ops ! Falha ao tentar deletar registro do usuário: ${err.toString()}',
                                                onPressedOK: () =>
                                                    Navigator.of(context)
                                                        .pop()));
                                      });
                                    }
                                  });
                                },
                                child: Text(
                                  "Excluir",
                                  style: Constants.title
                                      .copyWith(color: Colors.white),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();

                                final data = controller.userInit.copyWith(
                                    fullname: user.fullname,
                                    name: user.name,
                                    contact: user.contact,
                                    email: user.email,
                                    registration: user.registration);

                                controller.save(user: data).then((value) async {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertMessage(
                                          title: "Atenção",
                                          message:
                                              "Registro de usuário realizado com sucesso.",
                                          onPressedOK: () =>
                                              Navigator.of(context)
                                                  .pop())).then((_) {
                                    if (value) {
                                      app.setRouter(5);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const UsersPage()));
                                    }
                                  });
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
                              register ? "CADASTRAR" : "ALTERAR",
                              style: Constants.titleButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) {
              return IgnorePointer(
                ignoring: !controller.loading,
                child: Container(
                  color:
                      controller.loading ? Colors.black54 : Colors.transparent,
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
      ),
    );
  }
}
