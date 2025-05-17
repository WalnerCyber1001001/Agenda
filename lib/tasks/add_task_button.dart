import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTaskButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 190,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 54.0,
          height: 54.0,
          child: RawMaterialButton(
            onPressed: onPressed,
            fillColor: const Color.fromARGB(26, 239, 220, 251),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            elevation: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/clock/crossicon.png',
                width: 54.0,
                height: 54.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
