import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/user/view/user_card.dart';
import 'package:bsu_control/src/user/view/user_register_page.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../controller/user_controller.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserController controller;
  final app = GetIt.I.get<AppController>();

  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    controller = UserController(app: app);
    controller.setGraduation(Constants.graduations.first);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgraundPage(
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Usuários",
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
              Observer(
                  builder: (context) => Column(
                        children: List.generate(app.users.length, (index) {
                          final user = app.users[index];
                          final obm =
                              app.obms.firstWhere((e) => e.id == user.obmID);

                          return CardUser(
                            obm: obm,
                            user: user,
                            onEdit: () {
                              app.setRouter(6);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserPageRegister(
                                        user: user,
                                      )));
                            },
                            onDelete: () async {},
                            onEnable: (value) async {
                              await controller.update(
                                  user: user.copyWith(enable: value));
                            },
                          );
                        }),
                      ))
            ],
          ),
        ),
        Observer(builder: (_) {
          return IgnorePointer(
            ignoring: !controller.loading,
            child: Container(
              color: controller.loading ? Colors.black54 : Colors.transparent,
              child: Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    controller.loading ? Colors.white : Colors.transparent),
              )),
            ),
          );
        })
      ],
    );
  }
}
