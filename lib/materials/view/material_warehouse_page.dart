import 'dart:async';
import 'dart:developer';

import 'package:bsu_control/app_controller.dart';
import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/core_enum.dart';
import 'package:bsu_control/main.dart';
import 'package:bsu_control/materials/controller/materials_controller.dart';
import 'package:bsu_control/model/item_model.dart';
import 'package:bsu_control/widgets/alert_message.dart';
import 'package:bsu_control/widgets/limit_table_widget.dart';
import 'package:bsu_control/widgets/pagination_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../widgets/backgraund_page.dart';
import '../../widgets/itens_section_widget.dart';
import '../../widgets/table_widget.dart';
import '../../widgets/textfield_widget.dart';

class MaterialWarehousePage extends StatefulWidget {
  const MaterialWarehousePage({Key? key}) : super(key: key);

  @override
  State createState() => _MaterialWarehousePageState();
}

class _MaterialWarehousePageState extends State<MaterialWarehousePage> {
  final app = GetIt.I.get<AppController>();

  final searchController = TextEditingController();

  late MaterialsController controller;
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

      subscription = controller.listenMaterialsWarehouse().listen((value) {
        controller.setMaterialsWarehouse(value);
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
    return Stack(
      children: [
        BackgraundPage(
          top: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Almoxarifado',
                style: Constants.title.copyWith(fontSize: 18),
              ),
              const Divider(),
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
                      'Registros',
                      style: Constants.title,
                    ),
                    Observer(builder: (_) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: app.modeMOBILE ? double.infinity : 400,
                        alignment: Alignment.centerRight,
                        child: Row(
                          spacing: 10,
                          children: [
                            Expanded(
                              child: IgnorePointer(
                                ignoring:
                                    controller.materialsWarehouseSort.isEmpty,
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
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => Container(
                                            margin: const EdgeInsets.all(20),
                                            alignment: Alignment.center,
                                            child: ItensSectionWidget(
                                              material: true,
                                              ciaID: app.user.ciaID,
                                              obmID: app.user.obmID,
                                              onChange: (value) {
                                                controller
                                                    .saveMaterialWarehouse(
                                                        material: value)
                                                    .catchError((err) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              message: err
                                                                  .toString(),
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                });
                                              },
                                            ),
                                          ));
                                },
                                child: const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Constants.primary,
                                  child: Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ))
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              app.modeMOBILE
                  ? const SizedBox(
                      height: 10,
                    )
                  : const Divider(),
              const SizedBox(
                height: 10,
              ),
              Observer(builder: (_) {
                final materials =
                    List<ItemModel>.from(controller.materialsWarehouseSort);

                return materials.isEmpty
                    ? Text(
                        'Nenhum registro encontrado.',
                        style: Constants.titleHint,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Exibindo ${controller.startItensWarehouse} a ${controller.endItensWarehouse} de ${controller.materialsWarehouse.length} entradas',
                            style: Constants.subtitleHint,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 250),
                            child: AppDataTable<ItemModel>(
                              limit: controller.limit,
                              data: materials,
                              columnMode: ColumnWidthMode.auto,
                              columns: [
                                AppColumn(
                                  name: 'description',
                                  label: 'Descrição',
                                  sortValue: (material) => material.description,
                                  sortable: true,
                                  builder: (material) => Text(
                                    material.description,
                                    style: Constants.title,
                                  ),
                                ),
                                AppColumn(
                                  name: 'unit',
                                  label: 'Unidade',
                                  width: 100,
                                  builder: (material) => Text(
                                    material.unit.label,
                                    style: Constants.title,
                                  ),
                                ),
                                AppColumn(
                                  name: 'quantity',
                                  label: 'Quantidade',
                                  width: 120,
                                  builder: (material) => Text(
                                    material.quantity.toString(),
                                    style: Constants.title,
                                  ),
                                ),
                                AppColumn(
                                  name: 'validity',
                                  label: 'Validade',
                                  width: 200,
                                  builder: (material) => Text(
                                    (material.validity == null)
                                        ? 'Sem validade'
                                        : Core.formatDate(material.validity!,
                                            monthLarge: true),
                                    style: Constants.title.copyWith(
                                        color: (material.validity == null)
                                            ? Colors.grey
                                            : Colors.black),
                                  ),
                                ),
                                AppColumn(
                                  name: 'register',
                                  label: 'Registro',
                                  width: 200,
                                  builder: (material) => Text(
                                    (material.register.isEmpty)
                                        ? ' - '
                                        : material.register,
                                    style: Constants.title,
                                  ),
                                ),
                                AppColumn(
                                  name: 'state',
                                  label: 'Status',
                                  width: 140,
                                  sortValue: (material) =>
                                      material.status.label,
                                  sortable: true,
                                  builder: (material) {
                                    return Center(
                                      child: Container(
                                        width: 150,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: material.status.color,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(
                                          spacing: 5,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(material.status.icon,
                                                color: Colors.white),
                                            Expanded(
                                              child: Text(
                                                material.status.label,
                                                style: Constants.title.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                AppColumn(
                                  width: 120,
                                  name: 'action',
                                  builder: (material) {
                                    return Row(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadiusGeometry
                                                        .circular(100)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(Icons.edit,
                                                  size: 20,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Center(
                                                      child: ItensSectionWidget(
                                                        material: true,
                                                        obmID: app.user.obmID,
                                                        ciaID: app.user.ciaID,
                                                        item: material,
                                                        onChange: (value) {
                                                          log(value.toJson());
                                                          controller
                                                              .updateMaterialWarehouse(
                                                                  material:
                                                                      value)
                                                              .catchError(
                                                                  (err) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) => AlertMessage(
                                                                    message: err
                                                                        .toString(),
                                                                    onPressedOK: () =>
                                                                        Navigator.of(context)
                                                                            .pop()));
                                                          });
                                                        },
                                                      ),
                                                    ));
                                          },
                                        ),
                                        InkWell(
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadiusGeometry
                                                        .circular(100)),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(Icons.delete,
                                                  size: 20,
                                                  color: Colors.green),
                                            ),
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertMessage(
                                                      title: '',
                                                      message:
                                                          'Deseja deletar esse registro de material ?',
                                                      cancel: true,
                                                      onPressedOK: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      onPressedCancel: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                    )).then((value) async {
                                              if (value ?? false) {
                                                controller
                                                    .deleteMaterialWarehouse(
                                                        material: material)
                                                    .catchError((err) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertMessage(
                                                              message: err
                                                                  .toString(),
                                                              onPressedOK: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop()));
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                              rowId: (material) {
                                return material.id;
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
                                    length:
                                        controller.lengthItensWarehouseSortings,
                                    onChange: controller.setPage,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
              }),
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
