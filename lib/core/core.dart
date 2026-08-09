import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Core {
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
      return "${days[date.weekday - 1]}, ${date.day.toString().padLeft(2, '0')} de ${months[date.month - 1]} de ${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    } else if (monthLarge) {
      return "${months[date.month - 1]} de ${date.year}";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
    }
  }

  static String formatHour(TimeOfDay hour) {
    return '${hour.hour.toString().padLeft(2, '0')}:${hour.minute.toString().padLeft(2, '0')}';
  }

  static Future<Uint8List?> pickerImage({
    required BuildContext context,
  }) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressFormat: ImageCompressFormat.png,
          aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              aspectRatioLockEnabled: true,
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        if (croppedFile == null) return null;

        final bytes = await croppedFile.readAsBytes();
        // final original = img.decodeImage(bytes)!;

        // final resized = img.copyResize(
        //   original,
        //   width: width.toInt(),
        //   height: height.toInt(),
        // );

        // return Uint8List.fromList(img.encodePng(resized));

        return bytes;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static RichText boldFirstName({
    required String name,
    required String fullName,
    String? graduation,
    TextStyle? style,
    TextStyle? boldStyle,
  }) {
    final normalStyle = style ?? const TextStyle(color: Colors.black);

    final highlightStyle = boldStyle ??
        normalStyle.copyWith(
          fontWeight: FontWeight.bold,
        );

    final highlightWords = name
        .toLowerCase()
        .split(' ')
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final fullWords = fullName.split(' ');

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: fullWords.map((word) {
          final cleanWord = word.toLowerCase();

          final isHighlighted = highlightWords.contains(cleanWord);

          return TextSpan(
            text: '$word ',
            style: isHighlighted ? highlightStyle : normalStyle,
          );
        }).toList(),
      ),
    );
  }

  static Color corEscuraAleatoria() {
    final random = Random();

    return Color.fromARGB(
      255,
      random.nextInt(150), // R mais baixo
      random.nextInt(150), // G
      random.nextInt(150), // B
    );
  }

  //Criado com auxílio do ChatGPT
  static DateTime getOperationalDay(DateTime now) {
    final today8am = DateTime(now.year, now.month, now.day, 8);

    if (now.isBefore(today8am)) {
      // Ainda faz parte do dia operacional de ontem
      final yesterday = now.subtract(const Duration(days: 1));
      return DateTime(yesterday.year, yesterday.month, yesterday.day);
    } else {
      // Já estamos no dia operacional de hoje
      return DateTime(now.year, now.month, now.day);
    }
  }

  static List<dynamic> paginate(
      {required List<dynamic> list, required int page, required int limit}) {
    final start = (page - 1) * limit;
    final end = (start + limit) > list.length ? list.length : start + limit;
    return list.sublist(start, end);
  }

  // static bool verifyExpiresChecklist() {
  //   final date = DateTime.now();

  //   if (date.hour < 8) return true;

  //   return false;
  // }

  static double calculateTableHeight(int rows) {
    const rowHeight = 52.0;
    const headerHeight = 40.0;

    return headerHeight + (rows * rowHeight);
  }
}
