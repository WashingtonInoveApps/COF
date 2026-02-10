import 'package:bsu_control/core/constants.dart';
import 'package:bsu_control/core/enum.dart';
import 'package:bsu_control/model/car_changes_model.dart';
import 'package:bsu_control/model/car_model.dart';
import 'package:bsu_control/model/obm_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CarsTableView extends StatefulWidget {
  final List<CarModel> values;
  final List<OBMModel> obms;
  final Function(String)? onDetails;
  final Function(List<CarChangeModel>)? onChanges;
  const CarsTableView(
      {Key? key,
      required this.values,
      required this.obms,
      this.onDetails,
      this.onChanges})
      : super(key: key);

  @override
  State<CarsTableView> createState() => _CarsTableViewState();
}

class _CarsTableViewState extends State<CarsTableView> {
  late CarsDataSource dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = CarsDataSource(
        cars: widget.values,
        obms: widget.obms,
        onDetails: widget.onDetails,
        onChanges: (id) {
          final car = widget.values.firstWhere((e) => e.id == id);
          widget.onChanges?.call(car.changes);
        },
        onSortChanged: () {
          setState(() {});
        });
  }

  @override
  void didUpdateWidget(covariant CarsTableView oldWidget) {
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
      columnWidthMode: ColumnWidthMode.lastColumnFill,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      columns: [
        GridColumn(
          width: 50,
          columnName: 'details',
          label: Container(),
        ),
        GridColumn(
          columnName: 'prefix',
          label: header(label: 'PREFIXO'),
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
          columnName: 'plate',
          label: header(
            label: 'PLACA',
          ),
        ),
        GridColumn(
          columnName: 'type',
          label: header(label: 'TIPO', columnName: 'type'),
        ),
        GridColumn(
          columnName: 'function',
          label: header(label: 'FUNÇÃO', columnName: 'function'),
        ),
        GridColumn(
          columnName: 'km',
          label: header(label: 'KM'),
        ),
        GridColumn(
          width: 150,
          columnName: 'state',
          label: header(label: 'STATUS', columnName: 'state'),
        ),
        GridColumn(
          width: 120,
          columnName: 'changes',
          label: header(label: 'ALTERAÇÕES', columnName: 'changes'),
        ),
      ],
    );
  }
}

class CarsDataSource extends DataGridSource {
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

  void updateData(List<CarModel> cars, List<OBMModel> obms) {
    _rows = cars.map<DataGridRow>((car) {
      final obm = obms.firstWhere((e) => e.id == car.obmID);

      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'details', value: car.id),
        DataGridCell<String>(columnName: 'prefix', value: car.prefix),
        DataGridCell<String>(
            columnName: 'obm', value: obm.prefix.toUpperCase()),
        DataGridCell<String>(columnName: 'cia', value: car.cia.toUpperCase()),
        DataGridCell<String>(columnName: 'plate', value: car.plate),
        DataGridCell<String>(columnName: 'type', value: car.type),
        DataGridCell<String>(columnName: 'function', value: car.function),
        DataGridCell<String>(columnName: 'km', value: car.km.toString()),
        DataGridCell<String>(columnName: 'state', value: car.state.name),
        DataGridCell<String>(
          columnName: 'changes',
          value: '${car.changes.length}/${car.id}',
        ),
      ]);
    }).toList();

    applySort(); // 👈 apenas reaplica
    notifyListeners();
  }

  CarsDataSource({
    required List<CarModel> cars,
    required List<OBMModel> obms,
    this.onSortChanged,
    this.onDetails,
    this.onChanges,
  }) {
    _rows = cars.map<DataGridRow>((car) {
      final obm = obms.firstWhere((e) => e.id == car.obmID);

      return DataGridRow(cells: [
        DataGridCell<String>(
          columnName: 'details',
          value: car.id,
        ),
        DataGridCell<String>(
          columnName: 'prefix',
          value: car.prefix,
        ),
        DataGridCell<String>(
            columnName: 'obm', value: obm.prefix.toUpperCase()),
        DataGridCell<String>(columnName: 'cia', value: car.cia.toUpperCase()),
        DataGridCell<String>(columnName: 'plate', value: car.plate),
        DataGridCell<String>(columnName: 'type', value: car.type),
        DataGridCell<String>(
          columnName: 'function',
          value: car.function,
        ),
        DataGridCell<String>(columnName: 'km', value: car.km.toString()),
        DataGridCell<String>(columnName: 'state', value: car.state.name),
        DataGridCell<String>(
            columnName: 'changes', value: '${car.changes.length}/${car.id}'),
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
        if (cell.columnName == 'details') {
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
        } else if (cell.columnName == 'state') {
          final state = EnumCore.statusCarFromString(cell.value);

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
                  Text(
                    state.label,
                    style: Constants.subtitle.copyWith(color: Colors.white),
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
                    child: (int.parse(changesLength) > 0)
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
