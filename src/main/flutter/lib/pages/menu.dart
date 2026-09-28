import 'package:flutter/material.dart';
import 'accueil.dart';
import 'explorer.dart';
import 'login.dart';
import 'profil.dart';
import '../widgets/ma_nav_bar.dart';

// PS: ce fichier et le fichier ma_nav_bar.dart son utiliser pour la bare de navigation en bas de l'écran,
// qui permet de naviguer entre les différentes pages de l'application.

class Menu extends StatefulWidget {
  final int indexInitial;

  const Menu({
    super.key,
    this.indexInitial = 0,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int _ongletActif;

  static const _pages = [
    Accueil(),     // Index 0
    Explorer(),    // Index 1
    LoginPage(),   // Index 2
    ProfilPage(),  // Index 3
  ];

  @override
  void initState() {
    super.initState();
    _ongletActif = widget.indexInitial;
  }

  void _changerOnglet(int index) {
    setState(() => _ongletActif = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_ongletActif],
      bottomNavigationBar: MaNavBar(
        selectedIndex: _ongletActif,
        onDestinationSelected: _changerOnglet,
      ),
    );
  }
}