import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'accueil.dart';
import 'explorer.dart';
import 'login.dart';
import '../widgets/ma_nav_bar.dart';

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
        RouteSansAnimation(builder: (_) => const LoginPage()),
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
