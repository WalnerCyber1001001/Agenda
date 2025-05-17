import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
    final circleBrush = _createCircleBrush();
    final gradientBrushMinutosSoft =_createGradientBrushMinutesSoft(center, radius);
    final gradientBrushMinutosHard =_createGradientBrushMinutesHard(center, radius);
    final gradientBrushHoursOutside =_createGradientBrushHourOutside(center, radius);
    final gradientBrushHoursInside = _createGradientBrushInside(center, radius);
    final textStyle = _createTextStyle(radius);

    // Círculo em pontinhos
    _drawCircleOfDots(canvas, centerX, centerY, radius, circleBrush);
    _drawCircleBorder(canvas, centerX, centerY, size, circleBrush);

    // Desenho das marcações
    _drawMinuteMarkersSoft(canvas, centerX, centerY, radius, gradientBrushMinutosSoft);
    _drawMinuteMarkersHard(canvas, centerX, centerY, radius, gradientBrushMinutosHard);
    _drawHourOutsideMarkers(canvas, centerX, centerY, radius, gradientBrushHoursOutside);
    _drawHourInsideMarkers(canvas, centerX, centerY, radius, gradientBrushHoursInside, 1);

    // Desenha os números do relógio
    _drawClockNumbers(canvas, centerX, centerY, radius, textStyle);

    // Desenha os ponteiros e o centro do relógio
    _drawClockHands(canvas, center, radius);
    _drawClockCenter(canvas, center, radius);
  }

  // Métodos auxiliares para configuração de Paints e estilos
  Paint _createCircleBrush() => Paint()
    ..color = const Color.fromARGB(149, 255, 255, 255)
    ..style = PaintingStyle.fill
    ..strokeWidth = 1.0;

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

  Paint _createGradientBrushMinutesHard(Offset center, double radius) {
    return Paint()
      ..shader = RadialGradient(
        colors: [
          const Color.fromARGB(0, 255, 255, 255).withOpacity(0.1),
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
        ],
        stops: const [0.1, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
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

  TextStyle _createTextStyle(double radius) {
    return const TextStyle(
      color: Color.fromARGB(255, 255, 255, 255),
      fontWeight: FontWeight.normal,
      fontFamily: 'CustomFont',
    );
  }

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

  // Desenha as marcações dos minutos fortes
  void _drawMinuteMarkersHard(Canvas canvas, double centerX, double centerY,
      double radius, Paint gradientBrushMinutosHard) {
    // Função para calcular o raio dos círculos dos marcadores de minutos
    double getMarkerRadius(double radius, double factor) {
      return radius * factor;
    }

    // Função para definir a espessura das linhas dos marcadores de minutos
    double getMarkerStrokeWidth(double radius) {
      return radius * 0.006; // ajuste o fator conforme necessário
    }

    final innerCircleRadiusMinutos =
        getMarkerRadius(radius, 0.81); // ajuste o fator conforme necessário
    final outerCircleRadiusMinutos =
        getMarkerRadius(radius, 0.772); // ajuste o fator conforme necessário

    // Define a espessura das linhas no Paint, baseada no radius
    gradientBrushMinutosHard.strokeWidth = getMarkerStrokeWidth(radius);

    for (int i = 0; i < 360; i += 6) {
      final x1 = centerX + outerCircleRadiusMinutos * cos(i * pi / 180);
      final y1 = centerY + outerCircleRadiusMinutos * sin(i * pi / 180);
      final x2 = centerX + innerCircleRadiusMinutos * cos(i * pi / 180);
      final y2 = centerY + innerCircleRadiusMinutos * sin(i * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), gradientBrushMinutosHard);
    }
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

  // Desenha os ponteiros do relógio
  void _drawClockHands(Canvas canvas, Offset center, double radius) {
    final dateTime = DateTime.now();

    // Função para calcular o strokeWidth com base no radius
    double getStrokeWidth(double radius, double factor) {
      return radius * factor;
    }

    // Função para calcular o comprimento dos ponteiros com base no radius
    double getHandLength(double radius, double factor) {
      return radius * factor;
    }

    // Configuração para os pinceis dos ponteiros com sombra
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

    // Calcula o comprimento dos ponteiros
    final double hourHandLength = getHandLength(radius, 0.46);
    final double minuteHandLength = getHandLength(radius, 0.685);
    final double secondHandLength = getHandLength(radius, 0.892);

    // Calcula as posições finais dos ponteiros (com sombra)
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

    // Desenha as sombras ligeiramente deslocadas
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

  // Desenha os números do relógio
  void _drawClockNumbers(Canvas canvas, double centerX, double centerY,
      double radius, TextStyle baseTextStyle) {
    final numberCircleRadius = radius * 0.85;

    for (int i = 1; i <= 12; i++) {
      // Ângulo ajustado para posicionar o número 12 no topo
      final angle = ((i - 3) * 30) * (pi / 180);

      final numberCircleX = centerX + numberCircleRadius * cos(angle);
      final numberCircleY = centerY + numberCircleRadius * sin(angle);

      final responsiveTextStyle = baseTextStyle.copyWith(
        fontSize: radius * 0.078,
        fontWeight: FontWeight.w100,
      );

      // Desenho da sombra
      final shadowTextStyle = responsiveTextStyle.copyWith(
        color: Colors.black.withOpacity(0.05), // Cor e opacidade da sombra
      );

      final shadowPainter = TextPainter(
        text: TextSpan(text: i.toString(), style: shadowTextStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      shadowPainter.layout();
      shadowPainter.paint(
        canvas,
        Offset(
          numberCircleX -
              shadowPainter.width / 2 +
              -2, // Deslocamento da sombra
          numberCircleY - shadowPainter.height / 2 + 4,
        ),
      );

      // Desenho do número principal
      final textPainter = TextPainter(
        text: TextSpan(text: i.toString(), style: responsiveTextStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          numberCircleX - textPainter.width / 2,
          numberCircleY - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
