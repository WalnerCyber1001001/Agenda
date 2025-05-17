import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawCircle extends StatefulWidget {
  const AnalogClockDrawCircle({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawCircle> {

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

    _drawCircle(canvas, centerX, centerY, size, circleBrush);
  }

  // Métodos auxiliares para configuração de Paints e estilos
  Paint _createCircleBrush() => Paint()
    ..color = const Color.fromARGB(149, 255, 255, 255)
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0;

  void _drawCircle(Canvas canvas, double centerX, double centerY, Size size,
      Paint outlineBrush) {
    // Define o raio responsivo com base no centro e no menor lado
    final radius = min(centerX, centerY) * 0.706;

    // Define o retângulo que delimita o círculo
    final Rect rect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);

    // Configura o estilo e a cor do pincel para preenchimento
    outlineBrush
      ..color = const Color.fromARGB(255, 215, 0, 0) // Cor do preenchimento
      ..style = PaintingStyle.fill; // Preenche a fatia

    // Desenha a seção do círculo de 12h até 14h (do ângulo -90° até 30°)
    canvas.drawArc(
      rect,
      -pi / 2, // Ângulo inicial (12 horas, -90°)
      pi / 3, // Ângulo de abertura (60° equivalente a 2 horas no relógio)
      true, // Preenche o setor (true para fechar com o centro)
      outlineBrush,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
