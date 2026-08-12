// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// 🔹 COLUNA GENÉRICA
class AppColumn<T> {
  final String name;
  final String? label;
  final Color? headColor;
  final Widget Function(T item) builder;

  /// 🔥 valor usado para ordenação (IMPORTANTE)
  final Comparable Function(T item)? sortValue;

  final double? width;
  final Alignment alignment;
  final bool sortable;
  final bool hasLoading;
  final bool visible;

  AppColumn({
    required this.name,
    this.label,
    required this.builder,
    this.sortValue,
    this.width,
    this.alignment = Alignment.center,
    this.sortable = false,
    this.hasLoading = false,
    this.visible = true,
    this.headColor,
  });
}

/// 🔹 DATA TABLE
class AppDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<AppColumn<T>> columns;
  final AppDataTableController<T>? controller;
  final ColumnWidthMode columnMode;
  final int limit;

  /// 🔥 função pra identificar cada item (ID)
  final String Function(T item) rowId;

  const AppDataTable({
    Key? key,
    required this.data,
    required this.columns,
    this.controller,
    this.columnMode = ColumnWidthMode.auto,
    required this.rowId,
    required this.limit,
  }) : super(key: key);

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  late AppDataSource<T> dataSource;

  @override
  void initState() {
    super.initState();
    dataSource = AppDataSource<T>(
      data: widget.data,
      columns: widget.columns.where((e) => e.visible).toList(),
      rowId: widget.rowId,
      onRefresh: () => setState(() {}),
    );

    widget.controller?.bind(dataSource); // 🔥 aqui
  }

  @override
  void didUpdateWidget(covariant AppDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 🔥 atualização eficiente (sem recriar tudo desnecessariamente)
    dataSource.updateData(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final height = ((widget.limit > widget.data.length
                ? widget.data.length
                : widget.limit) *
            60.0) +
        65;
    return SizedBox(
      height: height,
      child: SfDataGrid(
        source: dataSource,
        columnWidthMode: widget.columnMode,
        gridLinesVisibility: GridLinesVisibility.horizontal,
        headerGridLinesVisibility: GridLinesVisibility.horizontal,
        rowsCacheExtent: 50, // 🚀 performance
        rowHeight: 60,
        headerRowHeight: 65,
        verticalScrollPhysics: const NeverScrollableScrollPhysics(),
        columns: widget.columns.where((e) => e.visible).map((col) {
          return GridColumn(
            columnName: col.name,
            width: col.width ?? double.nan,
            label: _HeaderCell(
              label: col.label,
              color: col.headColor,
              sortable: col.sortable,
              onSort: () => dataSource.sortData(col.name),
              isActive: dataSource.sortColumn == col.name,
              ascending: dataSource.ascending,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 🔹 HEADER COM SORT
class _HeaderCell extends StatelessWidget {
  final String? label;
  final Color? color;
  final bool sortable;
  final VoidCallback onSort;
  final bool isActive;
  final bool ascending;

  const _HeaderCell({
    this.label,
    this.color,
    required this.sortable,
    required this.onSort,
    required this.isActive,
    required this.ascending,
  });

  @override
  Widget build(BuildContext context) {
    return (label == null)
        ? Container()
        : InkWell(
            onTap: sortable ? onSort : null,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              decoration: BoxDecoration(
                color: color ?? Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          label ?? '',
                          style: Constants.title.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  if (sortable)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(
                        isActive
                            ? (ascending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward)
                            : Icons.unfold_more,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                ],
              ),
            ),
          );
  }
}

/// 🔹 DATA SOURCE GENÉRICO
class AppDataSource<T> extends DataGridSource {
  List<T> data;
  final List<AppColumn<T>> columns;
  final String Function(T item) rowId;
  final VoidCallback onRefresh;

  AppDataSource({
    required this.data,
    required this.columns,
    required this.rowId,
    required this.onRefresh,
  });

  /// 🔥 loading por linha (SEGURANÇA TOTAL)
  final Map<String, bool> loadingMap = {};

  String? sortColumn;
  bool ascending = true;

  void updateData(List<T> newData) {
    if (identical(data, newData)) return;

    data = newData;
    notifyListeners();
  }

  void sortData(String columnName) {
    final column = columns.firstWhere((c) => c.name == columnName);

    if (sortColumn == columnName) {
      ascending = !ascending;
    } else {
      sortColumn = columnName;
      ascending = true;
    }

    if (column.sortValue != null) {
      data.sort((a, b) {
        final aValue = column.sortValue!(a);
        final bValue = column.sortValue!(b);

        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      });
    }

    notifyListeners();
    onRefresh();
  }

  @override
  List<DataGridRow> get rows {
    return data.map((item) {
      return DataGridRow(
        cells: columns.map((col) {
          return DataGridCell<T>(
            columnName: col.name,
            value: item,
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    /// 🔥 NUNCA usa indexOf
    final item = row.getCells().first.value as T;

    final id = rowId(item);
    final isLoading = loadingMap[id] ?? false;

    return DataGridRowAdapter(
      cells: columns.map((col) {
        if (isLoading && col.hasLoading) {
          return Container(
            alignment: col.alignment,
            padding: const EdgeInsets.all(8),
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Constants.primary),
              ),
            ),
          );
        }

        return Container(
          alignment: col.alignment,
          padding: const EdgeInsets.all(8),
          child: col.builder(item),
        );
      }).toList(),
    );
  }

  /// 🔥 controle de loading por linha
  void setRowLoading(T item, bool value) {
    final id = rowId(item);
    loadingMap[id] = value;
    notifyListeners();
  }
}

class AppDataTableController<T> {
  AppDataSource<T>? _dataSource;

  void bind(AppDataSource<T> ds) {
    _dataSource = ds;
  }

  void setRowLoading(T item, bool value) {
    _dataSource?.setRowLoading(item, value);
  }
}
