import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'menu.dart';
import 'login.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/session.dart';

class RegisterPage extends StatefulWidget {

  final AuthService? authService;

  const RegisterPage({super.key, this.authService});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _enCours = false; // Empêche un double envoi pendant l'appel à l'API

  late final _authService = widget.authService ?? AuthService();

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationController.dispose();
    if (widget.authService == null) _authService.fermer();
    super.dispose();
  }

  void _afficher(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _creerCompte() async {
    final nom = _nomController.text.trim();
    final email = _emailController.text.trim();
    final motDePasse = _passwordController.text;

    // Vérifications locales avant d'appeler l'API
    if (nom.isEmpty || email.isEmpty || motDePasse.isEmpty) {
      _afficher('Veuillez remplir tous les champs.');
      return;
    }
    if (!email.contains('@')) {
      _afficher('Adresse e-mail invalide.');
      return;
    }
    if (motDePasse != _confirmationController.text) {
      _afficher('Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() => _enCours = true);
    try {
      final resultat = await _authService.inscription(
        nom: nom,
        email: email,
        motDePasse: motDePasse,
      );
      // Compte créé : le nouveau membre est connecté directement
      Session.instance.ouvrir(token: resultat.token,
          utilisateur: resultat.utilisateur);

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, RouteSansAnimation(
          builder: (context) => const Menu()), (route) => false);
    } on ApiException catch (e) {
      if (!mounted) return;
      _afficher(e.message);
    } finally {
      if (mounted) setState(() => _enCours = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Défilement : avec le clavier ouvert, les 4 champs ne tiennent pas à l'écran
      body: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text('NOUVEAU CLIENT ?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),

            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Pseudo',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Adresse e-mail',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _confirmationController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmer le mot de passe',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 28),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
              ),
              onPressed: _enCours ? null : _creerCompte,
              child: const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Agrandit aussi le texte
              ),
            ),

            const SizedBox(height: 28),
            const Divider(
              color: Colors.grey, // Couleur de la barre
              thickness: 1,       // Épaisseur du trait en pixels
              height: 32,         // Espace vertical total occupé par le widget (marges haut/bas incluses)
            ),

            const Text('Déjà client ?', style: TextStyle(fontSize: 28, color: Color.fromARGB(255, 255, 56, 92))),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92), // La couleur du fond
                foregroundColor: Colors.white, // La couleur du texte et de l'icône
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
              ),
              onPressed: () {
                // logique de connexion
                Navigator.pushReplacement(
                    context,
                    RouteSansAnimation(builder: (context) => const LoginPage()));
              },
              child: const Text(
                'Se connecter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ))
    );
  }
}