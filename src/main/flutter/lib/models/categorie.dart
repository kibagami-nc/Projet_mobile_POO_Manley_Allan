/// Categorie de lieux renvoyee par l'API (GET /api/categories) : Plage, Randonnee...
class Categorie {
  final int id;
  final String libelle;

  const Categorie({required this.id, required this.libelle});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: (json['id'] as num).toInt(),
      libelle: json['libelle'] as String? ?? '',
    );
  }
}
