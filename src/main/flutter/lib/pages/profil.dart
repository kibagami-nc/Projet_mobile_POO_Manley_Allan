import 'package:flutter/material.dart';
import '../widgets/route_sans_animation.dart';
import 'menu.dart';
import '../widgets/ma_nav_bar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Text('Profil', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            TextField(
              enabled: isEditable,
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
                backgroundColor: const Color.fromARGB(255, 255, 56, 92),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18), // Adjust horizontal and vertical space
              ),
              onPressed: () {
                setState(() {
                  isEditable = !isEditable;
                });
              },
              child: const Text(
                'Modifier le profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Agrandit aussi le texte
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
              decoration: InputDecoration(
                labelText: 'Ancien mot de passe',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),
            TextField(
              style: TextStyle(
                color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Nouveau mot de passe',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirmez le mot de passe',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 56, 92),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              ),
              onPressed: () {},
              child: const Text(
                'Modifier le mot de passe',
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