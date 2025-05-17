import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawCircleOfDots extends StatefulWidget {
  const AnalogClockDrawCircleOfDots({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawCircleOfDots> {

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
    final circleBrush = _createCircleBrush();

    // Círculo em pontinhos
    _drawCircleOfDots(canvas, centerX, centerY, radius, circleBrush);
  }

  // Métodos auxiliares para configuração de Paints e estilos
  Paint _createCircleBrush() => Paint()
    ..color = const Color.fromARGB(149, 255, 255, 255)
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0;

  // Desenha um círculo de pontinhos
  void _drawCircleOfDots(Canvas canvas, double centerX, double centerY,
      double radius, Paint dashBrush) {
    // Função para definir o comprimento do traço com base no radius
    double getDashSize(double radius) {
      return radius * 0.005; // Fator ajustável para o comprimento do traço
    }

    // Define o comprimento e a espessura dos tracinhos
    final dashSize = getDashSize(radius);
    dashBrush.strokeWidth = radius * 0.01; // Configura a largura dos tracinhos

    // Configura o raio do círculo para os tracinhos
    double circleRadius = radius * 0.7;

    for (int i = 0; i < 360; i += 2) {
      // Calcula pontos inicial e final do traço
      final x1 = centerX + circleRadius * cos(i * pi / 180);
      final y1 = centerY + circleRadius * sin(i * pi / 180);
      final x2 = centerX + (circleRadius + dashSize) * cos(i * pi / 180);
      final y2 = centerY + (circleRadius + dashSize) * sin(i * pi / 180);

      // Desenha o traço
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
