import 'package:flutter/material.dart';

enum ServiceFunctions {
  conductor,
  commander,
  operator,
  logistics,
  rescuer,
  assistant
}

enum ServicePeriod { turnoA, turnoB, turnaAB }

extension ServicePeriodLabel on ServicePeriod {
  String get label {
    switch (this) {
      case ServicePeriod.turnoA:
        return "Turno A";
      case ServicePeriod.turnoB:
        return "Turno B";
      case ServicePeriod.turnaAB:
        return "Turno A/B";
    }
  }
}

extension ServiceFunctionsLabel on ServiceFunctions {
  String get label {
    switch (this) {
      case ServiceFunctions.commander:
        return "Comandante";
      case ServiceFunctions.conductor:
        return "Condutor";
      case ServiceFunctions.logistics:
        return "Logística";
      case ServiceFunctions.operator:
        return "Operador";
      case ServiceFunctions.rescuer:
        return "Socorrista";
      case ServiceFunctions.assistant:
        return "Auxiliar";
    }
  }
}

extension ServiceFunctionsColor on ServiceFunctions {
  Color get color {
    switch (this) {
      case ServiceFunctions.commander:
        return Colors.blue.shade700;
      case ServiceFunctions.operator:
        return Colors.green.shade700;
      case ServiceFunctions.conductor:
        return Colors.orange;
      case ServiceFunctions.logistics:
        return Colors.brown;
      case ServiceFunctions.assistant:
        return Colors.yellowAccent.shade700;
      case ServiceFunctions.rescuer:
        return Colors.deepPurple;
    }
  }
}

class ServiceEnumCore {
  static ServiceFunctions stateServiceFunctionsFromString(String value) {
    return ServiceFunctions.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ServiceFunctions.operator,
    );
  }

  static ServicePeriod stateServicePeriodFromString(String value) {
    return ServicePeriod.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ServicePeriod.turnaAB,
    );
  }
}
