import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'menu.dart';
import '../widgets/ma_nav_bar.dart';

/// Page dédiée à une catégorie de l'onglet Explorer (Tout, Lieux, ...).
class CategoriePage extends StatelessWidget {
  final String categorie;

  const CategoriePage({super.key, required this.categorie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categorie)),
      // Contenu de la catégorie (à compléter).
      body: Center(
        child: Text(
          categorie,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      bottomNavigationBar: MaNavBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          Navigator.pushAndRemoveUntil(
            context,
            RouteSansAnimation(builder: (context) => Menu(indexInitial: index)),
            (route) => false,
          );
        },
      ),
    );
  }
}
