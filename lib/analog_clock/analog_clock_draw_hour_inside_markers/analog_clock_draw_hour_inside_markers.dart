import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawHourInsideMarkers extends StatefulWidget {
  const AnalogClockDrawHourInsideMarkers({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawHourInsideMarkers> {

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
    final gradientBrushHoursInside = _createGradientBrushInside(center, radius);

    _drawHourInsideMarkers(
        canvas, centerX, centerY, radius, gradientBrushHoursInside, 1);
  }

  Paint _createGradientBrushInside(Offset center, double radius) {
    return Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(0, 255, 255, 255).withOpacity(0.01),
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        ],
        stops: const [0.08, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
  }

  // Desenha as marcações de dentro das horas
  void _drawHourInsideMarkers(Canvas canvas, double centerX, double centerY,
      double radius, Paint gradientBrushHoursInside, double markerLength) {
    // Função para calcular o raio dos círculos dos marcadores internos
    double getMarkerRadius(double radius, double factor) {
      return radius * factor;
    }

    final innerCircleRadiusFora =
        getMarkerRadius(radius, 0.0); // ajusta o fator conforme desejado
    final outerCircleRadiusFora =
        getMarkerRadius(radius, 0.0); // ajusta o fator conforme desejado

    // Tamanho do triângulo proporcional ao tamanho do relógio
    double triangleBase =
        radius * 0.008; // base do triângulo proporcional ao raio
    double triangleHeight =
        radius * 0.81; // altura do triângulo proporcional ao raio

    for (int i = 0; i < 360; i += 30) {
      // Calculando as coordenadas para o triângulo
      final angle = i * pi / 180;

      // Ponto onde o triângulo começa (parte da linha interna)
      final x2 = centerX + innerCircleRadiusFora * cos(angle);
      final y2 = centerY + innerCircleRadiusFora * sin(angle);

      // Ponto no final da linha, ajustável pela variável markerLength
      final x1 = centerX + outerCircleRadiusFora * cos(angle);
      final y1 = centerY + outerCircleRadiusFora * sin(angle);

      // Calculando a posição da base do triângulo e suas extremidades
      final triangleStartX = x2 + triangleHeight * cos(angle);
      final triangleStartY = y2 + triangleHeight * sin(angle);

      final triangleLeftX = triangleStartX + triangleBase / 2 * sin(angle);
      final triangleLeftY = triangleStartY - triangleBase / 2 * cos(angle);

      final triangleRightX = triangleStartX - triangleBase / 2 * sin(angle);
      final triangleRightY = triangleStartY + triangleBase / 2 * cos(angle);

      // Criando o caminho para o triângulo
      final path = Path()
        ..moveTo(x2, y2) // Ponto onde o marcador começa
        ..lineTo(triangleLeftX, triangleLeftY)
        ..lineTo(triangleRightX, triangleRightY)
        ..close();

      // Desenhando o marcador
      canvas.drawPath(path, gradientBrushHoursInside);

      // Desenhando a linha do centro até o círculo externo
      canvas.drawLine(
          Offset(centerX, centerY), Offset(x1, y1), gradientBrushHoursInside);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
