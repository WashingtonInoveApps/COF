import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/cars_page.dart';
import 'package:bsu_control/src/checklist/checklist_page.dart';
import 'package:bsu_control/src/pages/home_page.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:bsu_control/src/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:quds_popup_menu/quds_popup_menu.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({Key? key, this.menu = true, this.onBack, this.page = -1}) : super(key: key);

  final bool menu;
  final int page;
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COF ",
                        style: titleHead,
                      ),
                      Text(
                        "- Controle Operacional de Frota",
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
                              title: Text(
                                "INÍCIO",
                                style: title,
                              ),
                              onPressed: () {
                                if (page != 0) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
                              }),
                          QudsPopupMenuItem(
                              title: Text(
                                "CHECKLIST",
                                style: title,
                              ),
                              onPressed: () {
                                if (page != 1) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CheckListPage()));
                              }),
                          QudsPopupMenuItem(
                              title: Text(
                                "VIATURAS",
                                style: title,
                              ),
                              onPressed: () {
                                if (page != 2) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CarsPage()));
                              }),
                          QudsPopupMenuItem(
                              title: Text(
                                "USUÁRIOS",
                                style: title,
                              ),
                              onPressed: () {
                                if (page != 3) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const UsersPage()));
                              }),
                          QudsPopupMenuDivider(),
                          QudsPopupMenuItem(
                              title: Text(
                                "SAIR",
                                style: title,
                              ),
                              onPressed: () {
                                if (page != 3) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage(exit: true)));
                                }
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
