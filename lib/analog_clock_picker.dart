import 'package:flutter/material.dart';
import 'dart:math';

class AnalogClockPicker extends StatefulWidget {
  const AnalogClockPicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockPickerState createState() => _AnalogClockPickerState();
}

class _AnalogClockPickerState extends State<AnalogClockPicker> {
  double hourAngle = 0.0; // Ângulo da hora
  double minuteAngle = 0.0; // Ângulo do minuto
  double secondAngle = 0.0;
  double radius = 100.0; // Raio do relógio (tamanho)

  void _onPanUpdate(DragUpdateDetails details, bool isHour) {
    final offset = details.localPosition;
    final angle = atan2(offset.dy - radius, offset.dx - radius);
    setState(() {
      if (isHour) {
        hourAngle = angle % (2 * pi);
      } else {
        minuteAngle = angle % (2 * pi);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) =>
              _onPanUpdate(details, true), // Arrastar para ajustar a hora
          child: GestureDetector(
            onPanUpdate: (details) => _onPanUpdate(
                details, false), // Arrastar para ajustar os minutos
            child: CustomPaint(
              size: const Size(250, 250),
              painter: AnalogClockPainter(hourAngle, minuteAngle, secondAngle),
            ),
          ),
        ),
      ),
    );
  }
}

class AnalogClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Desenha os marcadores
    _drawMarkers(canvas, center, radius);

    // Desenha os ponteiros
    _drawClockHands(canvas, center, radius);
  }

  final double hourAngle;
  final double minuteAngle;
  final double secondAngle;

  AnalogClockPainter(this.hourAngle, this.minuteAngle, this.secondAngle);

  // Função para criar o gradiente para os marcadores das horas externas
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

  // Função para calcular o strokeWidth com base no radius
  double _getStrokeWidth(double radius, double factor) {
    return radius * factor;
  }

  // Função para calcular o comprimento dos ponteiros com base no radius
  double _getHandLength(double radius, double factor) {
    return radius * factor;
  }

  // Função para desenhar o ponteiro (hora, minuto ou segundo)
  void _drawHand(
      Canvas canvas, Offset center, double angle, double length, Paint brush) {
    final end = Offset(
      center.dx + length * cos(angle),
      center.dy + length * sin(angle),
    );
    canvas.drawLine(center, end, brush);
  }

  // Função para desenhar todos os ponteiros do relógio
  void _drawClockHands(Canvas canvas, Offset center, double radius) {
    // Configuração para os pinceis dos ponteiros com sombra
    final shadowBrush = Paint()
      ..color = const Color.fromARGB(255, 12, 0, 37).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _getStrokeWidth(radius, 0.024);

    final minuteHandBrush = Paint()
      ..color = const Color.fromARGB(200, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _getStrokeWidth(radius, 0.024);

    final hourHandBrush = Paint()
      ..color = const Color.fromARGB(200, 255, 255, 255)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _getStrokeWidth(radius, 0.024);

    final secondHandBrush = Paint()
      ..color = const Color.fromARGB(210, 255, 40, 40)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _getStrokeWidth(radius, 0.015);

    // Calcula o comprimento dos ponteiros
    final double hourHandLength = _getHandLength(radius, 0.46);
    final double minuteHandLength = _getHandLength(radius, 0.685);
    final double secondHandLength = _getHandLength(radius, 0.892);

    // Calcula as posições finais dos ponteiros (sem o uso de DateTime)
    final hourHandEnd = Offset(
      center.dx + hourHandLength * cos(hourAngle),
      center.dy + hourHandLength * sin(hourAngle),
    );
    final minuteHandEnd = Offset(
      center.dx + minuteHandLength * cos(minuteAngle),
      center.dy + minuteHandLength * sin(minuteAngle),
    );
    final secondHandEnd = Offset(
      center.dx + secondHandLength * cos(minuteAngle),
      center.dy + secondHandLength * sin(minuteAngle),
    );

    // Desenha as sombras ligeiramente deslocadas
    canvas.drawLine(
        center.translate(3, 3), hourHandEnd.translate(2, 2), shadowBrush);
    canvas.drawLine(
        center.translate(3, 3), minuteHandEnd.translate(2, 2), shadowBrush);
    canvas.drawLine(
        center.translate(2, 2), secondHandEnd.translate(2, 2), shadowBrush);

    // Desenha os ponteiros principais
    _drawHand(canvas, center, hourAngle, hourHandLength, hourHandBrush);
    _drawHand(canvas, center, minuteAngle, minuteHandLength, minuteHandBrush);
    _drawHand(canvas, center, secondAngle, secondHandLength, secondHandBrush);
  }

  // Função para desenhar os marcadores de hora
  void _drawMarkers(Canvas canvas, Offset center, double radius) {
    final gradientBrushHoursOutside =
        _createGradientBrushHourOutside(center, radius);

    // Função para calcular o raio dos círculos dos marcadores externos
    double getMarkerRadius(double radius, double factor) {
      return radius * factor;
    }

    // Função para definir a espessura das linhas dos marcadores
    double getMarkerStrokeWidth(double radius) {
      return radius * 0.0135; // ajuste o fator conforme necessário
    }

    final innerCircleRadiusFora = getMarkerRadius(radius, 0.946);
    final outerCircleRadiusFora = getMarkerRadius(radius, 1.00);

    // Define a espessura das linhas no Paint, baseada no radius
    final shadowBrush = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1)
      ..strokeWidth = getMarkerStrokeWidth(radius)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.01);

    // Desenha os marcadores externos com sombra
    for (int i = 0; i < 360; i += 30) {
      final angle = i * pi / 180;

      // Coordenadas da linha original
      final x1 = center.dx + outerCircleRadiusFora * cos(angle);
      final y1 = center.dy + outerCircleRadiusFora * sin(angle);
      final x2 = center.dx + innerCircleRadiusFora * cos(angle);
      final y2 = center.dy + innerCircleRadiusFora * sin(angle);

      // Deslocamento para a sombra
      final shadowOffset = Offset(radius * 0, radius * 0.014);

      // Desenha a linha da sombra
      canvas.drawLine(
        Offset(x1, y1) + shadowOffset,
        Offset(x2, y2) + shadowOffset,
        shadowBrush,
      );

      // Desenha a linha original com o gradiente
      canvas.drawLine(
          Offset(x1, y1), Offset(x2, y2), gradientBrushHoursOutside);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
