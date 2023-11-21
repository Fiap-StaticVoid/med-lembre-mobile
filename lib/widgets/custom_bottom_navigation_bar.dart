import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex; // Adicionado o parâmetro currentIndex
  final Function(int) onItemTapped; // Adicionado o parâmetro onItemTapped

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // Configuração para mais de 3 itens
      currentIndex: widget.currentIndex, // Usando o currentIndex do widget
      onTap: widget.onItemTapped, // Usando o onItemTapped do widget
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Histórico'  
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}