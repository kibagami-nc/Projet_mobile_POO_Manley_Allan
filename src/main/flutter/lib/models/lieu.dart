import 'categorie.dart';

/// Lieu touristique renvoye par l'API (GET /api/lieux).
class Lieu {
  final int id;
  final String nom;
  final String description;

  /// `SUD`, `NORD` ou `ILES`, d'apres l'enumeration `Province` cote back.
  final String province;
  final double latitude;
  final double longitude;
  final Categorie? categorie;

  const Lieu({
    required this.id,
    required this.nom,
    required this.description,
    required this.province,
    required this.latitude,
    required this.longitude,
    this.categorie,
  });

  factory Lieu.fromJson(Map<String, dynamic> json) {
    final categorie = json['categorie'];
    return Lieu(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String? ?? '',
      description: json['description'] as String? ?? '',
      province: json['province'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      categorie: categorie is Map<String, dynamic> ? Categorie.fromJson(categorie) : null,
    );
  }

  /// Nom affichable de la province (memes libelles que l'enumeration Province de l'API).
  String get provinceLibelle => switch (province) {
        'SUD' => 'Province Sud',
        'NORD' => 'Province Nord',
        'ILES' => 'Îles Loyauté',
        _ => province,
      };
}

/// Les trois provinces, pour les filtres et le formulaire d'administration.
const Map<String, String> provinces = {
  'SUD': 'Province Sud',
  'NORD': 'Province Nord',
  'ILES': 'Îles Loyauté',
};
