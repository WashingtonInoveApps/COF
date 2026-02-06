import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum StatusCar { operando, reserva, baixado }

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
