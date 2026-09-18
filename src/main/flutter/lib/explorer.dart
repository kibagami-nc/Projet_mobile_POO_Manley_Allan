import 'package:flutter/material.dart';

/// Onglet Explorer (à compléter).
class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 25, 16, 16),
          child: SearchBar(hintText: 'Rechercher...'),
        ),
      ],
    );
  }
}
