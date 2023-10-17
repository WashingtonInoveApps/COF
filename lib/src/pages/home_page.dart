import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/checklist/view/checklist_page.dart';
import 'package:bsu_control/src/exchange/view/exchange_register_page.dart';
import 'package:bsu_control/src/pages/login_page.dart';
import 'package:bsu_control/src/pages/manegent_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../widgets/app_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final app = GetIt.I.get<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(
            menu: false,
            back: false,
          ),
          Expanded(
            child: Center(
              child: Wrap(
                children: [
                  InkWell(
                    onTap: app.user.fleet || app.user.admin
                        ? () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ChecklistPage(
                                      home: true,
                                    )));
                          }
                        : null,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MdiIcons.carMultiple,
                              size: 40,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'CHECKLIST',
                              style: subtitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: app.user.material || app.user.admin ? (){} : null,
                  //   child: Card(
                  //     elevation: 2,
                  //     child: Container(
                  //       width: 140.0,
                  //       height: 140.0,
                  //       alignment: Alignment.center,
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 10, vertical: 20.0),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           const Icon(
                  //             MdiIcons.semanticWeb,
                  //             size: 40,
                  //             color: Colors.grey,
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             'MATERIAL',
                  //             style: subtitle.copyWith(color: Colors.grey),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ExchangeRegisterPage()));
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MdiIcons.repeatVariant,
                              size: 40,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'PERMUTAS',
                              style: subtitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (app.user.admin || app.user.adminFleet)
                        ? () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ManagementPage()));
                          }
                        : null,
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              MdiIcons.cogs,
                              size: 40,
                              color: (app.user.admin ||
                                      app.user.adminFleet ||
                                      app.user.adminMaterial)
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'GERENCIAMENTO',
                              style: subtitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => const FilesPage()));
                  //   },
                  //   child: Card(
                  //     elevation: 2,
                  //     child: Container(
                  //       width: 140.0,
                  //       height: 140.0,
                  //       alignment: Alignment.center,
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 10, vertical: 20.0),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           const Icon(
                  //             MdiIcons.fileDocument,
                  //             size: 40,
                  //             color: Colors.green,
                  //           ),
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             'VERIFICAR DOCUMENTOS',
                  //             style: subtitle,
                  //             textAlign: TextAlign.center,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginPage(exit: true)),
                          (route) => false);
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: 140.0,
                        height: 140.0,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              MdiIcons.exitToApp,
                              size: 40,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'SAIR',
                              style: subtitle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
