import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/view/car_register_page.dart';
import 'package:bsu_control/car/view/cars_page.dart';
import 'package:bsu_control/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/checklist/view/checklist_page.dart';
import 'package:bsu_control/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/checklist/view/my_checklist_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/home/home_page.dart';
import 'package:bsu_control/login/view/login_page.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/user/view/user_register_page.dart';
import 'package:bsu_control/user/view/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../services/view/service_register_page.dart';

class BackgraundPage extends StatefulWidget {
  final bool menu;
  final bool login;
  final Widget childLeft;
  final Widget? childRight;
  final Widget? bottom;
  final Widget? contentBottom;
  final Widget? top;
  final WrapAlignment? wrapAlign;
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
    this.wrapAlign = WrapAlignment.spaceAround,
  }) : super(key: key);

  @override
  State<BackgraundPage> createState() => _BackgraundPageState();
}

class _BackgraundPageState extends State<BackgraundPage> {
  final controller = GetIt.I.get<AppController>();

  OBMModel? obmUser;

  @override
  void initState() {
    super.initState();

    if (controller.obms.isNotEmpty) {
      obmUser =
          controller.obms.firstWhere((e) => e.id == controller.user.obmID);
    }
  }

  ButtonStyle style({required int router, required List<int> selects}) {
    return ElevatedButton.styleFrom(
        backgroundColor: (selects.contains(router))
            ? Constants.primary
            : Colors.grey.shade300);
  }

