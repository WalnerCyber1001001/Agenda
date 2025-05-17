import 'dart:async';
import 'package:flutter/material.dart';

class DigitalClock extends StatefulWidget {
  final bool onTwentyFourOrTwelvy; // Parâmetro para escolher o formato de hora

  const DigitalClock({super.key, required this.onTwentyFourOrTwelvy});

  @override
  // ignore: library_private_types_in_public_api
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double baseSize = screenWidth < screenHeight ? screenWidth : screenHeight;

    double timeFontSize = baseSize * 0.084;
    double periodFontSize = baseSize * 0.03;
    double secondsFontSize = baseSize * 0.03;
    double timeLetterSpacing = baseSize * 0.014;
    double periodLetterSpacing = baseSize * 0.004;
    double secondsLetterSpacing = baseSize * 0.004;

    // Calcula a hora no formato correto
    int hour = widget.onTwentyFourOrTwelvy
        ? _currentTime.hour
        : (_currentTime.hour % 12 == 0 ? 12 : _currentTime.hour % 12);

    // Calcula o período (AM/PM)
    String period = _currentTime.hour < 12 ? "AM" : "PM";

    // Formata o horário principal
    String formattedTime =
        "${hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}";
    String seconds = _currentTime.second.toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            // AM/PM
            Align(
              alignment: const Alignment(0.0, -0.5),
              child: Text(
                period, // Exibe sempre o AM/PM
                style: TextStyle(
                  fontSize: periodFontSize,
                  color: const Color.fromARGB(186, 255, 255, 255),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'CustomFont',
                  letterSpacing: periodLetterSpacing,
                ),
              ),
            ),
            // Clock
            Align(
              alignment: const Alignment(0, -0.0),
              child: Text(
                formattedTime,
                style: TextStyle(
                  fontSize: timeFontSize,
                  color: const Color.fromARGB(221, 255, 255, 255),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'CustomFont',
                  letterSpacing: timeLetterSpacing,
                ),
              ),
            ),
            // Seconds
            Align(
              alignment: const Alignment(0.0, 0.44),
              child: Text(
                seconds,
                style: TextStyle(
                  fontSize: secondsFontSize,
                  color: const Color.fromARGB(186, 255, 255, 255),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'CustomFont',
                  letterSpacing: secondsLetterSpacing,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
