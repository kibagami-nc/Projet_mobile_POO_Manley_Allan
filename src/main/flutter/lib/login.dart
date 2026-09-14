import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion - Caillou Tour'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('DÉJÀ CLIENT ?', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
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
            const Text('Vous avez oublié votre mot de passe ?', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 56, 92))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92), // La couleur du fond
                foregroundColor: Colors.white, // La couleur du texte et de l'icône
              ),
              onPressed: () {
                // Ta logique de connexion
              },
              child: const Text('Se connecter'),
            )
          ],
        ),
      ),
    );
  }
}