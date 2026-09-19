import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'menu.dart';
import '../widgets/ma_nav_bar.dart';
import 'register.dart';

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

            const SizedBox(height: 20),
            const Divider(
              color: Colors.grey, // Couleur de la barre
              thickness: 1,       // Épaisseur du trait en pixels
              height: 32,         // Espace vertical total occupé par le widget (marges haut/bas incluses)
            ),

            const Text('Nouveau client ?', style: TextStyle(fontSize: 28, color: Color.fromARGB(255, 255, 56, 92))),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  RouteSansAnimation(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: MaNavBar(
        selectedIndex: 2,
        onDestinationSelected: (index) {
          if (index != 2) {
            Navigator.pushAndRemoveUntil(
              context,
              RouteSansAnimation(builder: (context) => Menu(indexInitial: index)),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}