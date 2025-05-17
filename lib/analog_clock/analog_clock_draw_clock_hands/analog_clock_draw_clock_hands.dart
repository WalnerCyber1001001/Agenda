import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockDrawClockHands extends StatefulWidget {
  const AnalogClockDrawClockHands({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClockDrawClockHands> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: Container(
            color: Colors.transparent, // Fundo transparente
            child: CustomPaint(
              painter: ClockPainter(),
            ),
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

    _drawClockHands(canvas, center, radius);
  }

  void _drawClockHands(Canvas canvas, Offset center, double radius) {
    final dateTime = DateTime.now();

    double getStrokeWidth(double radius, double factor) {
      return radius * factor;
    }

    double getHandLength(double radius, double factor) {
      return radius * factor;
    }

    final shadowBrush = Paint()
      ..color = const Color.fromARGB(255, 12, 0, 37).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = getStrokeWidth(radius, 0.024);

    final minuteHandBrush = Paint()
      ..color = const Color.fromARGB(200, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = getStrokeWidth(radius, 0.024);

    final hourHandBrush = Paint()
      ..color = const Color.fromARGB(200, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = getStrokeWidth(radius, 0.024);

    final secondHandBrush = Paint()
      ..color = const Color.fromARGB(210, 255, 40, 40)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = getStrokeWidth(radius, 0.015);

    final double hourHandLength = getHandLength(radius, 0.46);
    final double minuteHandLength = getHandLength(radius, 0.685);
    final double secondHandLength = getHandLength(radius, 0.892);

    final hourHandEnd = Offset(
      center.dx +
          hourHandLength *
              cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180 -
                  pi / 2),
      center.dy +
          hourHandLength *
              sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180 -
                  pi / 2),
    );
    final minuteHandEnd = Offset(
      center.dx +
          minuteHandLength * cos(dateTime.minute * 6 * pi / 180 - pi / 2),
      center.dy +
          minuteHandLength * sin(dateTime.minute * 6 * pi / 180 - pi / 2),
    );
    final secondHandEnd = Offset(
      center.dx +
          secondHandLength * cos(dateTime.second * 6 * pi / 180 - pi / 2),
      center.dy +
          secondHandLength * sin(dateTime.second * 6 * pi / 180 - pi / 2),
    );

    // Desenha as sombras
    canvas.drawLine(
        center.translate(3, 3), hourHandEnd.translate(2, 2), shadowBrush);
    canvas.drawLine(
        center.translate(3, 3), minuteHandEnd.translate(2, 2), shadowBrush);
    canvas.drawLine(
        center.translate(2, 2), secondHandEnd.translate(2, 2), shadowBrush);

    // Desenha os ponteiros principais
    canvas.drawLine(center, hourHandEnd, hourHandBrush);
    canvas.drawLine(center, minuteHandEnd, minuteHandBrush);
    canvas.drawLine(center, secondHandEnd, secondHandBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
