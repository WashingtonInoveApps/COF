import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/check_list_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ChecklistTableView extends StatefulWidget {
  final List<ChecklistModel> values;
  final List<OBMModel> obms;
  final Function(String)? onContact;
  final Function(ChecklistModel)? onDetails;
  final Function(List<CarChangeModel>)? onChanges;

  const ChecklistTableView(
      {Key? key,
      required this.values,
      required this.obms,
      this.onContact,
      this.onDetails,
      this.onChanges})
      : super(key: key);

  @override
  State<ChecklistTableView> createState() => _ChecklistTableViewState();
}

class _ChecklistTableViewState extends State<ChecklistTableView> {
  late ChecklistDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = ChecklistDataSource(
        checklists: widget.values,
        obms: widget.obms,
        onContact: widget.onContact,
        onDetails: (id) {
          final checklist = widget.values.firstWhere((e) => e.id == id);
          widget.onDetails?.call(checklist);
        },
        onChanges: (id) {
          final checklist = widget.values.firstWhere((e) => e.id == id);
          widget.onChanges?.call(checklist.changes);
        },
        onSortChanged: () {
          setState(() {});
        });
  }

  @override
  void didUpdateWidget(covariant ChecklistTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    dataSource.updateData(widget.values, widget.obms);
  }

  @override
  Widget build(BuildContext context) {
    header({required String label, String? columnName}) {
      final isActive = dataSource.sortColumn == columnName;

      return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade700),
        child: InkWell(
          onTap: columnName != null
              ? () => dataSource.sortCustom(columnName)
              : null,
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: Constants.subtitle.copyWith(color: Colors.white),
                    textAlign: TextAlign.center),
              ),
              (isActive)
                  ? (columnName == null)
                      ? Container()
                      : Icon(
                          dataSource.ascending
                              ? MdiIcons.arrowUp
                              : MdiIcons.arrowDown,
                          color: Colors.white,
                          size: 18,
                        )
                  : (columnName == null)
                      ? Container()
                      : Icon(MdiIcons.swapVertical,
                          size: 18, color: Colors.grey),
            ],
          ),
        ),
      );
    }

    return SfDataGrid(
      headerRowHeight: 50,
      source: dataSource,
      verticalScrollPhysics: const ClampingScrollPhysics(),
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
          label: header(label: 'OBM', columnName: 'obm'),
        ),
        GridColumn(
          columnName: 'cia',
          label: header(label: 'COMPANHIA', columnName: 'cia'),
        ),
        GridColumn(
          columnName: 'team',
          label: header(label: 'GUARNIÇÃO', columnName: 'team'),
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
          columnName: 'state',
          label: header(label: 'STATUS', columnName: 'state'),
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
          label: header(label: 'ALTERAÇÕES', columnName: 'changes'),
        ),
      ],
    );
  }
}

class ChecklistDataSource extends DataGridSource {
  final Function(String contact)? onContact;
  final Function(String id)? onDetails;
  final Function(String id)? onChanges;

  final VoidCallback? onSortChanged;

  String? sortColumn;
  bool ascending = true;

  void applySort() {
    if (sortColumn == null) return;

    _rows.sort((a, b) {
      final aValue =
          a.getCells().firstWhere((c) => c.columnName == sortColumn).value;
      final bValue =
          b.getCells().firstWhere((c) => c.columnName == sortColumn).value;

      if (aValue is num && bValue is num) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      }

      return ascending
          ? aValue.toString().compareTo(bValue.toString())
          : bValue.toString().compareTo(aValue.toString());
    });
  }

  void sortCustom(String columnName) {
    if (sortColumn == columnName) {
      ascending = !ascending;
    } else {
      sortColumn = columnName;
      ascending = true;
    }

    applySort(); // 👈 usa a função correta
    notifyListeners();
    onSortChanged?.call();
  }

  void updateData(List<ChecklistModel> checklists, List<OBMModel> obms) {
    _rows = checklists.map<DataGridRow>((check) {
      final obm = obms.firstWhere((e) => e.id == check.obmID);

      final listStates = List<StatesChecklist>.from(check.states);
      listStates.sort((a, b) => b.date.compareTo(a.date));

      final state = listStates.first;

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
        DataGridCell<String>(columnName: 'state', value: state.state.name),
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
            value: '${check.changes.length}/${check.id}'),
      ]);
    }).toList();

    applySort(); // 👈 apenas reaplica
    notifyListeners();
  }

  ChecklistDataSource({
    required List<ChecklistModel> checklists,
    required List<OBMModel> obms,
    this.onContact,
    this.onDetails,
    this.onSortChanged,
    this.onChanges,
  }) {
    _rows = checklists.map<DataGridRow>((check) {
      final obm = obms.firstWhere((e) => e.id == check.obmID);

      final listStates = List<StatesChecklist>.from(check.states);
      listStates.sort((a, b) => b.date.compareTo(a.date));

      final state = listStates.first;

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
        DataGridCell<String>(columnName: 'state', value: state.state.name),
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
            value: '${check.changes.length}/${check.id}'),
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
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.center,
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
          return (onDetails != null)
              ? Center(
                  child: InkWell(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(100)),
                      child: const Padding(
                        padding: EdgeInsets.all(5.0),
                        child:
                            Icon(Icons.search, size: 20, color: Colors.green),
                      ),
                    ),
                    onTap: () async {
                      final value = cell.value;
                      onDetails?.call(value);
                    },
                  ),
                )
              : Container();
        } else if (cell.columnName == 'state') {
          final state = EnumCore.statusChecklistFromString(cell.value);

          return Center(
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: state.color, borderRadius: BorderRadius.circular(5)),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(state.icon, color: Colors.white),
                  Expanded(
                    child: Text(
                      state.label,
                      style: Constants.subtitle.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (cell.columnName == 'changes') {
          final list = cell.value.toString().split('/');

          final changesLength = list.first;
          final id = list.last;

          return Center(
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(5),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        changesLength.padLeft(2, '0'),
                        style: Constants.title,
                      ),
                    ),
                  ),
                  Expanded(
                    child: (int.parse(changesLength) > 0 && (onChanges != null))
                        ? Center(
                            child: InkWell(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusGeometry.circular(100)),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.list_alt_rounded,
                                    size: 20,
                                    color: Constants.primary,
                                  ),
                                ),
                              ),
                              onTap: () async {
                                onChanges?.call(id);
                              },
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
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
