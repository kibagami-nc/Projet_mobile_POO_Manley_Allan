import 'package:flutter/material.dart';

import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';
import '../widgets/route_sans_animation.dart';
import 'lieu_form.dart';

/// Administration des lieux (exigence M7) : ajouter, modifier et supprimer.
/// Ouverte depuis le profil, seulement pour le compte ADMIN ; l'API refuse
/// de toute façon ces actions sans jeton administrateur (403).
class AdminLieuxPage extends StatefulWidget {
  const AdminLieuxPage({super.key});

  @override
  State<AdminLieuxPage> createState() => _AdminLieuxPageState();
}

class _AdminLieuxPageState extends State<AdminLieuxPage> {
  final _service = LieuService();

  List<Lieu> _lieux = [];
  bool _chargement = true;
  String? _erreur;

  static const _rouge = Color.fromARGB(255, 255, 56, 92);

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
    setState(() {
      _chargement = true;
      _erreur = null;
    });
    try {
      final lieux = await _service.rechercher();
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

  /// Ouvre le formulaire (vide pour un ajout) et recharge la liste après un enregistrement.
  Future<void> _ouvrirFormulaire([Lieu? lieu]) async {
    final enregistre = await Navigator.push<bool>(
      context,
      RouteSansAnimation(builder: (_) => LieuFormPage(lieu: lieu)),
    );
    if (enregistre == true) _charger();
  }

  Future<void> _supprimer(Lieu lieu) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce lieu ?'),
        // La base supprime aussi ses photos, ses avis et les favoris (ON DELETE CASCADE)
        content: Text('« ${lieu.nom} » sera supprimé, avec ses photos, ses avis et les favoris.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirme != true) return;
    try {
      await _service.supprimer(lieu.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('« ${lieu.nom} » a été supprimé.')));
      _charger();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administration des lieux')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _rouge,
        foregroundColor: Colors.white,
        tooltip: 'Ajouter un lieu',
        onPressed: _ouvrirFormulaire,
        child: const Icon(Icons.add),
      ),
      body: _liste(),
    );
  }

  Widget _liste() {
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
      return const Center(child: Text('Aucun lieu pour le moment.'));
    }
    return ListView.builder(
      // Marge du bas : le bouton "+" ne cache pas le dernier lieu
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      itemCount: _lieux.length,
      itemBuilder: (context, index) {
        final lieu = _lieux[index];
        final categorie = lieu.categorie?.libelle;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: ListTile(
            visualDensity: VisualDensity.compact,
            contentPadding: const EdgeInsets.only(left: 12, right: 4),
            leading: const Icon(Icons.place, color: _rouge),
            title: Text(lieu.nom),
            subtitle: Text(categorie == null ? lieu.provinceLibelle : '${lieu.provinceLibelle} · $categorie'),
            onTap: () => _ouvrirFormulaire(lieu),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Modifier',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _ouvrirFormulaire(lieu),
                ),
                IconButton(
                  tooltip: 'Supprimer',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _supprimer(lieu),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
