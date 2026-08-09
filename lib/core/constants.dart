import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static const primary = Color.fromARGB(
      255, 27, 94, 32); //Color(0xFF2E7D32); // Colors.green.shade900;
  static const second = Color.fromARGB(255, 25, 118, 210);
  static final title = GoogleFonts.poppins(fontSize: 14.0, color: Colors.black);
  static final titleButton = GoogleFonts.montserrat(
      fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.bold);
  static final titleHint =
      GoogleFonts.poppins(fontSize: 14.0, color: Colors.grey);

  static final subtitle =
      GoogleFonts.poppins(fontSize: 12.0, color: Colors.black);
  static final subtitleHint =
      GoogleFonts.poppins(fontSize: 12.0, color: Colors.grey);

  static final carsFunctions = ["Operacional", "Administrativo"];

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
}
