import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StatusCar { operando, reserva, baixado, waiting }

enum StateCarProblems {
  airconditioning,
  pneu,
  cooling,
  brake,
  engine,
  injection,
  mechanics,
  electric,
  others
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
      case StateCarProblems.brake:
        return "Freios";
      case StateCarProblems.cooling:
        return "Arrefecimento";
      case StateCarProblems.engine:
        return "Motor";
      case StateCarProblems.injection:
        return "Injeção eletrônica";
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
        return Colors.green.shade700;
      case StateCarProblems.mechanics:
        return Colors.orange.shade700;
      case StateCarProblems.pneu:
        return Colors.brown.shade700;
      case StateCarProblems.brake:
        return Colors.yellowAccent.shade700;
      case StateCarProblems.cooling:
        return Colors.blueGrey.shade700;
      case StateCarProblems.engine:
        return Colors.deepPurple.shade700;
      case StateCarProblems.injection:
        return Colors.pink.shade700;
      case StateCarProblems.others:
        return Colors.red.shade700;
    }
  }
}

extension CarStateLabel on StatusCar {
  String get label {
    switch (this) {
      case StatusCar.operando:
        return "Operando";
      case StatusCar.reserva:
        return "Reserva";
      case StatusCar.baixado:
        return "Baixado";
      case StatusCar.waiting:
        return "Em espera";
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

      case StatusCar.waiting:
        return Colors.grey;
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
      case StatusCar.waiting:
        return MdiIcons.clockTimeEight;
    }
  }
}

class CarEnumCore {
  static StatusCar statusCarFromString(String value) {
    return StatusCar.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StatusCar.operando,
    );
  }

  static StateCarProblems stateCarProblemsFromString(String value) {
    return StateCarProblems.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StateCarProblems.others,
    );
  }
}
