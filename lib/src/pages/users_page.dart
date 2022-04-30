import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final controller = GetIt.I.get<AppController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const AppBarCustom(
          page: 3,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<List<UserModel>>(
                  stream: controller.listenUsers,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final users = snapshot.data ?? [];
                    users.sort((a, b) => a.name.compareTo(b.name));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "USUÁRIOS",
                          style: title.copyWith(color: Colors.grey),
                        ),
                        const Divider(),
                        Column(
                          children: List.generate(
                              users.length,
                              (index) => Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  users[index].name.toUpperCase(),
                                                  style: title.copyWith(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await controller.stateUser(user: users[index]);
                                                },
                                                child: Container(
                                                   padding: const EdgeInsets.all(5.0),
                                                  decoration: BoxDecoration(border: Border.all(color: users[index].enable ? Colors.green : Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(5)),
                                                  child: Text(
                                                    users[index].enable ? 'Liberado' : 'Bloqueado',
                                                    style: subtitle.copyWith(color: users[index].enable ? Colors.green : Theme.of(context).primaryColor),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Matricula ',
                                                style: title.copyWith(color: Colors.grey),
                                              ),
                                              Text(
                                                users[index].matricula.toUpperCase(),
                                                style: title.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                'Contato ',
                                                style: title.copyWith(color: Colors.grey),
                                              ),
                                              Text(
                                                users[index].contato.toUpperCase(),
                                                style: title.copyWith(fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    );
                  }),
            ),
            Observer(builder: (_) {
              return IgnorePointer(
                ignoring: !controller.loading,
                child: Container(
                  color: controller.loading ? Colors.black54 : Colors.transparent,
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(controller.loading ? Colors.white : Colors.transparent),
                  )),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
