import 'package:flutter/material.dart';

class NonInteractiveItem extends StatelessWidget {
  final double height;

  const NonInteractiveItem({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(40, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
      ),
      /*child: const Center(
        child: Text(
          'Item não interativo',
          style: TextStyle(
            color: Color.fromARGB(190, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontFamily: 'CustomFont',
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color.fromARGB(130, 255, 255, 255),
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),*/
    );
  }
}