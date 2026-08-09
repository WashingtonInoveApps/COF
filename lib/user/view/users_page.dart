import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:bsu_control/user/view/user_register_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/backgraund_page.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';
import '../controller/user_controller.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UserController controller;
  late ReactionDisposer reac;

  final searchController = TextEditingController();
  final app = GetIt.I.get<AppController>();
  final tableController = AppDataTableController<UserModel>();

  @override
  void initState() {
    super.initState();

    controller = UserController(
      config: config,
      init: null,
      obms: app.obms,
      user: app.user,
    );

    reac = autorun((_) {
      controller.setUsers(controller.setUsers(List<UserModel>.from(app.users)));
    });
  }

  @override
  void dispose() {
    reac();
    searchController.dispose();
    super.dispose();
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
                  'Exibindo ${controller.start} a ${controller.end} de ${controller.usersOBM.length} entradas',
                  style: Constants.subtitleHint,
                );
              }),
              const SizedBox(
                height: 5,
              ),
              Observer(builder: (context) {
                final obms = List<OBMModel>.from(app.obms);
                final users = List<UserModel>.from(controller.usersSorts);
                return Container(
                  width: double.infinity,
                  height: Core.calculateTableHeight(users.length),
                  constraints: const BoxConstraints(minHeight: 250),
                  child: AppDataTable<UserModel>(
                    data: users,
                    columnMode: ColumnWidthMode.auto,
                    columns: [
                      AppColumn(
                        width: 60,
                        name: 'enable',
                        visible: app.user.admin,
                        hasLoading: true,
                        builder: (user) {
                          return Switch(
                              activeThumbColor: Constants.primary,
                              value: user.enable,
                              onChanged: (value) async {
                                tableController.setRowLoading(user, true);
                                await controller
                                    .update(user: user.copyWith(enable: value))
                                    .catchError((_) {});
                                tableController.setRowLoading(user, false);
                              });
                        },
                      ),
                      AppColumn(
                        width: 50,
                        name: 'details',
                        builder: (user) {
                          return InkWell(
                            child: Card(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusGeometry.circular(100)),
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.search,
                                    size: 20, color: Colors.green),
                              ),
                            ),
                            onTap: () {
                              app.setRouter(6);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserPageRegister(
                                        user: user,
                                      )));
                            },
                          );
                        },
                      ),
                      AppColumn(
                        width: 120,
                        name: 'graduation',
                        label: 'Graduação',
                        sortValue: (user) => user.graduation,
                        builder: (user) => Text(
                          user.graduation,
                          style: Constants.subtitle,
                        ),
                      ),
                      AppColumn(
                        width: 300,
                        name: 'name',
                        label: 'Nome',
                        sortable: true,
                        alignment: Alignment.centerLeft,
                        sortValue: (user) => user.name,
                        builder: (user) => Core.boldFirstName(
                            name: user.name,
                            fullName: user.fullname,
                            style: Constants.subtitle),
                      ),
                      AppColumn(
                        name: 'registration',
                        label: 'Matrícula',
                        sortValue: (user) => user.registration,
                        builder: (user) => Text(
                          user.registration,
                          style: Constants.subtitle,
                        ),
                      ),
                      AppColumn(
                        width: 80,
                        name: 'obm',
                        label: 'OBM',
                        sortValue: (user) {
                          final obm =
                              obms.firstWhere((e) => e.id == user.obmID);

                          return obm.name;
                        },
                        builder: (user) {
                          final obm =
                              obms.firstWhere((e) => e.id == user.obmID);

                          return Text(
                            obm.prefix.toUpperCase(),
                            style: Constants.subtitle,
                          );
                        },
                      ),
                      AppColumn(
                        name: 'cia',
                        label: 'Companhia',
                        sortValue: (user) => user.cia,
                        builder: (user) {
                          return Text(
                            user.cia.toUpperCase(),
                            style: Constants.subtitle,
                          );
                        },
                      ),
                      AppColumn(
                        width: 300,
                        alignment: Alignment.centerLeft,
                        name: 'email',
                        label: 'E-mail',
                        sortValue: (user) => user.email,
                        builder: (user) {
                          return Text(
                            user.email,
                            style: Constants.subtitle,
                          );
                        },
                      ),
                      AppColumn(
                        name: 'contact',
                        label: 'Contato',
                        sortValue: (user) => user.contact,
                        builder: (user) {
                          return InkWell(
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  spacing: 5,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(MdiIcons.whatsapp,
                                        color: Colors.green),
                                    Expanded(
                                      child: Text(
                                        user.contact,
                                        style: Constants.subtitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () async {
                              final contact = user.contact
                                  .replaceAll(' ', '')
                                  .replaceAll('(', '')
                                  .replaceAll(')', '')
                                  .replaceAll('-', '');

                              final path = kIsWeb
                                  ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                                  : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                              await launchUrlString(path,
                                  mode: LaunchMode.externalApplication);
                            },
                          );
                        },
                      ),
                    ],
                    rowId: (user) {
                      return user.id ?? 'err';
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: 150,
                    child: Observer(builder: (_) {
                      return LimitTableWidget(
                        limit: controller.limit,
                        onChange: controller.setLimit,
                      );
                    }),
                  ),
                  SizedBox(
                    width: 220,
                    child: Observer(builder: (context) {
                      return PaginationWidget(
                        limit: controller.limit,
                        page: controller.page,
                        length: controller.lengthSortings,
                        onChange: controller.setPage,
                      );
                    }),
                  ),
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


// return UsersTableView(
                  //   values: users,
                  //   obms: obms,
                  //   onContact: (contact) async {
                  //     final path = kIsWeb
                  //         ? "https://wa.me/+55$contact/?text=${Uri.encodeFull('Olá, tudo bem ?')}"
                  //         : "whatsapp://send?phone=+55$contact&text=${Uri.encodeFull('Olá, tudo bem ?')}";

                  //     await launchUrlString(path,
                  //         mode: LaunchMode.externalApplication);
                  //   },
                  //   onDetails: (user) {
                  //     app.setRouter(6);
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => UserPageRegister(
                  //               user: user,
                  //             )));
                  //   },
                  //   onEnable: (user) async {
                  //     await controller.update(user: user);
                  //   },
                  // );