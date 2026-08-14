import 'package:flutter/material.dart';

enum ItemStatus { normal, altered }

enum ItemUnit { pct, un, cx }

extension ItemStatusLabel on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.altered:
        return 'Baixo';
      case ItemStatus.normal:
        return 'Normal';
    }
  }
}

extension ItemUnitLabel on ItemUnit {
  String get label {
    switch (this) {
      case ItemUnit.cx:
        return 'Caixa';
      case ItemUnit.pct:
        return 'Pacote';
      case ItemUnit.un:
        return 'Unidade';
    }
  }
}

extension ItemStatusColor on ItemStatus {
  Color get color {
    switch (this) {
      case ItemStatus.altered:
        return Colors.orange.shade700;
      case ItemStatus.normal:
        return Colors.green.shade700;
    }
  }
}

extension ItemStatusIcon on ItemStatus {
  IconData get icon {
    switch (this) {
      case ItemStatus.altered:
        return Icons.info;
      case ItemStatus.normal:
        return Icons.check_circle;
    }
  }
}

class CoreEnum {
  static ItemStatus itemStatusFromString(String value) {
    return ItemStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ItemStatus.normal,
    );
  }

  static ItemUnit itemUnitFromString(String value) {
    return ItemUnit.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ItemUnit.un,
    );
  }
}
