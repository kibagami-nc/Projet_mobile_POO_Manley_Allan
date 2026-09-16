import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Page Accueil : la carte en plein écran avec une barre de recherche flottante.
class Accueil extends StatelessWidget {
  const Accueil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        Carte(),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 25, 16, 0),
              child: SearchBar(hintText: 'Rechercher...'),
            ),
          ),
        ),
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
