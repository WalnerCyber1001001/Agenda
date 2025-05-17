import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawMinuteMarkersSoft extends StatefulWidget {
  const AnalogClockDrawMinuteMarkersSoft({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawMinuteMarkersSoft> {

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
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    // Configuração dos Paints
    final gradientBrushMinutosSoft =
        _createGradientBrushMinutesSoft(center, radius);

    // Desenho das marcações
    _drawMinuteMarkersSoft(
        canvas, centerX, centerY, radius, gradientBrushMinutosSoft);
  }

  Paint _createGradientBrushMinutesSoft(Offset center, double radius) {
    return Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(0, 255, 255, 255).withOpacity(0.0),
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.06),
        ],
        stops: const [0.1, 0.9],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
  }

  // Desenha as marcações dos minutos sutis
  void _drawMinuteMarkersSoft(Canvas canvas, double centerX, double centerY,
      double radius, Paint gradientBrushMinutosSoft) {
    // Função para calcular o raio dos círculos dos marcadores de minutos
    double getMarkerRadius(double radius, double factor) {
      return radius * factor;
    }

    // Função para definir a espessura das linhas dos marcadores de minutos
    double getMarkerStrokeWidth(double radius) {
      return radius * 0.006; // ajuste o fator conforme necessário
    }

    // Ajusta os raios proporcionalmente ao tamanho do relógio
    final innerCircleRadiusMinutos =
        getMarkerRadius(radius, 0.2); // ajuste o fator conforme necessário
    final outerCircleRadiusMinutos =
        getMarkerRadius(radius, 0.78); // ajuste o fator conforme desejado

    // Define a espessura das linhas no Paint, baseada no radius
    gradientBrushMinutosSoft.strokeWidth = getMarkerStrokeWidth(radius);

    for (int i = 0; i < 360; i += 6) {
      final x1 = centerX + outerCircleRadiusMinutos * cos(i * pi / 180);
      final y1 = centerY + outerCircleRadiusMinutos * sin(i * pi / 180);
      final x2 = centerX + innerCircleRadiusMinutos * cos(i * pi / 180);
      final y2 = centerY + innerCircleRadiusMinutos * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), gradientBrushMinutosSoft);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
