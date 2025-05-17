import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset(
              'assets/clock/fundoroxo.png', // Caminho da sua imagem
              fit: BoxFit.cover, // Faz a imagem cobrir todo o espaço
            ),
          ),
          // Conteúdo do menu
          Column(
            children: [
              // Cabeçalho do Menu
              const DrawerHeader(
                child: Center(
                  child: Text(
                    'MENU',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'CustomFont',
                      letterSpacing: 10.0,
                    ),
                  ),
                ),
              ),

              // Itens do Menu
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Início',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Configurações',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text(
                  'Sobre',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Fecha o menu
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
