import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MonApp());
}

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PagePrincipale(),
    );
  }
}

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          switch(i) {
            case 0:
            // Si l'utilisateur clique sur l'index 0 (Explorer)
              setState(() => _index = i);

            case 1:
            // Si l'utilisateur clique sur l'index 1 (Favoris)
              setState(() => _index = i);

            case 2:
            // Si l'utilisateur clique sur l'index 2 (Profil)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );

            default:
              setState(() => _index = i);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explorer'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoris'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}