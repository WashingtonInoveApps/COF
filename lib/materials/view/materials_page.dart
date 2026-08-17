import 'dart:async';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/materials/controller/materials_controller.dart';
import 'package:bsu_control/model/material_checklist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/core.dart';
import '../../widgets/backgraund_page.dart';
import '../../widgets/limit_table_widget.dart';
import '../../widgets/pagination_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({Key? key}) : super(key: key);

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late MaterialsController controller;
  final app = GetIt.I.get<AppController>();
  final searchController = TextEditingController();

  late ReactionDisposer rec;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();

    controller = MaterialsController(
      config: config,
      obmID: app.user.obmID,
    );

    controller.setLoading(true);
    rec = autorun((_) {
      subscription?.cancel().then((_) {});

      subscription = controller.listenMaterialChecklist().listen((value) {
        controller.setMaterialsChecklist(value);
        controller.setLoading(false);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    rec();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BackgraundPage(
        top: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Checklist de Materiais',
              style: Constants.title.copyWith(fontSize: 18),
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
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
                    'Registrados',
                    style: Constants.title,
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
                        onChange: (text) {},
                        onClear: () {
                          searchController.clear();
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            app.modeMOBILE ? Container() : const Divider(),
            const SizedBox(
              height: 5,
            ),
            Observer(builder: (_) {
              final materials = List<MaterialChecklistModel>.from(
                  controller.materialChecklistSort);
              return materials.isEmpty
                  ? Text(
                      'Nenhum registro encontrado.',
                      style: Constants.titleHint,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exibindo ${controller.startMaterialsChecklist} a ${controller.endMaterialsChecklist} de ${controller.materialsChecklist.length} entradas',
                          style: Constants.subtitleHint,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 250),
                          child: AppDataTable<MaterialChecklistModel>(
                            limit: controller.limit,
                            data: materials,
                            columnMode: ColumnWidthMode.auto,
                            columns: [
                              AppColumn(
                                width: 50,
                                name: 'details',
                                builder: (car) {
                                  return InkWell(
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(
                                                  100)),
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(Icons.search,
                                            size: 20, color: Colors.green),
                                      ),
                                    ),
                                    onTap: () {
                                      // Navigator.of(context).push(MaterialsPageRoute(
                                      //     builder: (context) => CarDetailsPage(
                                      //           carID: car.id ?? '',
                                      //         )));
                                    },
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'obm',
                                label: 'OBM',
                                width: 120,
                                builder: (material) {
                                  return Text(
                                    material.obm.prefix,
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'cia',
                                label: 'Companhia',
                                builder: (material) {
                                  return Text(
                                    material.cia?.name ?? '-',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'team',
                                label: 'Guarnição',
                                builder: (material) {
                                  return Text(
                                    material.team?.name ?? '-',
                                    style: Constants.title,
                                  );
                                },
                              ),
                              AppColumn(
                                name: 'responsable',
                                label: 'Responsável',
                                builder: (material) {
                                  return Core.boldFirstName(
                                      name: material.user.name,
                                      fullName: material.user.fullname,
                                      style: Constants.title);
                                },
                              ),
                              AppColumn(
                                width: 120,
                                name: 'changes',
                                label: 'Alterações',
                                builder: (material) {
                                  return Row(
                                    spacing: 5,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            material.changes?.length
                                                    .toString()
                                                    .padLeft(2, '0') ??
                                                '0',
                                            style: Constants.title,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: InkWell(
                                            onTap:
                                                (material.changes?.isNotEmpty ??
                                                        false)
                                                    ? () async {
                                                        // showDialog(
                                                        //     context: context,
                                                        //     builder: (context) {
                                                        //       return AlertDialog(
                                                        //         contentPadding:
                                                        //             const EdgeInsets
                                                        //                 .all(10),
                                                        //         content:
                                                        //             ImageViewChangeWidget(
                                                        //                 changes: material
                                                        //                     .changes),
                                                        //       );
                                                        //     });
                                                      }
                                                    : null,
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadiusGeometry
                                                          .circular(100)),
                                              child: const Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.list_alt_rounded,
                                                  size: 20,
                                                  color: Constants.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                            rowId: (material) {
                              return material.id ?? 'err';
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            direction: Axis.horizontal,
                            children: [
                              SizedBox(
                                width: 150,
                                child: LimitTableWidget(
                                  limit: controller.limit,
                                  onChange: controller.setLimit,
                                ),
                              ),
                              SizedBox(
                                width: 220,
                                child: PaginationWidget(
                                  limit: controller.limit,
                                  page: controller.page,
                                  length: controller
                                      .lengthMaterialChecklistSortings,
                                  onChange: controller.setPage,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
            }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
