import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Core {
  static final primary = Colors.green.shade800;

  static final title =
      GoogleFonts.openSans(fontSize: 14.0, color: Colors.black);
  static final titleHead = GoogleFonts.openSans(
      fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold);
  static final titleButton = GoogleFonts.openSans(
      fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  static final titleHint =
      GoogleFonts.openSans(fontSize: 14.0, color: Colors.grey);

  static final subtitle =
      GoogleFonts.openSans(fontSize: 12.0, color: Colors.black);
  static final subtitleHead =
      GoogleFonts.openSans(fontSize: 12.0, color: Colors.white);
  static final subtitleHint =
      GoogleFonts.openSans(fontSize: 12.0, color: Colors.grey);

  static final alfas = [
    "ALFA 1",
    "ALFA 2",
    "ALFA 3",
    "ALFA 4",
    "ALFA 5",
    "ALFA 6"
  ];
  static final carsType = ["ADMINISTRATIVO", "OPERACIONAL"];

  static final statusType = [
    "Ar condicionado",
    "Elétricos",
    "Mecânicos",
    "Pneu",
    "Outros"
  ];

  static final obms = [
    "1º BBM",
    "2º BBM",
    "3º BBM",
    "4º BBM",
    "5º BBM",
    "6º BBM",
    "ATI",
    "BBS",
    "BPI",
    "BSMAR",
    "BSU",
    "CBC",
    "CBI",
    "CEPI",
    "CIOPS - FORTALEZA",
    "CMCB",
    "COMALP",
    "DEFESA CIVIL"
  ];

  static final graduations = [
    'Soldado',
    'Cabo',
    '1º Sargento',
    '2º Sargento',
    '3º Sargento',
    'Subtenente',
    '1º Tenente',
    '2º Tenente',
    'Capitão',
    'Major',
    'Tenente Coronel',
    'Coronel'
  ];

  static final listItensEletric = [
    ItemModel(description: "AR CONDICIONADO"),
    ItemModel(description: "TRANSFORMADOR"),
    ItemModel(description: "MEIA LUZ FAROL"),
    ItemModel(description: "LUZ FAROL BAIXA"),
    ItemModel(description: "LUZ FAROL ALTA"),
    ItemModel(description: "FAROL DE NEBLINA"),
    ItemModel(description: "LUZ DE FREIO"),
    ItemModel(description: "LUZ INDICADORA DE CONVERSÃO"),
    ItemModel(description: "LUZ DA RÉ"),
    ItemModel(description: "LUZ DA CABINE"),
    ItemModel(description: "LUZ DE EMBARQUE"),
    ItemModel(description: "LUZ DA PLACA"),
    ItemModel(description: "VIDROS ELÉTRICOS"),
    ItemModel(description: "LUZ DO SALÃO"),
    ItemModel(description: "GIROFLEX"),
    ItemModel(description: "SIRENE"),
    ItemModel(description: "MINIBARRA DE SINALIZAÇÃO TRASEIRA"),
    ItemModel(description: "ESTROBO"),
    ItemModel(description: "LANTERNAS LATERAIS"),
    ItemModel(description: "LIMPADOR DE PARABRISA"),
    ItemModel(description: "BUZINA")
  ];

  static final listItensEquip = [
    ItemModel(description: "PNEU RESERVA"),
    ItemModel(description: "MACACO"),
    ItemModel(description: "CHAVE DE RODA"),
    ItemModel(description: "CONES DE SINALIZAÇÃO"),
    ItemModel(description: "TRIÂNGULO DE SINALIZAÇÃO"),
    ItemModel(description: "EXTINTOR PEQUENO"),
    ItemModel(description: "EXTINTOR GRANDE"),
    ItemModel(description: "PLACAS DO VEÍCULO"),
    ItemModel(description: "DOCUMENTO DO VEÍCULO - CRLV"),
    ItemModel(description: "MANUAL DO VEÍCULO"),
    ItemModel(description: "MOVÉIS INTERNOS"),
    ItemModel(description: "CARTÃO DE ABASTECIMENTO"),
    ItemModel(description: "RÁDIO DE COMUNICAÇÃO"),
    ItemModel(description: "FLANELA")
  ];

  static String formatDate(DateTime date,
      {bool shortHour = false,
      bool monthLarge = false,
      bool largeDay = false,
      bool largeDayHour = false}) {
    final days = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];
    final months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    if (shortHour) {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (largeDay) {
      return "${days[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} de ${months[date.month - 1]} de ${date.year}";
    } else if (largeDayHour) {
      return "${days[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} de ${months[date.month - 1]} de ${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } else if (monthLarge) {
      return "${months[date.month - 1]} de ${date.year}";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  static String formatHour(TimeOfDay hour) {
    return '${hour.hour.toString().padLeft(2, '0')}:${hour.minute.toString().padLeft(2, '0')}';
  }
}
