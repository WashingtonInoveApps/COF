import 'package:bsu_control/model/itens_changes_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final title = GoogleFonts.nunitoSans(fontSize: 14.0, color: Colors.black);
final titleHead = GoogleFonts.nunitoSans(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold);
final titleButton = GoogleFonts.nunitoSans(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white);
final titleHint = GoogleFonts.nunitoSans(fontSize: 14.0, color: Colors.grey);

final subtitle = GoogleFonts.nunitoSans(fontSize: 12.0, color: Colors.black);
final subtitleHead = GoogleFonts.nunitoSans(fontSize: 16.0, color: Colors.white);
final subtitleHint = GoogleFonts.nunitoSans(fontSize: 12.0, color: Colors.grey);

final alfas = ["ALFA 1", "ALFA 2", "ALFA 3", "ALFA 4", "ALFA 5", "ALFA 6"];
final carsType = ["AMBULÂNCIA", "AUTO BOMBA TANQUE", "CAMINHÃO", "PICK UP"];
final statusType = ["AR CONDICIONADO", "VAZAMENTO", "ÉLETRICOS", "MÊCANICOS", "PNEU", "DIREÇÃO", "FREIO"];
final unidades = ["BSU", "1BBM"];

final listItensEletric = [
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

final listItensEquip = [
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

String formatDate(DateTime date, {bool outher = false, bool referenceDate = false}) {
  final week = ["", "Domingo", "Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado"];
  if (outher) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} - ${week[date.weekday]}";
  }

  if (referenceDate) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} - ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
}
