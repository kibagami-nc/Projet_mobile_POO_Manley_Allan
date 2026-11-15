import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/lieu.dart';

/// Fiche detaillee d'un lieu (exigence M2), ouverte depuis la carte,
/// la recherche ou l'onglet Explorer.
class LieuPage extends StatelessWidget {
  final Lieu lieu;

  const LieuPage({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
    final position = LatLng(lieu.latitude, lieu.longitude);
    final textes = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Fiche du lieu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Petite carte centree sur le lieu, sans interaction
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 200,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: position,
                  initialZoom: 12,
                  interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.poo_mobile_front',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: position,
                        width: 40,
                        height: 40,
                        alignment: Alignment.topCenter,
                        child: const Icon(Icons.location_on,
                            color: Color.fromARGB(255, 255, 56, 92), size: 40),
                      ),
                    ],
                  ),
                  // Mention OpenStreetMap : affichée 5 secondes, puis repliée dans un petit bouton
                  const RichAttributionWidget(
                    showFlutterMapAttribution: false,
                    popupInitialDisplayDuration: Duration(seconds: 5),
                    attributions: [TextSourceAttribution('OpenStreetMap contributors')],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(lieu.nom, style: textes.headlineSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (lieu.categorie != null) Chip(label: Text(lieu.categorie!.libelle)),
              Chip(label: Text(lieu.provinceLibelle)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            lieu.description.isEmpty ? 'Pas encore de description.' : lieu.description,
            style: textes.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Position GPS : ${lieu.latitude.toStringAsFixed(4)}, ${lieu.longitude.toStringAsFixed(4)}',
            style: textes.bodySmall,
          ),
        ],
      ),
    );
  }
}
