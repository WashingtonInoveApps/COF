import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/src/car/view/cars_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../user/view/users_page.dart';
import '../widgets/app_bar_widget.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);

  @override
  State<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final app = GetIt.I.get<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(
            menu: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ListTile(
                    onTap: app.user.adminFleet ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CarsPage()));
                    } : null,
                    leading: Icon(MdiIcons.car, size: 40, color: Theme.of(context).primaryColor,),
                    title: Text(
                      'VIATURAS',
                      style: title,
                    ),
                    subtitle: Text('GERENCIAMENTO E INFORMAÇÕES', style: subtitleHint,),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 20, color: Colors.grey,),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: app.user.admin ? () {
                      Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const UsersPage()));
                    } : null,
                    leading: Icon(MdiIcons.account, size: 40, color: Theme.of(context).primaryColor,),
                    title: Text(
                      'USUÁRIOS',
                      style: title,
                    ),
                    subtitle: Text('GERENCIAMENTO DE USUÁRIOS', style: subtitleHint,),
                    trailing: const Icon(Icons.arrow_forward_ios_outlined, size: 20, color: Colors.grey,),
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
