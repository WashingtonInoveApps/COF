import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static final primary = Colors.green.shade800;

  static final title = GoogleFonts.poppins(fontSize: 14.0, color: Colors.black);
  static final titleButton = GoogleFonts.inter(
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
