import 'package:flutter/material.dart';

import '../models/categorie.dart';
import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';

/// Formulaire d'ajout ou de modification d'un lieu (administrateur, exigence M7).
/// Les contrôles reprennent ceux de l'API (LieuRequete) : l'utilisateur voit
/// l'erreur tout de suite, et l'API refait la vérification de son côté.
class LieuFormPage extends StatefulWidget {
  /// Lieu à modifier, `null` pour un ajout.
  final Lieu? lieu;

  const LieuFormPage({super.key, this.lieu});

  @override
  State<LieuFormPage> createState() => _LieuFormPageState();
}

class _LieuFormPageState extends State<LieuFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = LieuService();

  late final _nomController = TextEditingController(text: widget.lieu?.nom);
  late final _descriptionController = TextEditingController(text: widget.lieu?.description);
  late final _latitudeController = TextEditingController(text: widget.lieu?.latitude.toString());
  late final _longitudeController = TextEditingController(text: widget.lieu?.longitude.toString());

  List<Categorie> _categories = [];
  late int? _categorieId = widget.lieu?.categorie?.id;
  late String? _province = widget.lieu?.province;
  bool _enregistrement = false;
  AutovalidateMode _verificationContinue = AutovalidateMode.disabled;

  static const _rouge = Color.fromARGB(255, 255, 56, 92);

  @override
  void initState() {
    super.initState();
    _chargerCategories();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _service.fermer();
    super.dispose();
  }

  Future<void> _chargerCategories() async {
    try {
      final categories = await _service.categories();
      if (mounted) setState(() => _categories = categories);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Accepte la virgule comme séparateur décimal : -22,27 ou -22.27.
  double? _nombre(String texte) => double.tryParse(texte.trim().replaceAll(',', '.'));

  /// Vérifie qu'une coordonnée est un nombre compris dans les limites de la Nouvelle-Calédonie.
  /// Message court : le champ ne fait que la moitié de la largeur de l'écran.
  String? _verifierCoordonnee(String? texte, double min, double max, String nom) {
    final valeur = _nombre(texte ?? '');
    if (valeur == null) return 'La $nom est obligatoire';
    if (valeur < min || valeur > max) {
      return 'Entre ${_enFrancais(min)} et ${_enFrancais(max)} (Nouvelle-Calédonie)';
    }
    return null;
  }

  /// -18.5 devient « -18,5 » et -24.0 devient « -24 », comme dans les messages de l'API.
  String _enFrancais(double valeur) =>
      (valeur % 1 == 0 ? valeur.toInt().toString() : valeur.toString()).replaceAll('.', ',');

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) {
      // Après un premier essai refusé, les erreurs se mettent à jour pendant la saisie
      setState(() => _verificationContinue = AutovalidateMode.onUserInteraction);
      return;
    }
    final donnees = {
      'nom': _nomController.text.trim(),
      'description': _descriptionController.text.trim(),
      'province': _province,
      'latitude': _nombre(_latitudeController.text),
      'longitude': _nombre(_longitudeController.text),
      'categorieId': _categorieId,
    };
    setState(() => _enregistrement = true);
    try {
      final lieu = widget.lieu;
      if (lieu == null) {
        await _service.creer(donnees);
      } else {
        await _service.modifier(lieu.id, donnees);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lieu enregistré.')));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _enregistrement = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // La liste déroulante n'affiche la catégorie du lieu qu'une fois les catégories chargées
    final categorieAffichee = _categories.any((c) => c.id == _categorieId) ? _categorieId : null;

    return Scaffold(
      appBar: AppBar(title: Text(widget.lieu == null ? 'Ajouter un lieu' : 'Modifier le lieu')),
      body: Form(
        key: _formKey,
        autovalidateMode: _verificationContinue,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _nomController,
              maxLength: 150,
              decoration: const InputDecoration(labelText: 'Nom du lieu', border: OutlineInputBorder()),
              validator: (texte) =>
                  (texte == null || texte.trim().isEmpty) ? 'Le nom est obligatoire' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLength: 2000,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              // La clé change quand les catégories arrivent : le champ reprend alors la valeur initiale
              key: ValueKey(_categories.length),
              initialValue: categorieAffichee,
              decoration: const InputDecoration(labelText: 'Catégorie', border: OutlineInputBorder()),
              items: [
                for (final categorie in _categories)
                  DropdownMenuItem(value: categorie.id, child: Text(categorie.libelle)),
              ],
              onChanged: (valeur) => setState(() => _categorieId = valeur),
              validator: (valeur) => valeur == null ? 'La catégorie est obligatoire' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: provinces.containsKey(_province) ? _province : null,
              decoration: const InputDecoration(labelText: 'Province', border: OutlineInputBorder()),
              items: [
                for (final province in provinces.entries)
                  DropdownMenuItem(value: province.key, child: Text(province.value)),
              ],
              onChanged: (valeur) => setState(() => _province = valeur),
              validator: (valeur) => valeur == null ? 'La province est obligatoire' : null,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                      labelText: 'Latitude',
                      hintText: '-22.27',
                      border: OutlineInputBorder(),
                      errorMaxLines: 3,
                    ),
                    validator: (texte) => _verifierCoordonnee(texte, -24, -18.5, 'latitude'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    decoration: const InputDecoration(
                      labelText: 'Longitude',
                      hintText: '166.45',
                      border: OutlineInputBorder(),
                      errorMaxLines: 3,
                    ),
                    validator: (texte) => _verifierCoordonnee(texte, 163, 169, 'longitude'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rouge,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                ),
                onPressed: _enregistrement ? null : _enregistrer,
                child: const Text('Enregistrer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
