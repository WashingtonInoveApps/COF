import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/user/view/user_card.dart';
import 'package:bsu_control/src/user/view/user_register_page.dart';
import 'package:bsu_control/src/widgets/alert_message.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

import '../controller/user_controller.dart';
import '../repository/user_repository.dart';

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
    controller = UserController(app: app, repository: UserRepository());
    controller.setGraduation(Constants.graduations.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const AppBarCustom(
          //   titlePage: 'USUÁRIOS CADASTRADOS',
          // ),
          Expanded(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "USUÁRIOS",
                              style:
                                  Constants.title.copyWith(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const UserPageRegister()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 2),
                                child: Text(
                                  "NOVO",
                                  style: Constants.subtitle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                      const Divider(),
                      Observer(
                          builder: (context) => Column(
                                children: List.generate(
                                    app.users.length,
                                    (index) => InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserPageRegister(
                                                          user:
                                                              app.users[index],
                                                        )));
                                          },
                                          onLongPress: () async {
                                            final result = await showDialog(
                                                context: context,
                                                builder: (context) => AlertMessage(
                                                    title: 'Atenção',
                                                    message:
                                                        'Deseja excluir esse usuário ?',
                                                    cancel: true,
                                                    onPressedCancel: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    onPressedOK: () =>
                                                        Navigator.of(context)
                                                            .pop(true)));

                                            if (result ?? false) {
                                              await controller.delete(
                                                  user: app.users[index]);
                                            }
                                          },
                                          child: CardUser(
                                            user: app.users[index],
                                            onStatus: () async {
                                              await controller.update(
                                                  user: app.users[index]
                                                      .copyWith(
                                                          enable: !app
                                                              .users[index]
                                                              .enable));
                                            },
                                          ),
                                        )),
                              ))
                    ],
                  ),
                ),
                Observer(builder: (_) {
                  return IgnorePointer(
                    ignoring: !controller.loading,
                    child: Container(
                      color: controller.loading
                          ? Colors.black54
                          : Colors.transparent,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            controller.loading
                                ? Colors.white
                                : Colors.transparent),
                      )),
                    ),
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
