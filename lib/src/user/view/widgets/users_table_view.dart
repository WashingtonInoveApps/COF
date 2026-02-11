import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:bsu_control/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UsersTableView extends StatefulWidget {
  final List<UserModel> values;
  final List<OBMModel> obms;
  final Function(String)? onContact;
  final Function(UserModel)? onDetails;
  final Function(UserModel)? onEnable;

  const UsersTableView(
      {Key? key,
      required this.values,
      required this.obms,
      this.onContact,
      this.onDetails,
      this.onEnable})
      : super(key: key);

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> {
  late UserDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = UserDataSource(
        users: widget.values,
        obms: widget.obms,
        onContact: widget.onContact,
        onDetails: (id) {
          widget.onDetails?.call(widget.values.firstWhere((e) => e.id == id));
        },
        onEnable: (id, value) {
          widget.onEnable?.call(widget.values
              .firstWhere((e) => e.id == id)
              .copyWith(enable: value));
        },
        onSortChanged: () {
          setState(() {});
        });
  }

  @override
  void didUpdateWidget(covariant UsersTableView oldWidget) {
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
          width: 60,
          columnName: 'enable',
          label: Container(),
        ),
        GridColumn(
          width: 50,
          columnName: 'details',
          label: Container(),
        ),
        GridColumn(
          columnName: 'graduation',
          label: header(label: 'GRADUAÇÃO'),
        ),
        GridColumn(
          columnName: 'name',
          label: header(label: 'NOME'),
        ),
        GridColumn(
          columnName: 'registration',
          label: header(label: 'MATRÍCULA'),
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
          columnName: 'email',
          label: header(label: 'E-MAIL'),
        ),
        GridColumn(
          width: 180,
          columnName: 'contact',
          label: header(label: 'CONTATO'),
        ),
      ],
    );
  }
}

class UserDataSource extends DataGridSource {
  final Function(String contact)? onContact;
  final Function(String id)? onDetails;
  final Function(String id, bool value)? onEnable;

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

  void updateData(List<UserModel> users, List<OBMModel> obms) {
    _rows = users.map<DataGridRow>((user) {
      final obm = obms.firstWhere((e) => e.id == user.obmID);

      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'enable',
          value: '${user.id ?? ''}/${user.enable.toString()}',
        ),
        DataGridCell<String>(
          columnName: 'details',
          value: user.id,
        ),
        DataGridCell<String>(
            columnName: 'graduation', value: user.graduation.toUpperCase()),
        DataGridCell<String>(
          columnName: 'name',
          value: '${user.name}/${user.fullname}',
        ),
        DataGridCell<String>(
          columnName: 'registration',
          value: user.registration,
        ),
        DataGridCell<String>(
            columnName: 'obm', value: obm.prefix.toUpperCase()),
        DataGridCell<String>(columnName: 'cia', value: user.cia.toUpperCase()),
        DataGridCell<String>(columnName: 'email', value: user.email),
        DataGridCell<String>(
          columnName: 'contact',
          value: user.contact,
        ),
      ]);
    }).toList();

    applySort(); // 👈 apenas reaplica
    notifyListeners();
  }

  UserDataSource({
    required List<UserModel> users,
    required List<OBMModel> obms,
    this.onContact,
    this.onDetails,
    this.onEnable,
    this.onSortChanged,
  }) {
    _rows = users.map<DataGridRow>((user) {
      final obm = obms.firstWhere((e) => e.id == user.obmID);

      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: '${user.id ?? ''}/${user.enable.toString()}',
          value: user.enable.toString(),
        ),
        DataGridCell<String>(
          columnName: 'details',
          value: user.id,
        ),
        DataGridCell<String>(
            columnName: 'graduation', value: user.graduation.toUpperCase()),
        DataGridCell<String>(
          columnName: 'name',
          value: '${user.name}/${user.fullname}',
        ),
        DataGridCell<String>(
          columnName: 'registration',
          value: user.registration,
        ),
        DataGridCell<String>(
            columnName: 'obm', value: obm.prefix.toUpperCase()),
        DataGridCell<String>(columnName: 'cia', value: user.cia.toUpperCase()),
        DataGridCell<String>(columnName: 'email', value: user.email),
        DataGridCell<String>(
          columnName: 'contact',
          value: user.contact,
        ),
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
        } else if (cell.columnName == 'enable') {
          final list = cell.value.toString().split('/');

          final id = list.first;
          final enable = (list.last == 'true');
          return Center(
              child: Switch(
                  value: enable,
                  activeThumbColor: Constants.primary,
                  onChanged: (_) => onEnable?.call(id, !enable)));
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
        } else if (cell.columnName == 'name') {
          final list = cell.value.toString().split('/');

          return Align(
            alignment: Alignment.centerLeft,
            child: Core.boldFirstName(
                name: list.first.toUpperCase(),
                fullName: list.last.toUpperCase(),
                normalStyle: Constants.subtitle),
          );
        } else if (cell.columnName == 'email') {
          return Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                cell.value.toString(),
                style: Constants.subtitle,
              ));
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
