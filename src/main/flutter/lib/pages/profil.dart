import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'admin_lieux.dart';
import '../models/compte.dart';
import '../services/api_exception.dart';
import '../services/compte_service.dart';
import '../services/session.dart';

/// Onglet "Mon compte" quand un membre est connecté : ses données (droits RGPD
/// d'accès, de rectification et d'effacement), relues et enregistrées par l'API.
class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isEditable = false;

  final _service = CompteService();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final _ancienController = TextEditingController();
  final _nouveauController = TextEditingController();
  final _confirmationController = TextEditingController();
  Compte? _compte;

  static const _rouge = Color.fromARGB(255, 255, 56, 92);

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _dateController.dispose();
    _ancienController.dispose();
    _nouveauController.dispose();
    _confirmationController.dispose();
    _service.fermer();
    super.dispose();
  }

  void _afficher(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Droit d'accès : les données du compte viennent de l'API.
  Future<void> _charger() async {
    try {
      final compte = await _service.consulter();
      if (!mounted) return;
      setState(() {
        _compte = compte;
        _emailController.text = compte.email;
        _dateController.text = compte.dateAffichee;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      _afficher(e.message);
    }
  }

  /// Premier appui : l'e-mail devient modifiable. Second appui : il est enregistré.
  Future<void> _modifierProfil() async {
    final compte = _compte;
    if (!isEditable || compte == null) {
      setState(() => isEditable = !isEditable);
      return;
    }
    try {
      final misAJour = await _service.modifier(nom: compte.nom, email: _emailController.text.trim());
      Session.instance.mettreAJour(misAJour.versUtilisateur());
      if (!mounted) return;
      setState(() {
        _compte = misAJour;
        isEditable = false;
      });
      _afficher('Profil enregistré.');
    } on ApiException catch (e) {
      if (!mounted) return;
      _afficher(e.message);
    }
  }

  Future<void> _modifierMotDePasse() async {
    final ancien = _ancienController.text;
    final nouveau = _nouveauController.text;
    if (ancien.isEmpty || nouveau.isEmpty) {
      _afficher('Veuillez remplir tous les champs.');
      return;
    }
    if (nouveau != _confirmationController.text) {
      _afficher('Les mots de passe ne correspondent pas.');
      return;
    }
    try {
      await _service.changerMotDePasse(ancien: ancien, nouveau: nouveau);
      _ancienController.clear();
      _nouveauController.clear();
      _confirmationController.clear();
      if (!mounted) return;
      _afficher('Mot de passe modifié.');
    } on ApiException catch (e) {
      if (!mounted) return;
      _afficher(e.message);
    }
  }

  /// Droit à l'effacement : demande une confirmation, puis supprime le compte.
  Future<void> _supprimerCompte() async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer mon compte ?'),
        content: const Text('Votre compte et vos favoris seront supprimés. '
            'Vos avis resteront visibles, sans votre nom.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirme != true) return;
    try {
      await _service.supprimer();
      if (!mounted) return;
      _afficher('Compte supprimé.');
      Session.instance.fermer();
    } on ApiException catch (e) {
      if (!mounted) return;
      _afficher(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Défilement : avec le clavier ouvert, tous les champs ne tiennent pas à l'écran
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              TextField(
                controller: _emailController,
                enabled: isEditable,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  // texte quand c'est désactivé
                  color: isEditable ? Colors.black : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Votre email',
                  border: const OutlineInputBorder(),

                  // Style de la bordure quand le champ est ACTIF (isEditable = true)
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54),
                  ),

                  // Style de la bordure quand le champ est DÉSACTIVÉ (isEditable = false)
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                enabled: false,
                style: const TextStyle(
                  color: Colors.black87, // Même couleur de texte que le 1er champ en mode désactivé
                ),
                decoration: InputDecoration(
                  labelText: 'Date inscription',
                  labelStyle: const TextStyle(
                    color: Colors.black54, // Garde le libellé lisible malgré enabled: false
                  ),

                  // Bordure appliquée lorsque le champ est désactivé (enabled: false)
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400, // Même couleur de bordure que le 1er
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rouge,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
                ),
                onPressed: _modifierProfil,
                child: Text(
                  isEditable ? 'Enregistrer' : 'Modifier le profil',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Agrandit aussi le texte
                ),
              ),

              const SizedBox(height: 5),
              const Divider(
                color: Colors.grey, // Couleur de la barre
                thickness: 1,       // Épaisseur du trait en pixels
                height: 32,         // Espace vertical total occupé par le widget (marges haut/bas incluses)
              ),

              const SizedBox(height: 8),
              TextField(
                controller: _ancienController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Ancien mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: _nouveauController,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),
              TextField(
                controller: _confirmationController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmez le mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _rouge,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                ),
                onPressed: _modifierMotDePasse,
                child: const Text(
                  'Modifier le mot de passe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Administration des lieux : visible seulement pour le compte ADMIN (M7)
              if (Session.instance.estAdmin) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _rouge,
                    side: const BorderSide(color: _rouge),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.admin_panel_settings),
                  label: const Text('Administration des lieux'),
                  onPressed: () => Navigator.push(
                    context,
                    RouteSansAnimation(builder: (_) => const AdminLieuxPage()),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: Session.instance.fermer,
                    child: const Text('Se déconnecter', style: TextStyle(color: _rouge)),
                  ),
                  TextButton(
                    onPressed: _supprimerCompte,
                    child: const Text('Supprimer mon compte', style: TextStyle(color: Colors.black54)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
