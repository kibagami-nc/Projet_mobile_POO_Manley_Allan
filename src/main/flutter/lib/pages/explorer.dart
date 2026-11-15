import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'categorie.dart';
import 'lieu.dart';
import '../models/categorie.dart';
import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';

/// Onglet Explorer : lieux les plus visités et catégories de lieux enregistrés.
/// Les lieux et les catégories viennent de l'API.
class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  final _service = LieuService();
  List<Lieu> _lieux = [];
  List<Categorie> _categories = [];

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _service.fermer();
    super.dispose();
  }

  Future<void> _charger() async {
    try {
      final lieux = await _service.rechercher();
      final categories = await _service.categories();
      if (!mounted) return;
      setState(() {
        _lieux = lieux;
        _categories = categories;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Ouvre la page dédiée à la catégorie touchée ("Tout" : categorieId null).
  void _ouvrirCategorie(BuildContext context, String categorie, int? categorieId) {
    Navigator.push(
      context,
      RouteSansAnimation(
        builder: (_) => CategoriePage(categorie: categorie, categorieId: categorieId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // "Tout" puis les catégories de la base
    final cases = <(String, int?)>[
      ('Tout', null),
      for (final categorie in _categories) (categorie.libelle, categorie.id),
    ];

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
          // Liste des lieux, défilable, entre le titre et les cases.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _lieux.length,
              itemBuilder: (context, index) {
                final lieu = _lieux[index];
                return Card(
                  // Encadrés plus compacts, sans changer la taille du texte.
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    visualDensity: VisualDensity.compact,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12),
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(lieu.nom),
                    subtitle: Text('${lieu.provinceLibelle} · ${lieu.description}'),
                    onTap: () => Navigator.push(
                      context,
                      RouteSansAnimation(builder: (_) => LieuPage(lieu: lieu)),
                    ),
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
          for (final (libelle, categorieId) in cases) ...[
            const Divider(height: 1),
            ListTile(
              title: Text(libelle, textAlign: TextAlign.center),
              titleTextStyle: Theme.of(context).textTheme.titleMedium,
              minTileHeight: 80,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              onTap: () => _ouvrirCategorie(context, libelle, categorieId),
            ),
          ],
        ],
      ),
    );
  }
}
