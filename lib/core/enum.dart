import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StatusCar { operando, reserva, baixado }

enum StateChecklist { inprogress, completed, expired }

enum StateCarProblems { airconditioning, pneu, mechanics, electric, others }

extension CarStateLabel on StatusCar {
  String get label {
    switch (this) {
      case StatusCar.operando:
        return "Operando";
      case StatusCar.reserva:
        return "Reserva";
      case StatusCar.baixado:
        return "Baixado";
    }
  }
}

extension StateCarProblemsLabel on StateCarProblems {
  String get label {
    switch (this) {
      case StateCarProblems.airconditioning:
        return "Ar condicionado";
      case StateCarProblems.electric:
        return "Elétricos";
      case StateCarProblems.mechanics:
        return "Mecânicos";
      case StateCarProblems.pneu:
        return "Pneus";
      case StateCarProblems.others:
        return "Outros";
    }
  }
}

extension StateCarProblemsColor on StateCarProblems {
  Color get color {
    switch (this) {
      case StateCarProblems.airconditioning:
        return Colors.blue.shade700;
      case StateCarProblems.electric:
        return Colors.green;
      case StateCarProblems.mechanics:
        return Colors.orange;
      case StateCarProblems.pneu:
        return Colors.brown;
      case StateCarProblems.others:
        return Colors.red;
    }
  }
}

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

extension CarStateColor on StatusCar {
  Color get color {
    switch (this) {
      case StatusCar.operando:
        return Colors.green.shade800;
      case StatusCar.reserva:
        return Colors.orange;
      case StatusCar.baixado:
        return Colors.red;
    }
  }
}

extension CarStateIcon on StatusCar {
  IconData get icon {
    switch (this) {
      case StatusCar.operando:
        return Icons.check_circle;
      case StatusCar.reserva:
        return Icons.info_rounded;
      case StatusCar.baixado:
        return MdiIcons.closeCircle;
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

class EnumCore {
  static StatusCar statusCarFromString(String value) {
    return StatusCar.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StatusCar.operando,
    );
  }

  static StateChecklist statusChecklistFromString(String value) {
    return StateChecklist.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StateChecklist.inprogress,
    );
  }

  static StateCarProblems stateCarProblemsFromString(String value) {
    return StateCarProblems.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StateCarProblems.others,
    );
  }
}
