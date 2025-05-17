import 'package:agenda/digital_clock/digital_clock.dart';
import 'package:flutter/material.dart';

class DigitalClockWidget extends StatelessWidget {
  final bool isTwentyFourHourFormat;

  const DigitalClockWidget({super.key, required this.isTwentyFourHourFormat});

  @override
  Widget build(BuildContext context) {
    // Obtendo a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;

    // Definindo o tamanho do relógio digital como uma porcentagem da largura da tela
    double clockSize = screenWidth * 0.1;

    return Center(
      child: AspectRatio(
        aspectRatio: 2, // Mantém a proporção de 1:1 (quadrado)
        child: Container(
          width: clockSize,
          height: clockSize,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 10,
            ),
          ),
          child: DigitalClock(onTwentyFourOrTwelvy: isTwentyFourHourFormat),
        ),
      ),
    );
  }
}
