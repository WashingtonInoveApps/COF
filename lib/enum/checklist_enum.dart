import 'package:flutter/material.dart';

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
        return Colors.orange;
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
