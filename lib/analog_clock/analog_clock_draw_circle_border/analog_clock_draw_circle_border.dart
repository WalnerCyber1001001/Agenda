import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawCircleBorder extends StatefulWidget {
  const AnalogClockDrawCircleBorder({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawCircleBorder> {

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

    // Configuração dos Paints
    final circleBrush = _createCircleBrush();

    _drawCircleBorder(canvas, centerX, centerY, size, circleBrush);
  }

  // Métodos auxiliares para configuração de Paints e estilos
  Paint _createCircleBrush() => Paint()
    ..color = const Color.fromARGB(149, 255, 255, 255)
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0;

  void _drawCircleBorder(Canvas canvas, double centerX, double centerY,
      Size size, Paint outlineBrush) {
    // Define o raio responsivo com base no centro e no menor lado
    final radius = min(centerX, centerY) * 0.9;

    // Configura o estilo e a cor do pincel para a borda
    outlineBrush
      ..color = const Color.fromARGB(10, 138, 138, 138)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6; // Largura da borda

    // Desenha apenas a borda do círculo
    canvas.drawCircle(Offset(centerX, centerY), radius, outlineBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
