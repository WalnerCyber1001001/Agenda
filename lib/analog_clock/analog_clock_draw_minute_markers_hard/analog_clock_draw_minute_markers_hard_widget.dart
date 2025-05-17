import 'package:agenda/analog_clock/analog_clock_draw_minute_markers_hard/analog_clock_draw_minute_markers_hard.dart';
import 'package:flutter/material.dart';

class AnalogClockDrawMinuteMarkersHardWidget extends StatelessWidget {
  const AnalogClockDrawMinuteMarkersHardWidget({super.key});

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
          child: const AnalogClockDrawMinuteMarkersHard(),
        ),
      ),
    );
  }
}
