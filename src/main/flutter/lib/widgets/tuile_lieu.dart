import 'package:flutter/material.dart';

import '../models/lieu.dart';
import '../pages/lieu.dart';
import 'route_sans_animation.dart';

/// Un lieu dans une liste (recherche, page d'une categorie) : le toucher ouvre sa fiche.
/// Meme presentation que les encadres de l'onglet Explorer.
class TuileLieu extends StatelessWidget {
  final Lieu lieu;

  const TuileLieu({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
    final categorie = lieu.categorie?.libelle;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: const Icon(Icons.place, color: Color.fromARGB(255, 255, 56, 92)),
        title: Text(lieu.nom),
        subtitle: Text(categorie == null ? lieu.provinceLibelle : '${lieu.provinceLibelle} · $categorie'),
        onTap: () => Navigator.push(
          context,
          RouteSansAnimation(builder: (_) => LieuPage(lieu: lieu)),
        ),
      ),
    );
  }
}
