import 'package:agenda/analog_clock/analog_clock_draw_cicle_of_dots/analog_clock_draw_cicle_of_dots_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_circle_border/analog_clock_draw_circle_border_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_clock_center/analog_clock_draw_clock_center_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_clock_hands/analog_clock_draw_clock_hands_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_clock_numbers/analog_clock_draw_clock_numbers_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_hour_inside_markers/analog_clock_draw_hour_inside_markers_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_hour_outside_markers/analog_clock_draw_hour_outside_markers_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_minute_markers_hard/analog_clock_draw_minute_markers_hard_widget.dart';
import 'package:agenda/analog_clock/analog_clock_draw_minute_markers_soft/analog_clock_draw_minute_markers_soft_widget.dart';
import 'package:agenda/app_bar_agenda_title/app_bar_agenda_title.dart';
import 'package:agenda/background_image/background_image_widget.dart';
import 'package:agenda/digital_clock/digital_clock_widget.dart';
import 'package:agenda/tasks/task_list_widget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required Null Function() onAddTask});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double clockSize = screenWidth * 0.96;
    double digitalClockSize = screenWidth * 0.6;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const AppBarAgendaTitle(),
      body: Stack(
        children: [
          // Fundo
          const BackgroundImageWidget(
            backgroundImagePath: 'assets/clock/fundoroxo.png',
          ),

          // Relógio Analógico
          /*Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockWidget(),
            ),
          ),*/

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawCircleOfDotskWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawCircleBorderWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawMinuteMarkersSoftWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawMinuteMarkersHardWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawHourOutsideMarkersWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawHourInsideMarkersWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawClockNumbersWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawClockHandsWidget(),
            ),
          ),

          Positioned(
            top: 78,
            left: (screenWidth - clockSize) / 2,
            child: SizedBox(
              width: clockSize,
              height: clockSize,
              child: const AnalogClockDrawClockCenterWidget(),
            ),
          ),

          // Relógio Digital
          Positioned(
            top: 92,
            left: (screenWidth - digitalClockSize) / 2,
            child: SizedBox(
              width: digitalClockSize,
              height: digitalClockSize,
              child: const DigitalClockWidget(
                isTwentyFourHourFormat: true,
              ),
            ),
          ),

          // Botão de Tarefas
          TaskListWidget(),
        ],
      ),
    );
  }
}
