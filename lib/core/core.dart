import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
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

  static Future<Uint8List?> pickerImage(
      {required BuildContext context,
      double height = 400,
      double width = 600}) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          compressFormat: ImageCompressFormat.png,
          aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
          maxHeight: height.toInt(),
          maxWidth: width.toInt(),
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: true,
            ),
            IOSUiSettings(
              aspectRatioLockEnabled: true,
            ),
            WebUiSettings(
                context: context,
                size:
                    CropperSize(width: width.toInt(), height: height.toInt())),
          ],
        );

        if (croppedFile == null) return null;

        final bytes = await croppedFile.readAsBytes();
        final original = img.decodeImage(bytes)!;

        final resized = img.copyResize(
          original,
          width: width.toInt(),
          height: height.toInt(),
        );

        return Uint8List.fromList(img.encodePng(resized));
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  static Widget boldFirstName({
    required String name,
    required String fullName,
    String? graduation,
    TextStyle? normalStyle,
    TextStyle? boldStyle,
    TextAlign textAlign = TextAlign.start,
  }) {
    final normal = normalStyle ?? const TextStyle(fontSize: 16);
    final bold = boldStyle ?? normal.copyWith(fontWeight: FontWeight.bold);

    final rest = fullName.replaceFirst(name, '').trim();

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: (graduation == null) ? '' : "$graduation ",
              style: normal.copyWith(color: Colors.grey)),
          TextSpan(text: '$name ', style: bold),
          TextSpan(text: rest, style: normal),
        ],
      ),
      textAlign: textAlign,
    );
  }
}
