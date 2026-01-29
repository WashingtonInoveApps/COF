import 'dart:io';
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
      {double height = 400, double width = 600}) async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 2),
        uiSettings: [
          AndroidUiSettings(
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        final bytes = await croppedFile.readAsBytes();
        final original = img.decodeImage(bytes)!;

        final resized = img.copyResize(
          original,
          width: width.toInt(),
          height: height.toInt(),
        );

        final result = File("${croppedFile.path}_600x400.png")
          ..writeAsBytesSync(img.encodePng(resized));
        return await result.readAsBytes();
      }
    }

    return null;
  }
}
