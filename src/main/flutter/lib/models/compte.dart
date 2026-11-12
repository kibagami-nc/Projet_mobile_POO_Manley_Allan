import 'utilisateur.dart';

/// Compte du membre connecte, renvoye par GET /api/compte (droit d'acces RGPD).
class Compte {
  final int id;
  final String nom;
  final String email;
  final String role;

  /// Date d'inscription au format AAAA-MM-JJ, telle que renvoyee par l'API.
  final String dateInscription;

  const Compte({
    required this.id,
    required this.nom,
    required this.email,
    required this.role,
    required this.dateInscription,
  });

  factory Compte.fromJson(Map<String, dynamic> json) {
    return Compte(
      id: (json['id'] as num).toInt(),
      nom: json['nom'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'MEMBRE',
      dateInscription: json['dateInscription'] as String? ?? '',
    );
  }

  /// Date au format JJ/MM/AAAA pour l'affichage.
  String get dateAffichee {
    final morceaux = dateInscription.split('-');
    return morceaux.length == 3 ? '${morceaux[2]}/${morceaux[1]}/${morceaux[0]}' : dateInscription;
  }

  Utilisateur versUtilisateur() => Utilisateur(id: id, nom: nom, email: email, role: role);
}
