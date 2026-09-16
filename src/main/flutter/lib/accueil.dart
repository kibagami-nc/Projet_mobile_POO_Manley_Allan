import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Page Accueil : une barre de recherche au-dessus de la carte.
class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: SearchBar(hintText: 'Rechercher...'),
        ),
        Expanded(child: Carte()),
      ],
    );
  }
}

/// Carte OpenStreetMap centrée sur la Nouvelle-Calédonie.
class Carte extends StatelessWidget {
  const Carte({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-21.3, 165.5),
        initialZoom: 7,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.poo_mobile_front',
        ),
      ],
    );
  }
}
