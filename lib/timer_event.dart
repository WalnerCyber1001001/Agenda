import 'package:flutter/material.dart';

class TimerEventController {
  /// Exibe apenas o seletor de tempo com fundo personalizado
  Future<void> selectTime(BuildContext context) async {
    await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color.fromARGB(8, 255, 255, 255), // Fundo do seletor
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
