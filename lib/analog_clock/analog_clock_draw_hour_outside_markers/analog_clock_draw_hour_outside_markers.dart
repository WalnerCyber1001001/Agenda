import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawHourOutsideMarkers extends StatefulWidget {
  const AnalogClockDrawHourOutsideMarkers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawHourOutsideMarkers> {

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

    final gradientBrushHoursOutside = _createGradientBrushHourOutside(center, radius);

    _drawHourOutsideMarkers(
        canvas, centerX, centerY, radius, gradientBrushHoursOutside);
  }

  Paint _createGradientBrushHourOutside(Offset center, double radius) {
    return Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.03),
          const Color.fromARGB(0, 255, 255, 255).withOpacity(0.9),
        ],
        stops: const [0.92, 0.92],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
  }

  // Desenha as marcações de fora das horas
  void _drawHourOutsideMarkers(Canvas canvas, double centerX, double centerY,
      double radius, Paint gradientBrushHoursOutside) {
    // Função para calcular o raio dos círculos dos marcadores externos
    double getMarkerRadius(double radius, double factor) {
      return radius * factor;
    }

    // Função para definir a espessura das linhas dos marcadores
    double getMarkerStrokeWidth(double radius) {
      return radius * 0.0135; // ajuste o fator conforme necessário
    }

    final innerCircleRadiusFora =
        getMarkerRadius(radius, 0.946); // ajusta o fator conforme desejado
    final outerCircleRadiusFora =
        getMarkerRadius(radius, 1.00); // ajusta o fator conforme desejado

    // Define a espessura das linhas no Paint, baseada no radius
    gradientBrushHoursOutside.strokeWidth = getMarkerStrokeWidth(radius);

    // Definindo o Paint para a sombra
    final shadowBrush = Paint()
      ..color = Colors.black.withOpacity(0.1) // Cor e opacidade da sombra
      ..strokeWidth =
          getMarkerStrokeWidth(radius) // Mesmo espessura da linha original
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, radius * 0.01); // Aplica um leve desfoque

    // Desenha os marcadores externos com sombra
    for (int i = 0; i < 360; i += 30) {
      final angle = i * pi / 180;

      // Coordenadas da linha original
      final x1 = centerX + outerCircleRadiusFora * cos(angle);
      final y1 = centerY + outerCircleRadiusFora * sin(angle);
      final x2 = centerX + innerCircleRadiusFora * cos(angle);
      final y2 = centerY + innerCircleRadiusFora * sin(angle);

      // Deslocamento para a sombra (ligeiramente deslocada para baixo e direita)
      final shadowOffset = Offset(radius * 0, radius * 0.014);

      // Desenha a linha da sombra antes da linha principal
      canvas.drawLine(
        Offset(x1, y1) + shadowOffset,
        Offset(x2, y2) + shadowOffset,
        shadowBrush,
      );

      // Desenha a linha original
      canvas.drawLine(
          Offset(x1, y1), Offset(x2, y2), gradientBrushHoursOutside);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
