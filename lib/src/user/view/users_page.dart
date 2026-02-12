import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/src/user/view/user_register_page.dart';
import 'package:bsu_control/src/widgets/backgraund_page.dart';
import 'package:bsu_control/src/widgets/limit_table_widget.dart';
import 'package:bsu_control/src/widgets/pagination_widget.dart';
import 'package:bsu_control/src/widgets/textfield_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controller/user_controller.dart';
import 'widgets/users_table_view.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserController controller;

  final searchController = TextEditingController();
  final app = GetIt.I.get<AppController>();

  @override
  void initState() {
    super.initState();
    controller = UserController(app: app, init: null);
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgraundPage(
          childLeft: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      'Usuários',
                      style: Constants.title.copyWith(fontSize: 18),
                    ),
                    Observer(builder: (_) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: app.modeMOBILE ? double.infinity : 350,
                        alignment: Alignment.centerRight,
                        child: FieldText(
                          search: true,
                          controller: searchController,
                          hint: 'Ex.: Digite algo para pesquisar',
                          onChange: controller.onChangeFilter,
                          onClear: () {
                            searchController.clear();
                            controller.onChangeFilter('');
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              app.modeMOBILE ? Container() : const Divider(),
              const SizedBox(
                height: 10,
              ),
              Observer(builder: (_) {
                return Text(
                  'Exibindo 1 a ${controller.usersSorts.length} de ${controller.usersOBM.length} entradas',
                  style: Constants.subtitleHint,
                );
              }),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.60,
                child: Observer(builder: (context) {
                  final users = List<UserModel>.from(controller.usersSorts);
                  final obms = List<OBMModel>.from(app.obms);
                  return UsersTableView(
                    values: users,
                    obms: obms,
                    onContact: (contact) async {
                      final path = kIsWeb
                          ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                          : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                      await launchUrlString(path,
                          mode: LaunchMode.externalApplication);
                    },
                    onDetails: (user) {
                      app.setRouter(6);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserPageRegister(
                                user: user,
                              )));
                    },
                    onEnable: (user) async {
                      await controller.update(user: user);
                    },
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Observer(builder: (_) {
                    return LimitTableWidget(
                        limit: controller.limit, onChange: controller.setLimit);
                  }),
                  const Spacer(),
                  Observer(builder: (context) {
                    return PaginationWidget(
                      limit: controller.limit,
                      page: controller.page,
                      length: controller.usersSorts.length,
                      onChange: controller.setPage,
                    );
                  }),
                ],
              )
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
