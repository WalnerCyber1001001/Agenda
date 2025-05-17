import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  final String backgroundImagePath;

  const BackgroundImageWidget({
    super.key,
    required this.backgroundImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImagePath),
          fit: BoxFit.cover, // Preenche toda a tela
        ),
      ),
    );
  }
}
