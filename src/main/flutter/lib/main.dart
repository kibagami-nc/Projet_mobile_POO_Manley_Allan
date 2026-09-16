import 'package:flutter/material.dart';

import 'accueil.dart';
import 'explorer.dart';
import 'login.dart';

void main() {
  runApp(const MonApp());
}

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Menu());
  }
}

/// Menu du bas : affiche la page correspondant à l'onglet sélectionné.
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _ongletActif = 0;

  // Une page par onglet, dans le même ordre que les destinations ci-dessous.
  static const _pages = [
    Accueil(),
    Explorer(),
  ];

  void _changerOnglet(int index) {
    // L'onglet "Profil" ouvre la page de connexion par-dessus le menu.
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }
    setState(() => _ongletActif = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_ongletActif],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _ongletActif,
        onDestinationSelected: _changerOnglet,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explorer'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class Carte extends StatelessWidget {
  const Carte({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-21.3, 165.5),
        initialZoom: 7,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.poo_mobile_front',
        ),
      ],
    );
  }
}
