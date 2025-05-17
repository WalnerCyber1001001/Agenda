import 'dart:math';
import 'package:flutter/material.dart';

class AngleSelector extends StatefulWidget {
  const AngleSelector({super.key});

  @override
  State<AngleSelector> createState() => _AngleSelectorState();
}

class _AngleSelectorState extends State<AngleSelector> {
  double startAngle = -pi / 2; // Começa às 12 horas (-90°)
  double endAngle = pi / 2;    // Termina às 6 horas (90°)
  bool isDraggingStart = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double size = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: GestureDetector(
            onPanStart: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset localPosition = box.globalToLocal(details.globalPosition);

              double dx = localPosition.dx - (size / 2);
              double dy = localPosition.dy - (size / 2);
              double angle = atan2(dy, dx);

              double startDistance = (angle - startAngle).abs();
              double endDistance = (angle - endAngle).abs();

              isDraggingStart = startDistance < endDistance;
            },
            onPanUpdate: (details) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset localPosition = box.globalToLocal(details.globalPosition);

              setState(() {
                double dx = localPosition.dx - (size / 2);
                double dy = localPosition.dy - (size / 2);
                double angle = atan2(dy, dx);

                // Arredonda para o minuto mais próximo
                angle = roundToNearestMinute(angle);

                if (isDraggingStart) {
                  // Move livremente o ponteiro inicial, mas não ultrapasse o final no sentido horário
                  if ((endAngle - angle + 2 * pi) % (2 * pi) > 0.01) {
                    startAngle = angle;
                  }
                } else {
                  // Move livremente o ponteiro final, mas não ultrapasse o inicial no sentido anti-horário
                  if ((angle - startAngle + 2 * pi) % (2 * pi) > 0.01) {
                    endAngle = angle;
                  }
                }

                // Ajuste os ângulos para garantir que estejam no intervalo de -pi a pi
                startAngle = normalizeAngle(startAngle);
                endAngle = normalizeAngle(endAngle);
              });
            },
            child: CustomPaint(
              painter: AnglePainter(startAngle, endAngle),
            ),
          ),
        );
      },
    );
  }

  // Função para normalizar os ângulos no intervalo de -pi a pi
  double normalizeAngle(double angle) {
    while (angle < -pi) {
      angle += 2 * pi;
    }
    while (angle > pi) {
      angle -= 2 * pi;
    }
    return angle;
  }

  // Função para arredondar o ângulo para o minuto mais próximo
  double roundToNearestMinute(double angle) {
    double minute = (angle + pi) * 30 / pi; // Converte ângulo para minutos
    minute = (minute.round() % 60).toDouble(); // Arredonda para o minuto mais próximo
    return (minute * pi / 30) - pi; // Converte de volta para ângulo
  }
}

class AnglePainter extends CustomPainter {
  final double startAngle;
  final double endAngle;

  AnglePainter(this.startAngle, this.endAngle);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY) * 0.656;

    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint arcBrush = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color.fromARGB(255, 202, 30, 30),
          Color.fromARGB(255, 255, 60, 60),
        ],
        center: Alignment.center,
        radius: 0.7,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    // Desenha o arco entre os ângulos selecionados
    canvas.drawArc(
      rect,
      startAngle,
      (endAngle - startAngle + 2 * pi) % (2 * pi),
      true,
      arcBrush,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
