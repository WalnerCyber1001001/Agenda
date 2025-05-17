import 'package:flutter/material.dart';
import 'dart:ui';

class BlurEffect extends StatefulWidget {
  const BlurEffect({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BlurEffectState createState() => _BlurEffectState();
}

class _BlurEffectState extends State<BlurEffect> {
  bool isBlurActive = BlurManager.isBlurActive;

  @override
  void initState() {
    super.initState();
    // Registra o callback global para escutar mudanças no BlurManager
    BlurManager.setOnBlurChanged(_onBlurStatusChanged);
  }

  void _onBlurStatusChanged() {
    // Usar addPostFrameCallback para garantir que setState será chamado após a construção
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          isBlurActive = BlurManager.isBlurActive;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define o desfoque como ativo
    BlurManager.setBlurActive(true);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: const Padding(
          padding: EdgeInsets.all(0.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    BlurManager.setOnBlurChanged(() => {}); // Limpa o callback
    super.dispose();
  }
}

class BlurManager with ChangeNotifier {
  static bool isBlurActive = false;
  static VoidCallback? onBlurChanged;

  static void setBlurActive(bool isActive) {
    isBlurActive = isActive;
    onBlurChanged?.call(); // Chama o callback global sempre que o status mudar
  }

  static bool getBlurStatus(bool bool) {
    return isBlurActive;
  }

  static void setOnBlurChanged(VoidCallback callback) {
    onBlurChanged = callback;
  }
}