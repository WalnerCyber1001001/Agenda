import 'package:flutter/material.dart';

class AppBarAgendaTitle extends StatelessWidget implements PreferredSizeWidget {
  const AppBarAgendaTitle({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtendo a largura da tela
    double screenWidth = MediaQuery.of(context).size.width;

    // Ajuste do tamanho do título com base na largura da tela
    double titleFontSize = screenWidth * 0.08; // Ajuste conforme necessário

    return PreferredSize(
      preferredSize: Size.fromHeight(screenWidth * 0.25), // Altura dinâmica
      child: Container(
        decoration: AppBarDecoration(),
        padding: EdgeInsets.only(
            top: screenWidth * 0.098), // Ajuste o topo baseado na tela
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const MenuButton(),
            Expanded(child: AppBarTitle(fontSize: titleFontSize)),
            const PlaceholderSpace(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class AppBarDecoration extends BoxDecoration {
  AppBarDecoration()
      : super(
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 1.8,
            colors: [
              Color.fromARGB(17, 255, 255, 255),
              Color.fromARGB(1, 255, 255, 255),
            ],
            stops: [0.0, 1.5],
          ),
          boxShadow: [
            const BoxShadow(
              blurRadius: 6,
              color: Color.fromARGB(80, 12, 6, 22),
              offset: Offset(0, 4),
            ),
          ],
        );
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Ajustando a posição do ícone
    double screenWidth = MediaQuery.of(context).size.width;
    return Transform.translate(
      offset: Offset(
          0, -screenWidth * 0), // Ajusta para que o ícone suba conforme a tela
      child: Transform.scale(
        scaleY: 1.62, // Aumenta a altura do ícone
        scaleX: 1.22, // Mantém a largura
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Efeito de glow (brilho)
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3), // Cor do brilho
                    blurRadius: 10, // Intensidade do brilho
                    spreadRadius: 1, // Tamanho do brilho
                  ),
                ],
              ),
            ),
            // Ícone principal
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color.fromARGB(190, 255, 255, 255),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre o menu lateral
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final double fontSize;
  const AppBarTitle({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'AGENDA',
        style: TextStyle(
          color: const Color.fromARGB(240, 255, 255, 255),
          fontSize: fontSize, // Tamanho do texto ajustado dinamicamente
          fontWeight: FontWeight.w100,
          fontFamily: 'CustomFont',
          letterSpacing: 16.4,
          shadows: const [
            Shadow(
              blurRadius: 10,
              color: Color.fromARGB(160, 255, 255, 255),
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderSpace extends StatelessWidget {
  const PlaceholderSpace({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
        width:
            screenWidth * 0.12); // Adapta o espaço com base na largura da tela
  }
}
