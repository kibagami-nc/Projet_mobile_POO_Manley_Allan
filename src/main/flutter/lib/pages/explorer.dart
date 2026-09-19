import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'categorie.dart';
import '../models/categories.dart';
import '../models/lieu.dart';

/// Onglet Explorer : lieux les plus visités et catégories de lieux enregistrés.
class Explorer extends StatelessWidget {
  const Explorer({super.key});

  /// Ouvre la page dédiée à la catégorie touchée.
  void _ouvrirCategorie(BuildContext context, String categorie) {
    Navigator.push(
      context,
      RouteSansAnimation(builder: (_) => CategoriePage(categorie: categorie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Titre de la section, en haut de l'écran.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Les lieux les plus visités',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          // Liste des favoris, défilable, entre le titre et les cases.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: lieuxFavoris.length,
              itemBuilder: (context, index) {
                final lieu = lieuxFavoris[index];
                return Card(
                  // Encadrés plus compacts, sans changer la taille du texte.
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(lieu.nom),
                    subtitle: Text('${lieu.province} · ${lieu.description}'),
                  ),
                );
              },
            ),
          ),
          // Titre des catégories, juste au-dessus des cases.
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Vos lieux enregistrés',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          for (final categorie in categories) ...[
            const Divider(height: 1),
            ListTile(
              title: Text(categorie, textAlign: TextAlign.center),
              titleTextStyle: Theme.of(context).textTheme.titleMedium,
              minTileHeight: 80,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              onTap: () => _ouvrirCategorie(context, categorie),
            ),
          ],
        ],
      ),
    );
  }
}
