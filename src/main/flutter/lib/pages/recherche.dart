import 'package:flutter/material.dart';

import '../models/categorie.dart';
import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';
import '../widgets/tuile_lieu.dart';

/// Recherche de lieux par nom, avec des filtres par categorie et par province (exigence M3).
/// Ouverte depuis la barre de recherche ou les categories de l'accueil.
class RecherchePage extends StatefulWidget {
  final String recherche;
  final int? categorieId;

  const RecherchePage({super.key, this.recherche = '', this.categorieId});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  final _service = LieuService();
  late final _rechercheController = TextEditingController(text: widget.recherche);

  List<Categorie> _categories = [];
  late int? _categorieId = widget.categorieId;
  String? _province;

  List<Lieu> _lieux = [];
  bool _chargement = true;
  String? _erreur;

  @override
  void initState() {
    super.initState();
    _chargerCategories();
    _rechercher();
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    _service.fermer();
    super.dispose();
  }

  Future<void> _chargerCategories() async {
    try {
      final categories = await _service.categories();
      if (mounted) setState(() => _categories = categories);
    } on ApiException {
      // Sans categories, la liste des lieux s'affiche quand meme.
    }
  }

  Future<void> _rechercher() async {
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final lieux = await _service.rechercher(
        recherche: _rechercheController.text,
        categorieId: _categorieId,
        province: _province,
      );
      if (!mounted) return;
      setState(() {
        _lieux = lieux;
        _chargement = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erreur = e.message;
        _chargement = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // La liste deroulante n'affiche une categorie que lorsqu'elle est chargee
    final categorieAffichee =
        _categories.any((c) => c.id == _categorieId) ? _categorieId : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher un lieu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _rechercheController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Nom du lieu',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _rechercher(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<int?>(
                    isExpanded: true,
                    value: categorieAffichee,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Toutes catégories')),
                      for (final categorie in _categories)
                        DropdownMenuItem(value: categorie.id, child: Text(categorie.libelle)),
                    ],
                    onChanged: (valeur) {
                      setState(() => _categorieId = valeur);
                      _rechercher();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    value: _province,
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Toutes provinces')),
                      for (final province in provinces.entries)
                        DropdownMenuItem(value: province.key, child: Text(province.value)),
                    ],
                    onChanged: (valeur) {
                      setState(() => _province = valeur);
                      _rechercher();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _resultats()),
        ],
      ),
    );
  }

  Widget _resultats() {
    if (_chargement) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erreur != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_erreur!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_lieux.isEmpty) {
      return const Center(child: Text('Aucun lieu ne correspond à votre recherche.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _lieux.length,
      itemBuilder: (context, index) => TuileLieu(lieu: _lieux[index]),
    );
  }
}
