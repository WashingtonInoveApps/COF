import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StateChecklist { inprogress, completed, expired }

extension ChecklistStateLabel on StateChecklist {
  String get label {
    switch (this) {
      case StateChecklist.inprogress:
        return "Em andamento";
      case StateChecklist.completed:
        return "Finalizado";
      case StateChecklist.expired:
        return "Vencido";
    }
  }
}

extension ChecklistStateColor on StateChecklist {
  Color get color {
    switch (this) {
      case StateChecklist.inprogress:
        return Colors.blue.shade700;
      case StateChecklist.completed:
        return Colors.green;
      case StateChecklist.expired:
        return Colors.orange;
    }
  }
}

extension StateChecklistIcon on StateChecklist {
  IconData get icon {
    switch (this) {
      case StateChecklist.inprogress:
        return Icons.pending;
      case StateChecklist.completed:
        return MdiIcons.checkAll;
      case StateChecklist.expired:
        return Icons.info_rounded;
    }
  }
}

class ChecklistEnumCore {
  static StateChecklist statusChecklistFromString(String value) {
    return StateChecklist.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StateChecklist.inprogress,
    );
  }
}
