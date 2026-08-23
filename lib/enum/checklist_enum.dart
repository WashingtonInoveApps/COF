import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum ChecklistType { vehicular, materials }

extension ChecklistTypeLabel on ChecklistType {
  String get label {
    switch (this) {
      case ChecklistType.vehicular:
        return "Veicular";
      case ChecklistType.materials:
        return "Material";
    }
  }
}

extension ChecklistTypeColor on ChecklistType {
  Color get color {
    switch (this) {
      case ChecklistType.vehicular:
        return Colors.red.shade700;
      case ChecklistType.materials:
        return Colors.orange.shade700;
    }
  }
}

extension ChecklistTypeIcon on ChecklistType {
  IconData get icon {
    switch (this) {
      case ChecklistType.vehicular:
        return MdiIcons.car;
      case ChecklistType.materials:
        return MdiIcons.dolly;
    }
  }
}

class ChecklistEnumCore {
  static ChecklistType checklistTypeFromString(String value) {
    return ChecklistType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChecklistType.vehicular,
    );
  }
}
