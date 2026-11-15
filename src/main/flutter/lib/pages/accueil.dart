import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/categorie.dart';
import '../models/lieu.dart';
import '../services/api_exception.dart';
import '../services/lieu_service.dart';
import '../widgets/route_sans_animation.dart';
import 'lieu.dart';
import 'recherche.dart';

/// Page Accueil : la carte en plein écran avec une barre de recherche flottante.
/// Les lieux et les catégories viennent de l'API.
class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final _service = LieuService();
  List<Lieu> _lieux = [];
  List<Categorie> _categories = [];

  @override
  void initState() {
    super.initState();
    _charger();
  }

  @override
  void dispose() {
    _service.fermer();
    super.dispose();
  }

  Future<void> _charger() async {
    try {
      final lieux = await _service.rechercher();
      final categories = await _service.categories();
      if (!mounted) return;
      setState(() {
        _lieux = lieux;
        _categories = categories;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  /// Ouvre la liste des lieux, filtrée par le texte saisi ou par une catégorie.
  void _ouvrirRecherche({String recherche = '', int? categorieId}) {
    Navigator.push(
      context,
      RouteSansAnimation(
        builder: (_) => RecherchePage(recherche: recherche, categorieId: categorieId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Carte(lieux: _lieux),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
                  child: SearchBar(
                    hintText: 'Rechercher...',
                    onSubmitted: (texte) => _ouvrirRecherche(recherche: texte),
                  ),
                ),
                // Petits boutons de catégories sous la barre de recherche.
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    children: [
                      // Les catégories de la base : ouvrent la liste des lieux de la catégorie.
                      for (final categorie in _categories)
                        _puce(categorie.libelle, () => _ouvrirRecherche(categorieId: categorie.id)),
                      // "Enregistrés" et "À découvrir" n'existent que sur la carte (pas encore d'action).
                      for (final libelle in ['Enregistrés', 'À découvrir']) _puce(libelle, () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _puce(String libelle, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(libelle),
        labelStyle: Theme.of(context).textTheme.labelSmall,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: onPressed,
      ),
    );
  }
}

class Carte extends StatelessWidget {
  final List<Lieu> lieux;

  const Carte({super.key, this.lieux = const []});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: const LatLng(-20.8, 165.5),
        initialZoom: 7.3,
        minZoom: 4,
        maxZoom: 18,
        // Le centre de la carte reste en Nouvelle-Calédonie. containCenter et non
        // contain : avec contain, tout l'écran devait tenir dans ce cadre, plus petit
        // que l'écran d'un téléphone en hauteur, et la carte refusait de bouger.
        cameraConstraint: CameraConstraint.containCenter(
          bounds: LatLngBounds(
            const LatLng(-24.0, 163.0), // sud-ouest (Île des Pins)
            const LatLng(-18.5, 169.0), // nord-est (Bélep, Loyauté)
          ),
        ),
        interactionOptions: const InteractionOptions(
          // Pas de rotation, pas d'inertie après un glissement,
          // ni de zoom animé au double-tap.
          flags:
              InteractiveFlag.all &
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
        // Un repère par lieu (M1) : le toucher ouvre la fiche du lieu (M2).
        MarkerLayer(
          markers: [
            for (final lieu in lieux)
              Marker(
                point: LatLng(lieu.latitude, lieu.longitude),
                width: 40,
                height: 40,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    RouteSansAnimation(builder: (_) => LieuPage(lieu: lieu)),
                  ),
                  child: const Icon(Icons.location_on,
                      color: Color.fromARGB(255, 255, 56, 92), size: 40),
                ),
              ),
          ],
        ),
        // Mention obligatoire de la politique d'usage des tuiles OpenStreetMap :
        // affichée 5 secondes à l'ouverture de la carte, puis repliée dans un petit bouton.
        const RichAttributionWidget(
          showFlutterMapAttribution: false,
          popupInitialDisplayDuration: Duration(seconds: 5),
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );
  }
}
