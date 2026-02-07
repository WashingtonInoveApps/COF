import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/car/view/car_register_page.dart';
import 'package:bsu_control/src/car/view/cars_page.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/login/view/login_page.dart';
import 'package:bsu_control/src/home/home_page.dart';
import 'package:bsu_control/src/user/view/user_register_page.dart';
import 'package:bsu_control/src/user/view/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class BackgraundPage extends StatefulWidget {
  final bool menu;
  final bool login;
  final Widget childLeft;
  final Widget? childRight;
  final Widget? bottom;
  final Widget? contentBottom;
  final Widget? top;
  final Function()? onBack;

  const BackgraundPage({
    Key? key,
    required this.childLeft,
    this.childRight,
    this.menu = true,
    this.login = false,
    this.bottom,
    this.onBack,
    this.top,
    this.contentBottom,
  }) : super(key: key);

  @override
  State<BackgraundPage> createState() => _BackgraundPageState();
}

class _BackgraundPageState extends State<BackgraundPage> {
  final controller = GetIt.I.get<AppController>();

  OBMModel? userOBM;

  @override
  void initState() {
    super.initState();

    if (controller.obms.isNotEmpty) {
      userOBM =
          controller.obms.firstWhere((e) => e.id == controller.user.obmID);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget menu() => Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Controle Operacional de Frota',
              style: Constants.title
                  .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              userOBM?.name ?? '',
              style: Constants.title,
            ),
            const SizedBox(
              height: 2,
            ),
            PopupMenuButton(
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Navigator.of(context)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (conext) => const LoginPage(
                                        exit: true,
                                      )),
                              (_) => false)
                          .then((_) {
                        controller.setRouter(0);
                      });
                      break;
                    default:
                      break;
                  }
                },
                child: Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      controller.user.fullname,
                      style: Constants.titleHint,
                    ),
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 0,
                        child: Text(
                          'Sair',
                          style: Constants.title,
                        ))
                  ];
                }),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: widget.menu,
              child: Observer(builder: (_) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.router != 0) {
                              controller.setRouter(0);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (controller.router == 0)
                                  ? Constants.primary
                                  : Colors.grey.shade300),
                          child: Text(
                            'Inicío',
                            style: Constants.titleButton,
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    PopupMenuButton(
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              if (controller.router != 1) {
                                controller.setRouter(1);
                                // Navigator.of(context).pushReplacement(
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const ChecklistRegisterPage()));
                              }
                              break;
                            case 2:
                              if (controller.router != 2) {
                                controller.setRouter(2);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ChecklistRegisterPage()));
                              }
                              break;
                            default:
                              return;
                          }
                        },
                        child: Container(
                          height: 35,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: (controller.router == 1 ||
                                      controller.router == 2)
                                  ? Constants.primary
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'Checklist',
                            style: Constants.titleButton,
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                value: 1,
                                child: Text(
                                  'Meus registros',
                                  style: Constants.title,
                                )),
                            PopupMenuItem(
                                value: 2,
                                child: Text(
                                  'Novo registro',
                                  style: Constants.title,
                                )),
                          ];
                        }),
                    Visibility(
                      visible: controller.user.admin,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: PopupMenuButton(
                            onSelected: (value) {
                              switch (value) {
                                case 3:
                                  if (controller.router != 3) {
                                    controller.setRouter(3);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CarsPage()));
                                  }
                                  break;
                                case 4:
                                  if (controller.router != 4) {
                                    controller.setRouter(4);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CarRegisterPage()));
                                  }
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: (controller.router == 3 ||
                                          controller.router == 4)
                                      ? Constants.primary
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'Viaturas',
                                style: Constants.titleButton,
                              ),
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    value: 3,
                                    child: Text(
                                      'Registrados',
                                      style: Constants.title,
                                    )),
                                PopupMenuItem(
                                    value: 4,
                                    child: Text(
                                      'Novo registro',
                                      style: Constants.title,
                                    )),
                              ];
                            }),
                      ),
                    ),
                    Visibility(
                      visible: controller.user.admin,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: PopupMenuButton(
                            onSelected: (value) {
                              switch (value) {
                                case 5:
                                  if (controller.router != 5) {
                                    controller.setRouter(5);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UsersPage()));
                                  }
                                  break;
                                case 6:
                                  if (controller.router != 6) {
                                    controller.setRouter(6);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserPageRegister()));
                                  }
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  color: (controller.router == 5 ||
                                          controller.router == 6)
                                      ? Constants.primary
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'Usuários',
                                style: Constants.titleButton,
                              ),
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                    value: 5,
                                    child: Text(
                                      'Registrados',
                                      style: Constants.title,
                                    )),
                                PopupMenuItem(
                                    value: 6,
                                    child: Text(
                                      'Novo registro',
                                      style: Constants.title,
                                    )),
                              ];
                            }),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        );

    return Material(
      color: Constants.primary,
      child: SafeArea(
        top: true,
        child: LayoutBuilder(builder: (context, constrained) {
          final width = controller.processWidth(
              childRight: (widget.childRight == null),
              constrainedMaxWidth: constrained.maxWidth);

          log(width.toString());
          return Center(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: controller.maxWidth),
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(10),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Row(
                            spacing: 10,
                            crossAxisAlignment: controller.modeMOBILE
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: widget.onBack,
                                  child: Image.asset(
                                    'assets/cbmcecabecalho2.png',
                                    fit: BoxFit.fitHeight,
                                    height: 70,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Visibility(
                                visible: !widget.login,
                                child: controller.modeMOBILE
                                    ? widget.menu
                                        ? Align(
                                            alignment: Alignment.centerRight,
                                            child: IconButton(
                                                style: IconButton.styleFrom(
                                                  backgroundColor:
                                                      Constants.primary,
                                                ),
                                                onPressed:
                                                    controller.changeMenuOpen,
                                                icon: const Icon(
                                                  Icons.menu_rounded,
                                                  size: 20,
                                                  color: Colors.white,
                                                )),
                                          )
                                        : Container()
                                    : menu(),
                              )
                            ],
                          ),
                          (controller.modeMOBILE && widget.menu)
                              ? Observer(builder: (context) {
                                  return (controller.menuOpen)
                                      ? Column(
                                          children: [
                                            const Divider(),
                                            menu(),
                                            const Divider(),
                                          ],
                                        )
                                      : Container();
                                })
                              : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          (widget.top == null) ? Container() : widget.top!,
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: widget.childLeft,
                                  ),
                                ),
                                SizedBox(
                                  width: width,
                                  child: widget.childRight,
                                )
                              ],
                            ),
                          ),
                          (widget.contentBottom == null)
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: widget.contentBottom!,
                                ),
                        ],
                      ),
                    ),
                  ),
                  (widget.bottom == null) ? Container() : widget.bottom!
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
