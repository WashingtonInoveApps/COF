import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final bool menu;
  final int page;
  final bool back;
  final Function()? onBack;

  const AppBarCustom(
      {Key? key,
      this.menu = true,
      this.onBack,
      this.page = -1,
      this.back = true})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(200.0),
      child: Stack(
        children: [
          ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                height: 110 + MediaQuery.of(context).padding.top,
                color: Colors.orange,
              )),
          ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                height: 100 + MediaQuery.of(context).padding.top,
                color: Theme.of(context).primaryColor,
              )),
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                left: back ? 5.0 : 10,
                right: 10.0),
            child: Row(
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BSU - BATALHÃO DE SOCORRO E URGÊNCIA ",
                        style: titleHead,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Controle Operacional de Serviço",
                        style: subtitleHead,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // menu
                //     ? QudsPopupButton(
                //         tooltip: 'T',
                //         items: [
                //           QudsPopupMenuItem(
                //               leading: const Icon(
                //                 MdiIcons.home,
                //                 size: 20,
                //                 color: Colors.grey,
                //               ),
                //               trailing: const Icon(
                //                 Icons.arrow_forward_ios,
                //                 size: 15,
                //                 color: Colors.grey,
                //               ),
                //               title: Text(
                //                 "INÍCIO",
                //                 style: title.copyWith(color: Colors.black),
                //               ),
                //               onPressed: () {
                //                 Navigator.of(context).pushReplacement(
                //                     MaterialPageRoute(
                //                         builder: (context) =>
                //                             const HomePage()));
                //               }),
                //           QudsPopupMenuItem(
                //               leading: const Icon(
                //                 MdiIcons.clipboardTextOutline,
                //                 size: 20,
                //                 color: Colors.grey,
                //               ),
                //               trailing: const Icon(
                //                 Icons.arrow_forward_ios,
                //                 size: 15,
                //                 color: Colors.grey,
                //               ),
                //               title: Text(
                //                 "REGISTROS",
                //                 style: title.copyWith(
                //                     color:
                //                         page == 1 ? Colors.grey : Colors.black),
                //               ),
                //               onPressed: () {
                //                 if (page != 1) {
                //                   Navigator.of(context).pushReplacement(
                //                       MaterialPageRoute(
                //                           builder: (context) =>
                //                               const ChecklistPage()));
                //                 }
                //               }),
                //           QudsPopupMenuItem(
                //               leading: const Icon(
                //                 MdiIcons.carSearch,
                //                 size: 20,
                //                 color: Colors.grey,
                //               ),
                //               trailing: const Icon(
                //                 Icons.arrow_forward_ios,
                //                 size: 15,
                //                 color: Colors.grey,
                //               ),
                //               title: Text(
                //                 "CHECKLIST",
                //                 style: title.copyWith(
                //                     color:
                //                         page == 2 ? Colors.grey : Colors.black),
                //               ),
                //               onPressed: () {
                //                 if (page != 2) {
                //                   Navigator.of(context).pushReplacement(
                //                       MaterialPageRoute(
                //                           builder: (context) =>
                //                               const ChecklistRegisterPage()));
                //                 }
                //               }),
                //           QudsPopupMenuItem(
                //               leading: const Icon(
                //                 MdiIcons.car,
                //                 size: 20,
                //                 color: Colors.grey,
                //               ),
                //               trailing: const Icon(
                //                 Icons.arrow_forward_ios,
                //                 size: 15,
                //                 color: Colors.grey,
                //               ),
                //               title: Text(
                //                 "VIATURAS",
                //                 style: title.copyWith(
                //                     color:
                //                         page == 3 ? Colors.grey : Colors.black),
                //               ),
                //               onPressed: () {
                //                 if (page != 3) {
                //                   Navigator.of(context).pushReplacement(
                //                       MaterialPageRoute(
                //                           builder: (context) =>
                //                               const CarsPage()));
                //                 }
                //               }),
                //         ],
                //         child: const Icon(Icons.menu,
                //             size: 25, color: Colors.white))
                //     : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
