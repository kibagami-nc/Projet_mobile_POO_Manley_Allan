import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('DÉJÀ CLIENT ?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),

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

            const SizedBox(height: 28),
            const Text('Vous avez oublié votre mot de passe ?', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 56, 92))),
            const SizedBox(height: 28),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
              ),
              onPressed: () {},
              child: const Text(
                'Se connecter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Agrandit aussi le texte
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isChecked = newValue ?? false;
                    });
                  },
                ),
                const Text('Se souvenir de moi', style: TextStyle(color: Color.fromARGB(255, 255, 56, 92))),
              ],
            ),

            const SizedBox(height: 28),
            const Divider(
              color: Colors.grey, // Couleur de la barre
              thickness: 1,       // Épaisseur du trait en pixels
              height: 32,         // Espace vertical total occupé par le widget (marges haut/bas incluses)
            ),

            const Text('Nouveau client ?', style: TextStyle(fontSize: 28, color: Color.fromARGB(255, 255, 56, 92))),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92), // La couleur du fond
                foregroundColor: Colors.white, // La couleur du texte et de l'icône
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
              ),
              onPressed: () {
                // logique de connexion
              },
              child: const Text(
                  'Créer un compte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 2, // Fixé à 2 pour que "Profil" reste surligné
        onDestinationSelected: (i) {
          switch(i) {
            case 0:
            case 1:
            // Si on clique sur Accueil ou Explorer, on ferme la LoginPage pour revenir à la carte
              Navigator.pop(context);
              break;

            case 2:
            // Déjà sur la page Profil, on ne fait rien
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explorer'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}