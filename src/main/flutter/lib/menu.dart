import 'package:flutter/material.dart';
import 'accueil.dart';
import 'explorer.dart';
import 'login.dart';

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

  @override
  void initState() {
    super.initState();
    _ongletActif = widget.indexInitial;
  }

  static const _pages = [
    Accueil(),
    Explorer(),
  ];

  void _changerOnglet(int index) {
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
      bottomNavigationBar: MaNavBar(
        selectedIndex: _ongletActif,
        onDestinationSelected: _changerOnglet,
      ),
    );
  }
}

/// Widget réutilisable dans d'autres vues comme LoginPage
class MaNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const MaNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: Duration.zero,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
        NavigationDestination(icon: Icon(Icons.explore), label: 'Explorer'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}