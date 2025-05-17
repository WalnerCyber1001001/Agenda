import 'package:agenda/background_image/background_image_widget.dart';
import 'package:agenda/my_home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Função para simular um tempo de carregamento (2 segundos)
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  void _navigateToHomePage() {
    Future.delayed(const Duration(seconds: 0), () {
      // Após o tempo de carregamento, navegamos para a página principal
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            onAddTask: () {},
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          BackgroundImageWidget(
            backgroundImagePath: 'assets/clock/fundoroxo.png',
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  color: Color.fromARGB(202, 240, 224, 255),
                ), // Animação de carregamento
                SizedBox(height: 20),
                Text(
                  'CARREGANDO',
                  style: TextStyle(
                    color: Color.fromARGB(230, 255, 255, 255),
                    fontSize: 24, // Aumenta o tamanho do texto na vertical
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                    letterSpacing: 8,
                    height:
                        1.0, // Ajusta o espaço vertical entre as linhas de texto
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
