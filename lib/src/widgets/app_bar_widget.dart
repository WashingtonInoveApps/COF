import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../pages/manegent_page.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final bool menu;
  final int page;
  final bool back;
  final String? titlePage;
  final Function()? onBack;
  final bool admin;

  const AppBarCustom(
      {Key? key,
      this.menu = true,
      this.onBack,
      this.titlePage,
      this.page = -1,
      this.back = true,
      this.admin = false})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(200.0),
      child: Stack(
        children: [
          Container(
            height: 55 + MediaQuery.of(context).padding.top,
            color: Colors.orange,
          ),
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top, left: 15),
            alignment: Alignment.centerLeft,
            height: 50 + MediaQuery.of(context).padding.top,
            color: Theme.of(context).primaryColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: back,
                  child: InkWell(
                      onTap: onBack ?? () => Navigator.of(context).pop(),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      )),
                ),
                Expanded(
                  child: titlePage != null
                      ? Text(
                          titlePage ?? "COF - CONTROLE OPERACIONAL DE FROTA ",
                          style: titleHead,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "COF - CONTROLE OPERACIONAL DE FROTA ",
                              style: titleHead,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "Batalhão de Socorro de Urgência",
                              style: subtitleHead,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                ),
                Visibility(
                  visible: admin,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ManagementPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: Icon(
                          MdiIcons.cogs,
                          size: 30,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
