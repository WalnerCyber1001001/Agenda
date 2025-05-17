import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawClockNumbers extends StatefulWidget {
  const AnalogClockDrawClockNumbers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawClockNumbers> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: ClockPainter(),
          ),
        );
      },
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY);

    // Configuração dos Paints
    final textStyle = _createTextStyle(radius);

    // Desenha os números do relógio
    _drawClockNumbers(canvas, centerX, centerY, radius, textStyle);
  }

  TextStyle _createTextStyle(double radius) {
    return const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.normal,
      fontFamily: 'CustomFont',
    );
  }

  // Desenha os números do relógio
  void _drawClockNumbers(Canvas canvas, double centerX, double centerY,
      double radius, TextStyle baseTextStyle) {
    final numberCircleRadius = radius * 0.85;

    for (int i = 1; i <= 12; i++) {
      // Ângulo ajustado para posicionar o número 12 no topo
      final angle = ((i - 3) * 30) * (pi / 180);

      final numberCircleX = centerX + numberCircleRadius * cos(angle);
      final numberCircleY = centerY + numberCircleRadius * sin(angle);

      final responsiveTextStyle = baseTextStyle.copyWith(
        fontSize: radius * 0.078,
        fontWeight: FontWeight.w100,
      );

      // Desenho da sombra
      final shadowTextStyle = responsiveTextStyle.copyWith(
        color: Colors.black.withOpacity(0.05), // Cor e opacidade da sombra
      );

      final shadowPainter = TextPainter(
        text: TextSpan(text: i.toString(), style: shadowTextStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      shadowPainter.layout();
      shadowPainter.paint(
        canvas,
        Offset(
          numberCircleX -
              shadowPainter.width / 2 +
              -2, // Deslocamento da sombra
          numberCircleY - shadowPainter.height / 2 + 4,
        ),
      );

      // Desenho do número principal
      final textPainter = TextPainter(
        text: TextSpan(text: i.toString(), style: responsiveTextStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          numberCircleX - textPainter.width / 2,
          numberCircleY - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}