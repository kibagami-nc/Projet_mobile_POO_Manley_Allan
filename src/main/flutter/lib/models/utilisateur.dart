/// Compte utilisateur renvoye par l'API apres une connexion reussie.
///
/// Reflete l'entite `Utilisateur` cote Spring Boot, sans le mot de passe :
/// le hash ne doit jamais quitter le serveur.
class Utilisateur {
  final int id;
  final String nom;
  final String email;

  /// `MEMBRE` ou `ADMIN`, d'apres l'enumeration `Role` cote back.
  final String role;

  const Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
  });

  /// Construit l'objet depuis le JSON de l'API.
  ///
  /// Tolerant : un champ absent ne fait pas planter la connexion, il prend
  /// une valeur par defaut. Le role est normalise en majuscules.
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nom: json['nom'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: (json['role'] as String? ?? 'MEMBRE').toUpperCase(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nom': nom,
        'email': email,
        'role': role,
      };

  bool get estAdmin => role == 'ADMIN';

  /// Nom affichable : le nom du compte, ou l'e-mail s'il n'y en a pas.
  String get libelle => nom.isNotEmpty ? nom : email;
}
