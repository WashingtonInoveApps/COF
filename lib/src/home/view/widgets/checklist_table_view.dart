import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ChecklistTableView extends StatefulWidget {
  final List<CheckListModel> values;
  final List<OBMModel> obms;
  final Function(String)? onContact;
  final Function(String)? onDetails;
  const ChecklistTableView(
      {Key? key,
      required this.values,
      required this.obms,
      this.onContact,
      this.onDetails})
      : super(key: key);

  @override
  State<ChecklistTableView> createState() => _ChecklistTableViewState();
}

class _ChecklistTableViewState extends State<ChecklistTableView> {
  @override
  Widget build(BuildContext context) {
    final dataSource = ChecklistDataSource(
        checklists: widget.values,
        obms: widget.obms,
        onContact: widget.onContact,
        onDetails: widget.onDetails);

    header({required String label}) {
      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade700),
        child: Text(
          label,
          style: Constants.subtitle.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return SfDataGrid(
      headerRowHeight: 50,
      source: dataSource,
      isScrollbarAlwaysShown: true,
      columnWidthMode: ColumnWidthMode.auto,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      columns: [
        GridColumn(
          width: 50,
          columnName: 'details',
          label: Container(),
        ),
        GridColumn(
          width: 100,
          columnName: 'data',
          label: header(label: 'DATA'),
        ),
        GridColumn(
          columnName: 'obm',
          label: header(label: 'OBM'),
        ),
        GridColumn(
          columnName: 'cia',
          label: header(label: 'COMPANHIA'),
        ),
        GridColumn(
          width: 100,
          columnName: 'team',
          label: header(label: 'GUARNIÇÃO'),
        ),
        GridColumn(
          columnName: 'viatura',
          label: header(label: 'VIATURA'),
        ),
        GridColumn(
          columnName: 'responsable',
          label: header(label: 'RESPONSÁVEL'),
        ),
        GridColumn(
          width: 180,
          columnName: 'contact',
          label: header(label: 'CONTATO'),
        ),
        GridColumn(
          columnName: 'kmStart',
          label: header(label: 'KM INICIAL'),
        ),
        GridColumn(
          columnName: 'kmFinish',
          label: header(label: 'KM FINAL'),
        ),
        GridColumn(
          width: 150,
          columnName: 'changes',
          label: header(label: 'ALTERAÇÕES'),
        ),
      ],
    );
  }
}

class ChecklistDataSource extends DataGridSource {
  final Function(String contact)? onContact;
  final Function(String id)? onDetails;

  ChecklistDataSource({
    required List<CheckListModel> checklists,
    required List<OBMModel> obms,
    this.onContact,
    this.onDetails,
  }) {
    _rows = checklists.map<DataGridRow>((check) {
      final obm = obms.firstWhere((e) => e.id == check.obmID);
      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'details',
          value: check.id,
        ),
        DataGridCell<String>(
          columnName: 'data',
          value: Core.formatDate(check.date),
        ),
        DataGridCell<String>(
            columnName: 'obm', value: obm.prefix.toUpperCase()),
        DataGridCell<String>(columnName: 'cia', value: check.cia.toUpperCase()),
        DataGridCell<String>(
            columnName: 'team', value: check.team.toUpperCase()),
        DataGridCell<String>(
            columnName: 'viatura', value: check.prefix.toUpperCase()),
        DataGridCell<String>(
            columnName: 'responsable',
            value:
                ('${check.user.graduation} ${check.user.name}').toUpperCase()),
        DataGridCell<String>(
          columnName: 'contact',
          value: check.contact,
        ),
        DataGridCell<String>(columnName: 'kmStart', value: check.startKM),
        DataGridCell<String>(
            columnName: 'kmFinish',
            value: check.endKM.isEmpty ? ' - ' : check.endKM),
        DataGridCell<String>(
            columnName: 'changes',
            value: check.changes.length.toString().padLeft(2, '0')),
      ]);
    }).toList();
  }

  late List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        /// 🔹 COLUNA DE AÇÃO
        if (cell.columnName == 'contact') {
          return Center(
            child: InkWell(
              child: Card(
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    spacing: 5,
                    children: [
                      Icon(MdiIcons.whatsapp, color: Colors.green),
                      Text(
                        cell.value,
                        style: Constants.title,
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                final value = cell.value;
                final contact = value
                    .replaceAll(' ', '')
                    .replaceAll('(', '')
                    .replaceAll(')', '')
                    .replaceAll('-', '');

                onContact?.call(contact);
              },
            ),
          );
        } else if (cell.columnName == 'details') {
          return Center(
            child: InkWell(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100)),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.search, size: 20, color: Colors.green),
                ),
              ),
              onTap: () async {
                final value = cell.value;
                onDetails?.call(value);
              },
            ),
          );
        } else {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(8),
            child: Text(
              cell.value.toString(),
              style: Constants.title,
            ),
          );
        }
      }).toList(),
    );
  }
}
