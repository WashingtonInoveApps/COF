import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/src/car/view/cars_page.dart';
import 'package:bsu_control/src/checklist/view/checklist_register_page.dart';
import 'package:bsu_control/src/pages/home_page.dart';
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
  final Widget? top;
  final double maxWidth;
  final Function()? onBack;

  const BackgraundPage({
    Key? key,
    required this.childLeft,
    this.childRight,
    this.maxWidth = 1000,
    this.menu = true,
    this.login = false,
    this.bottom,
    this.onBack,
    this.top,
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
            Text(
              controller.user.fullname,
              style: Constants.titleHint,
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: widget.menu,
              child: Observer(builder: (_) {
                return Row(
                  spacing: 10,
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
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.router != 3) {
                              controller.setRouter(3);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const CarsPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (controller.router == 3)
                                  ? Constants.primary
                                  : Colors.grey.shade300),
                          child: Text(
                            'Viaturas',
                            style: Constants.titleButton,
                          )),
                    ),
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          onPressed: () {
                            if (controller.router != 4) {
                              controller.setRouter(4);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const UsersPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: (controller.router == 4)
                                  ? Constants.primary
                                  : Colors.grey.shade300),
                          child: Text(
                            'Usuários',
                            style: Constants.titleButton,
                          )),
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
          bool modeMOBILE = (constrained.maxWidth > widget.maxWidth)
              ? (widget.maxWidth <= 500)
              : (constrained.maxWidth <= 500);

          double width = (modeMOBILE || widget.childRight == null)
              ? ((constrained.maxWidth > widget.maxWidth)
                  ? widget.maxWidth
                  : constrained.maxWidth)
              : widget.maxWidth * 0.48;

          controller.setMaxWidth(width);

          log('ModeMOBILE: $modeMOBILE');
          log('Width: $width');

          return Center(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: widget.maxWidth),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Expanded(
                                child: Visibility(
                                  visible: !widget.login,
                                  child: modeMOBILE
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
                                ),
                              )
                            ],
                          ),
                          (modeMOBILE && widget.menu)
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
                          // Container(
                          //   color: Colors.red,
                          //   width: 400,
                          //   height: 400,
                          // ),
                          // Container(
                          //   color: Colors.yellow,
                          //   width: 400,
                          //   height: 400,
                          // ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
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