  @override
  Widget build(BuildContext context) {
    Widget menu({required BuildContext context, required UserModel user}) {
      final usersEnable =
          (user.admin || user.managerFleet || user.battalion || user.company);

      final vtrsEnable = (user.admin ||
          user.managerFleet ||
          user.battalion ||
          user.company ||
          user.managerOperational);

      // final expires = Core.verifyExpiresChecklist();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Controle Operacional de Frota',
            style: Constants.title
                .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            obmUser?.name ?? '',
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
                      controller.setDateStartConfig(
                          DateTime.now().subtract(const Duration(days: 1)));
                      controller.setDateFinishConfig(DateTime.now());
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
              return Wrap(
                spacing: 5,
                runSpacing: 5,
                direction: Axis.horizontal,
                children: [
                  ElevatedButton(
                    style: style(router: controller.router, selects: [0]),
                    onPressed: () {
                      if (controller.router != 0) {
                        controller.setRouter(0);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage()));
                      }
                    },
                    child: Text(
                      'Inicío',
                      style: Constants.titleButton,
                    ),
                  ),
                  // MenuAnchor(
                  //     builder: (context, controller, child) {
                  //       return ElevatedButton(
                  //         style:
                  //             style(router: this.controller.router, select: 2),
                  //         onPressed: () {
                  //           controller.isOpen
                  //               ? controller.close()
                  //               : controller.open();
                  //         },
                  //         child: Text(
                  //           'Serviços',
                  //           style: Constants.titleButton,
                  //         ),
                  //       );
                  //     },
                  //     menuChildren: [
                  //       MenuItemButton(
                  //         child: Text(
                  //           'Registros',
                  //           style: Constants.title,
                  //         ),
                  //         onPressed: () {},
                  //       ),
                  //       MenuItemButton(
                  //         child: Text(
                  //           'Meu registros',
                  //           style: Constants.title,
                  //         ),
                  //         onPressed: () {},
                  //       ),
                  //       MenuItemButton(
                  //         child: Text(
                  //           'Novo registro',
                  //           style: Constants.title,
                  //         ),
                  //         onPressed: () {},
                  //       ),
                  //     ]),
                  MenuAnchor(
                      builder: (context, controller, child) {
                        return ElevatedButton(
                          style: style(
                            router: this.controller.router,
                            selects: [1, 2, 3, 4],
                          ),
                          onPressed: () {
                            controller.isOpen
                                ? controller.close()
                                : controller.open();
                          },
                          child: Text(
                            'Checklist',
                            style: Constants.titleButton,
                          ),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          child: Text(
                            'Registros',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 1) {
                              controller.setRouter(1);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChecklistPage()));
                            }
                          },
                        ),
                        MenuItemButton(
                          child: Text(
                            'Meu registros',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 2) {
                              controller.setRouter(2);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyChecklistPage()));
                            }
                          },
                        ),
                        SubmenuButton(
                            menuChildren: [
                              MenuItemButton(
                                child: Text(
                                  'Veículo',
                                  style: Constants.title,
                                ),
                                onPressed: () {
                                  if (controller.router != 3) {
                                    if (controller.newRegister) {
                                      // if (expires) {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (context) => AlertMessage(
                                      //           title: 'Atenção',
                                      //           message:
                                      //               'Ops ! Horário para realizar um novo registro expirado, espere um novo período.',
                                      //           onPressedOK: () =>
                                      //               Navigator.of(context).pop()));
                                      // } else {
                                      controller.setRouter(3);
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ChecklistRegisterPage()));
                                      // }
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChecklistDetailsPage(
                                                      checklist: controller
                                                          .checklistUser!)));
                                    }
                                  }
                                },
                              ),
                              MenuItemButton(
                                child: Text(
                                  'Material',
                                  style: Constants.title,
                                ),
                                onPressed: () {},
                              )
                            ],
                            child: Text(
                              'Novo registro',
                              style: Constants.title,
                            ))
                      ]),
                  Visibility(
                    visible: vtrsEnable,
                    child: MenuAnchor(
                        builder: (context, controller, child) {
                          return ElevatedButton(
                            style: style(
                              router: this.controller.router,
                              selects: [5, 6],
                            ),
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                            child: Text(
                              'Veículos',
                              style: Constants.titleButton,
                            ),
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            child: Text(
                              'Registros',
                              style: Constants.title,
                            ),
                            onPressed: () {
                              if (controller.router != 5) {
                                controller.setRouter(5);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CarsPage()));
                              }
                            },
                          ),
                          MenuItemButton(
                            child: Text(
                              'Novo registro',
                              style: Constants.title,
                            ),
                            onPressed: () {
                              if (controller.router != 6) {
                                controller.setRouter(6);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CarRegisterPage()));
                              }
                            },
                          ),
                        ]),
                  ),
                  Visibility(
                    visible: usersEnable,
                    child: MenuAnchor(
                        builder: (context, controller, child) {
                          return ElevatedButton(
                            style: style(
                              router: this.controller.router,
                              selects: [7, 8],
                            ),
                            onPressed: () {
                              controller.isOpen
                                  ? controller.close()
                                  : controller.open();
                            },
                            child: Text(
                              'Usuários',
                              style: Constants.titleButton,
                            ),
                          );
                        },
                        menuChildren: [
                          MenuItemButton(
                            child: Text(
                              'Registros',
                              style: Constants.title,
                            ),
                            onPressed: () {
                              if (controller.router != 7) {
                                controller.setRouter(7);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UsersPage()));
                              }
                            },
                          ),
                          MenuItemButton(
                            child: Text(
                              'Novo registro',
                              style: Constants.title,
                            ),
                            onPressed: () {
                              if (controller.router != 8) {
                                controller.setRouter(8);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const UserPageRegister()));
                              }
                            },
                          ),
                        ]),
                  ),
                ],
              );
            }),
          ),
        ],
      );
    }

    return Material(
      color: Constants.primary,
      child: SafeArea(
        top: true,
        child: LayoutBuilder(builder: (context, constrained) {
          final width = controller.processWidth(
              childRight: (widget.childRight == null),
              constrainedMaxWidth: constrained.maxWidth);

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
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxHeight: 80, maxWidth: 250),
                                    child: AspectRatio(
                                      aspectRatio:
                                          (controller.modeMOBILE ? 3 : 4),
                                      child: Image.asset(
                                        'assets/cbmce.png',
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Visibility(
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
                                      : menu(
                                          context: context,
                                          user: controller.user),
                                ),
                              )
                            ],
                          ),
                          (controller.modeMOBILE && widget.menu)
                              ? Observer(builder: (context) {
                                  return (controller.menuOpen)
                                      ? Column(
                                          children: [
                                            const Divider(),
                                            menu(
                                                context: context,
                                                user: controller.user),
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
                              alignment: widget.wrapAlign!,
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
