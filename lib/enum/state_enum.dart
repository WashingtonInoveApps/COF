import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StateProgress { inprogress, completed, expired, reactivated }

extension StateProgressLabel on StateProgress {
  String get label {
    switch (this) {
      case StateProgress.inprogress:
        return "Em andamento";
      case StateProgress.completed:
        return "Finalizado";
      case StateProgress.expired:
        return "Vencido";
      case StateProgress.reactivated:
        return "Reativado";
    }
  }
}

extension StateProgressColor on StateProgress {
  Color get color {
    switch (this) {
      case StateProgress.inprogress:
        return Colors.grey.shade600;
      case StateProgress.completed:
        return Colors.blue.shade700;
      case StateProgress.expired:
        return Colors.orange.shade700;
      case StateProgress.reactivated:
        return Colors.green.shade700;
    }
  }
}

extension StateProgressIcon on StateProgress {
  IconData get icon {
    switch (this) {
      case StateProgress.inprogress:
        return Icons.pending;
      case StateProgress.completed:
        return MdiIcons.checkAll;
      case StateProgress.expired:
        return Icons.info_rounded;
      case StateProgress.reactivated:
        return MdiIcons.progressCheck;
    }
  }
}

class StateProgressEnumCore {
  static StateProgress stateProgressFromString(String value) {
    return StateProgress.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StateProgress.inprogress,
    );
  }
}
