import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/car/view/car_register_page.dart';
import 'package:bsu_control/car/view/cars_page.dart';
import 'package:bsu_control/checklist/view/checklist_details_page.dart';
import 'package:bsu_control/checklist/view/checklist_page.dart';
import 'package:bsu_control/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/checklist/view/my_checklist_page.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/home/home_page.dart';
import 'package:bsu_control/login/view/login_page.dart';
import 'package:bsu_control/materials/view/material_warehouse_page.dart';
import 'package:bsu_control/materials/view/materials_page.dart';
import 'package:bsu_control/model/notification_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/user/view/user_register_page.dart';
import 'package:bsu_control/user/view/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class BackgraundPage extends StatefulWidget {
  final bool menu;
  final bool login;
  final Widget childLeft;
  final Widget? childRight;
  // final Widget? bottom;
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
    // this.bottom,
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

      final materialEnable = (user.admin ||
          user.battalion ||
          user.company ||
          user.managerOperational);

      // final expires = Core.verifyExpiresChecklist();
      return Visibility(
        visible: widget.menu,
        child: Observer(builder: (_) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            direction: Axis.horizontal,
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                height: 40,
                width: 140,
                child: ElevatedButton(
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
              ),
              SizedBox(
                height: 40,
                width: 140,
                child: MenuAnchor(
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
                                'Veicular',
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
                                                const ChecklistRegisterPage(
                                                  type: ChecklistType.vehicular,
                                                )));
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
                              onPressed: () {
                                if (controller.router != 4) {
                                  controller.setRouter(4);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ChecklistRegisterPage(
                                                type: ChecklistType.materials,
                                              )));
                                }
                              },
                            )
                          ],
                          child: Text(
                            'Novo registro',
                            style: Constants.title,
                          ))
                    ]),
              ),
              Visibility(
                visible: vtrsEnable,
                child: SizedBox(
                  height: 40,
                  width: 140,
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
                            'Registrados',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 5) {
                              controller.setRouter(5);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const CarsPage()));
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
              ),
              Visibility(
                visible: materialEnable,
                child: SizedBox(
                  height: 40,
                  width: 140,
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
                            'Materiais',
                            style: Constants.titleButton,
                          ),
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          child: Text(
                            'Checklist',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 7) {
                              controller.setRouter(7);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MaterialsPage()));
                            }
                          },
                        ),
                        MenuItemButton(
                          child: Text(
                            'Almoxarifado',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 8) {
                              controller.setRouter(8);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MaterialWarehousePage()));
                            }
                          },
                        ),
                      ]),
                ),
              ),
              Visibility(
                visible: usersEnable,
                child: SizedBox(
                  height: 40,
                  width: 140,
                  child: MenuAnchor(
                      builder: (context, controller, child) {
                        return ElevatedButton(
                          style: style(
                            router: this.controller.router,
                            selects: [9, 10],
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
                            if (controller.router != 9) {
                              controller.setRouter(9);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const UsersPage()));
                            }
                          },
                        ),
                        MenuItemButton(
                          child: Text(
                            'Novo registro',
                            style: Constants.title,
                          ),
                          onPressed: () {
                            if (controller.router != 10) {
                              controller.setRouter(10);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserPageRegister()));
                            }
                          },
                        ),
                      ]),
                ),
              ),
            ],
          );
        }),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (controller.modeMOBILE && widget.menu)
                            IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Constants.primary,
                                ),
                                onPressed: controller.changeMenuOpen,
                                icon: const Icon(
                                  Icons.menu_rounded,
                                  size: 20,
                                  color: Colors.white,
                                )),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                    maxWidth:
                                        controller.modeMOBILE ? 200 : 250),
                                margin: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: widget.onBack,
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
                          ),
                          PopupMenuButton(
                            menuPadding: const EdgeInsetsGeometry.all(10),
                            itemBuilder: (context) {
                              final notifications = controller.notifications;

                              return [
                                ...notifications.asMap().entries.expand(
                                  (entry) {
                                    final index = entry.key;
                                    final notification = entry.value;

                                    return <PopupMenuEntry>[
                                      PopupMenuItem(
                                        enabled: false,
                                        padding: EdgeInsets.zero,
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            Icon(
                                              notification.icon,
                                              color: Colors.orange,
                                            ),
                                            Expanded(
                                              child: Text(
                                                notification.description,
                                                style: Constants.title,
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (index < notifications.length - 1)
                                        const PopupMenuDivider(
                                          thickness: 1,
                                        ),
                                    ];
                                  },
                                ),
                              ];
                            },
                            child: notificationBT(
                              list: controller.notifications,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Controle Operacional de Frota',
                              style: Constants.title.copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                                  builder: (conext) =>
                                                      const LoginPage(
                                                        exit: true,
                                                      )),
                                              (_) => false)
                                          .then((_) {
                                        controller.setRouter(0);
                                        // controller.setDateStartConfig(
                                        //     DateTime.now().subtract(const Duration(days: 1)));
                                        // controller.setDateFinishConfig(DateTime.now());
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
                                      style: Constants.subtitleHint,
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
                          ],
                        ),
                      ),
                    ),
                    if (widget.menu)
                      SizedBox(
                        width: double.infinity,
                        child: (controller.modeMOBILE)
                            ? Observer(builder: (context) {
                                return (controller.menuOpen)
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
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
                            : menu(context: context, user: controller.user),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child:
                            (widget.top == null) ? Container() : widget.top!),
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
          );
        }),
      ),
    );
  }
}

Widget notificationBT({required List<NotificationModel> list}) {
  return Stack(
    children: [
      const CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
      ),
      Center(
        child: CircleAvatar(
          radius: 18,
          backgroundColor:
              list.isNotEmpty ? Constants.primary.withAlpha(50) : Colors.grey,
          child: const Icon(
            Icons.notifications_active,
            size: 20,
            color: Constants.primary,
          ),
        ),
      ),
      Positioned(
          right: 5,
          bottom: 5,
          child: CircleAvatar(
            radius: 10,
            backgroundColor:
                list.isNotEmpty ? Constants.primary : Colors.grey.shade300,
            child: Text(
              list.length.toString(),
              style: Constants.subtitle.copyWith(color: Colors.white),
            ),
          ))
    ],
  );
}
