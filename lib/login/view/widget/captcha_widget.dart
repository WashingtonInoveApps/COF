import 'dart:math';
import 'package:bsu_control/core/constants.dart';
import 'package:flutter/material.dart';

class CaptchaWidget extends StatelessWidget {
  final String code;
  const CaptchaWidget({Key? key, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 45,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          border: Border.all(color: Constants.primary, strokeAlign: 2),
          borderRadius: BorderRadius.circular(5)),
      child: CustomPaint(
        painter: CaptchaPainter(code),
      ),
    );
  }
}

class CaptchaPainter extends CustomPainter {
  CaptchaPainter(this.code);

  final String code;
  final Random _random = Random.secure();

  @override
  void paint(Canvas canvas, Size size) {
    // Fundo
    final backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.shade100;

    // canvas.drawRRect(
    //   RRect.fromRectAndRadius(
    //     Rect.fromLTWH(
    //       0,
    //       0,
    //       size.width,
    //       size.height,
    //     ),
    //     const Radius.circular(6),
    //   ),
    //   backgroundPaint,
    // );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Offset.zero & size,
        const Radius.circular(6),
      ),
      backgroundPaint,
    );

    // ------------------------------------------------------------
    // Ruído: pequenos pontos
    // ------------------------------------------------------------

    final noisePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.green.withValues(alpha: 1);

    for (int i = 0; i < 35; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;

      final radius = 0.4 + _random.nextDouble() * 0.8;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        noisePaint,
      );
    }

    // ------------------------------------------------------------
    // Linhas de interferência
    // ------------------------------------------------------------

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.green.shade500.withValues(alpha: 0.45);

    for (int i = 0; i < 3; i++) {
      final path = Path();

      final startY = 8 + _random.nextDouble() * 20;

      path.moveTo(
        0,
        startY,
      );

      path.cubicTo(
        size.width * 0.20,
        _random.nextDouble() * size.height,
        size.width * 0.65,
        _random.nextDouble() * size.height,
        size.width + 10,
        _random.nextDouble() * size.height,
      );

      canvas.drawPath(path, linePaint);
    }

    // ------------------------------------------------------------
    // Caracteres
    // ------------------------------------------------------------

    if (code.isEmpty) return;

    final characters = code.split('');

    const double characterWidth = 20;
    const double startX = 8;

    for (int i = 0; i < characters.length; i++) {
      final character = characters[i];

      canvas.save();

      // Pequena variação horizontal
      final x =
          startX + (i * characterWidth) + (_random.nextDouble() * 3 - 1.5);

      // Pequena variação vertical
      final y = 5 + (_random.nextDouble() * 7);

      // Rotação entre aproximadamente -12° e +12°
      final angle = (_random.nextDouble() - 0.5) * 0.42;

      // Tamanho entre 23 e 27
      final fontSize = 20 + _random.nextDouble() * 2;

      canvas.translate(x, y);
      canvas.rotate(angle);

      final textPainter = TextPainter(
        text: TextSpan(
          text: character,
          style: Constants.title.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
            color: Constants.primary,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset.zero,
      );

      canvas.restore();
    }

    // ------------------------------------------------------------
    // Segunda camada de ruído - pequenas linhas
    // ------------------------------------------------------------

    final smallLinePaint = Paint()
      ..strokeWidth = 0.5
      ..color = Colors.grey.shade600.withValues(alpha: 0.35);

    for (int i = 0; i < 8; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;

      canvas.drawLine(
        Offset(x, y),
        Offset(
          x + 3 + _random.nextDouble() * 5,
          y + (_random.nextDouble() * 4 - 2),
        ),
        smallLinePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CaptchaPainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:math';

// import 'package:bsu_control/core/constants.dart';
// import 'package:flutter/material.dart';

// class CaptchaWidget extends StatelessWidget {
//   final String code;

//   const CaptchaWidget({
//     Key? key,
//     required this.code,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade600),
//         borderRadius: BorderRadius.circular(5),
//         color: Colors.blue.shade100,
//       ),
//       padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
//       child: CustomPaint(
//         painter: CaptchaPainter(code),
//         size: const Size(150, 45),
//       ),
//     );
//   }
// }

// class CaptchaPainter extends CustomPainter {
//   final String code;

//   CaptchaPainter(this.code);

//   final random = Random();

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint();

//     for (int i = 0; i < code.length; i++) {
//       final char = code[i];

//       canvas.save();

//       final x = 15 + (i * 20.0);
//       final y = 15 + random.nextDouble() * 20;

//       canvas.translate(x, y);

//       final angle = (random.nextDouble() - 0.5) * 0.5;

//       canvas.rotate(angle);

//       final textPainter = TextPainter(
//         text: TextSpan(
//           text: char,
//           style: Constants.title.copyWith(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         textDirection: TextDirection.ltr,
//       );

//       textPainter.layout();

//       textPainter.paint(canvas, Offset.zero);

//       canvas.restore();
//     }

//     // Linhas de interferência
//     for (int i = 0; i < 5; i++) {
//       paint
//         ..strokeWidth = 1
//         ..style = PaintingStyle.stroke;

//       final path = Path();

//       path.moveTo(
//         random.nextDouble() * size.width,
//         random.nextDouble() * size.height,
//       );

//       path.quadraticBezierTo(
//         random.nextDouble() * size.width,
//         random.nextDouble() * size.height,
//         random.nextDouble() * size.width,
//         random.nextDouble() * size.height,
//       );

//       canvas.drawPath(path, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
