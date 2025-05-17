import 'package:agenda/analog_clock_picker.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class TimerEventPopin {
  static void timereventpopin(BuildContext context,
      {Color backgroundColor = const Color.fromARGB(10, 253, 247, 253)}) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent, // Permite visualizar o blur
      barrierDismissible: false, // Evita fechamento ao clicar fora
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        double width = screenWidth * 0.96; // 96% da largura da tela
        double height = screenHeight * 0.8; // 80% da altura da tela
        double clockSize = screenWidth * 0.7;

        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop(); // Fecha ao pressionar voltar
            return false;
          },
          child: Stack(
            children: [
              // Efeito Blur no fundo
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9.0, sigmaY: 9.0),
                child: Container(
                  color: const Color.fromARGB(255, 13, 7, 18).withOpacity(0.8),
                ),
              ),
              GestureDetector(
                onTap: () {}, // Evita fechar ao tocar dentro do popup
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Hora do Evento',
                            style: TextStyle(
                              color: Color.fromARGB(190, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: clockSize,
                            height: clockSize,
                            child: const AnalogClockPicker(),
                          ),
                          
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Fechar',
                              style: TextStyle(
                                color: Color.fromARGB(190, 255, 255, 255),
                                fontSize: 16,
                                letterSpacing: 1.0,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Color.fromARGB(100, 255, 255, 255),
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
