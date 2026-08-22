import 'package:bsu_control/core/core.dart';
import 'package:bsu_control/enum/checklist_enum.dart';
import 'package:bsu_control/enum/state_enum.dart';
import 'package:bsu_control/widgets/table_widget.dart';
import 'package:bsu_control/widgets/tag_widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../core/constants.dart';
import '../model/checklist_model.dart';

class ChecklistTableWidget extends StatelessWidget {
  final List<ChecklistModel> list;
  final int limit;
  final Function(ChecklistModel)? onDetails;

  const ChecklistTableWidget(
      {Key? key, required this.list, required this.limit, this.onDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDataTable<ChecklistModel>(
      limit: limit,
      data: list,
      columnMode: ColumnWidthMode.auto,
      columns: [
        AppColumn(
          width: 50,
          name: 'details',
          builder: (checklist) {
            return InkWell(
              onTap: () => onDetails?.call(checklist),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100)),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.search, size: 20, color: Colors.green),
                ),
              ),
            );
          },
        ),
        AppColumn(
          width: 120,
          name: 'date',
          label: 'Data',
          sortValue: (checklist) => checklist.date,
          builder: (checklist) => Text(
            Core.formatDate(checklist.date),
            style: Constants.title,
          ),
        ),
        AppColumn(
          width: 120,
          name: 'type',
          label: 'Tipo',
          sortValue: (checklist) => checklist.type.label,
          builder: (checklist) => TagWidget(
            label: checklist.type.label,
            color: checklist.type.color,
            icon: checklist.type.icon,
          ),
        ),
        AppColumn(
          width: 120,
          name: 'obm',
          label: 'OBM',
          sortValue: (checklist) => checklist.obm?.prefix ?? '',
          builder: (checklist) => Text(
            checklist.obm?.prefix ?? '',
            style: Constants.title,
          ),
        ),
        AppColumn(
          name: 'cia',
          label: 'Companhia',
          sortValue: (checklist) => checklist.cia?.name ?? '-',
          builder: (checklist) => Text(
            checklist.cia?.name ?? '-',
            style: Constants.title,
          ),
        ),
        AppColumn(
          name: 'team',
          label: 'Guarnição',
          sortValue: (checklist) => checklist.team?.name ?? '-',
          builder: (checklist) => Text(
            checklist.team?.name ?? '-',
            style: Constants.title,
          ),
        ),
        AppColumn(
          name: 'car',
          label: 'Prefixo',
          sortValue: (checklist) => checklist.prefix,
          builder: (checklist) => Text(
            checklist.prefix.isEmpty ? '-' : checklist.prefix,
            style: Constants.title,
          ),
        ),
        AppColumn(
          width: 180,
          name: 'state',
          label: 'Status',
          sortValue: (checklist) => checklist.state.label,
          builder: (checklist) => TagWidget(
            label: checklist.state.label,
            color: checklist.state.color,
            icon: checklist.state.icon,
          ),
        ),
        AppColumn(
          name: 'pb',
          label: 'P. Base',
          sortValue: (checklist) => checklist.pb,
          builder: (checklist) => Text(
            checklist.pb,
            style: Constants.title,
          ),
        ),
        AppColumn(
          width: 200,
          name: 'responsable',
          label: 'Responsável',
          sortValue: (checklist) => checklist.user.name,
          builder: (checklist) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Core.boldFirstName(
                name: checklist.user.name,
                fullName: checklist.user.fullname,
                style: Constants.title,
                over: TextOverflow.ellipsis,
              ),
              Text(
                checklist.user.graduation,
                style: Constants.subtitleHint,
              )
            ],
          ),
        ),
      ],
      rowId: (service) {
        return service.id ?? 'err';
      },
    );
  }
}
