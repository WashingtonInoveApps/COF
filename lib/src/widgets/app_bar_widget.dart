import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/cars_page.dart';
import 'package:bsu_control/src/checklist/checklist_page.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({Key? key, this.menu = true, this.onBack}) : super(key: key);

  final bool menu;
  final Function()? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) => PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          height: 60.0 + MediaQuery.of(context).padding.top,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 15.0, right: 15.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Controle Operacional de Frota",
                        style: titleHead,
                      ),
                      Text(
                        "Batalhão de Socorro e Urgência",
                        style: subtitleHead,
                      ),
                    ],
                  ),
                ),
                menu
                    ? QudsPopupButton(
                        tooltip: 'T',
                        items: [
                          QudsPopupMenuItem(
                              leading: Icon(MdiIcons.home, size: 25, color: Theme.of(context).primaryColor),
                              title: Text(
                                "INÍCIO",
                                style: title,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                              }),
                          QudsPopupMenuItem(
                              leading: Icon(MdiIcons.checkboxMultipleMarked, size: 25, color: Theme.of(context).primaryColor),
                              title: Text(
                                "CHECKLIST",
                                style: title,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CheckListPage()));
                              }),
                          QudsPopupMenuItem(
                              leading: Icon(MdiIcons.car, size: 25, color: Theme.of(context).primaryColor),
                              title: Text(
                                "VIATURAS",
                                style: title,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CarsPage()));
                              }),
                          QudsPopupMenuDivider(),
                          QudsPopupMenuItem(
                              leading: Icon(
                                MdiIcons.exitToApp,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                "SAIR",
                                style: title,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage(exit: true)));
                              }),
                        ],
                        child: const Icon(Icons.menu, size: 25, color: Colors.white))
                    : Container(),
              ],
            ),
          ),
        ),
      );
}
