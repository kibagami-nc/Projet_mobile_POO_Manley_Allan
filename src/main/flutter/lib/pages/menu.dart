import 'package:flutter/material.dart';
import 'accueil.dart';
import 'explorer.dart';
import 'login.dart';
import 'profil.dart';
import '../services/session.dart';
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

  Widget _page(int index) => switch (index) {
        0 => const Accueil(),
        1 => const Explorer(),
        // Onglet "Mon compte" : la connexion, ou le profil quand un membre est connecté
        _ => Session.instance.estConnecte ? const ProfilPage() : const LoginPage(),
      };

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
      // Redessiné à la connexion et à la déconnexion
      body: ListenableBuilder(
        listenable: Session.instance,
        builder: (context, _) => _page(_ongletActif),
      ),
      bottomNavigationBar: MaNavBar(
        selectedIndex: _ongletActif,
        onDestinationSelected: _changerOnglet,
      ),
    );
  }
}