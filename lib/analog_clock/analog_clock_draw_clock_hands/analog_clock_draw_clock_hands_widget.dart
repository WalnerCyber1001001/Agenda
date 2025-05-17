import 'package:agenda/analog_clock/analog_clock_draw_clock_hands/analog_clock_draw_clock_hands.dart';
import 'package:flutter/material.dart';

class AnalogClockDrawClockHandsWidget extends StatelessWidget {
  const AnalogClockDrawClockHandsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Definindo o tamanho como uma porcentagem da largura da tela
    double sizeWidth = screenWidth * 0.4;
    double sizeHeight = screenHeight * 0.4;

    return SizedBox(
      width: sizeWidth,
      height: sizeHeight,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 12,
            ),
          ),
          child: const AnalogClockDrawClockHands(),
        ),
      ),
    );
  }
}
