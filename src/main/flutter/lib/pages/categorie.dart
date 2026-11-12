import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'menu.dart';
import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';
import '../widgets/ma_nav_bar.dart';
import '../widgets/tuile_lieu.dart';

/// Page dédiée à une catégorie de l'onglet Explorer (Tout, Plage, Randonnée...) :
/// la liste des lieux de la catégorie, lue dans l'API.
class CategoriePage extends StatefulWidget {
  final String categorie;

  /// Identifiant de la catégorie, `null` pour "Tout".
  final int? categorieId;

  const CategoriePage({super.key, required this.categorie, this.categorieId});

  @override
  State<CategoriePage> createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  final _service = LieuService();
  List<Lieu> _lieux = [];
  bool _chargement = true;
  String? _erreur;

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
      final lieux = await _service.rechercher(categorieId: widget.categorieId);
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.categorie)),
      body: _contenu(),
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

  Widget _contenu() {
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
      return const Center(child: Text('Aucun lieu dans cette catégorie.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _lieux.length,
      itemBuilder: (context, index) => TuileLieu(lieu: _lieux[index]),
    );
  }
}
