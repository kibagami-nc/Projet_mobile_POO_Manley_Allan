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

class Carte extends StatelessWidget {
  const Carte({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(-20.8, 165.5),
        initialZoom: 7.3,
        minZoom: 4,
        maxZoom: 18,
        // La carte reste confinée à la Nouvelle-Calédonie.
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(
            const LatLng(-24.0, 163.0), // sud-ouest (Île des Pins)
            const LatLng(-18.5, 169.0), // nord-est (Bélep, Loyauté)
          ),
        ),
        interactionOptions: const InteractionOptions(
          // Pas de rotation, pas d'inertie après un glissement,
          // ni de zoom animé au double-tap.
          flags: InteractiveFlag.all &
              ~InteractiveFlag.rotate &
              ~InteractiveFlag.flingAnimation &
              ~InteractiveFlag.doubleTapZoom,
        ),
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