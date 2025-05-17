import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawClockCenter extends StatefulWidget {
  const AnalogClockDrawClockCenter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawClockCenter> {

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
 
    // Desenha centro do relógio
    _drawClockCenter(canvas, center, radius);
  }
  
  // Desenha o centro do relógio
  void _drawClockCenter(Canvas canvas, Offset center, double radius) {
    // Função para calcular o raio dos círculos centrais com base no radius
    double getCenterCircleRadius(double radius, double factor) {
      return radius * factor;
    }

    final centerFillBrush = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255);

    final centerFillBrushDois = Paint()
      ..color = const Color.fromARGB(255, 255, 40, 40);

    // Sombra do círculo central
    final shadowBrush = Paint()
      ..color =
          Colors.black.withOpacity(0.1) // Define a cor e a opacidade da sombra
      ..maskFilter = MaskFilter.blur(
          BlurStyle.normal, radius * 0.008); // Aplica desfoque à sombra

    // Calcula os raios dos círculos centrais com fatores proporcionais ao tamanho do relógio
    final double shadowCircleRadius =
        getCenterCircleRadius(radius, 0.03); // Círculo sombra levemente maior
    final double outerCircleRadius =
        getCenterCircleRadius(radius, 0.0245); // Círculo externo
    final double innerCircleRadius =
        getCenterCircleRadius(radius, 0.010); // Círculo interno

    // Desenha a sombra antes dos círculos principais
    canvas.drawCircle(center, shadowCircleRadius, shadowBrush);

    // Desenha os círculos principais
    canvas.drawCircle(center, outerCircleRadius, centerFillBrush);
    canvas.drawCircle(center, innerCircleRadius, centerFillBrushDois);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
