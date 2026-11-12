import 'package:flutter/foundation.dart';

import '../models/utilisateur.dart';

/// Etat de connexion de l'application : jeton JWT et compte courant.
///
/// Point d'acces unique via [Session.instance], pour que n'importe quel ecran
/// sache qui est connecte sans se le faire passer de page en page.
///
/// La session vit en memoire : fermer l'application deconnecte.
class Session extends ChangeNotifier {
  Session._();

  static final Session instance = Session._();

  String? _token;
  Utilisateur? _utilisateur;
  bool _seSouvenir = false;

  /// Jeton JWT renvoye par l'API, `null` si personne n'est connecte.
  String? get token => _token;

  /// Compte connecte, `null` si personne n'est connecte.
  Utilisateur? get utilisateur => _utilisateur;

  /// Choix fait par l'utilisateur a la connexion.
  bool get seSouvenir => _seSouvenir;

  bool get estConnecte => _utilisateur != null;

  bool get estAdmin => _utilisateur?.estAdmin ?? false;

  /// En-tete a joindre aux appels proteges de l'API (profil, administration).
  Map<String, String> get enTetesAuth =>
      _token == null ? const {} : {'Authorization': 'Bearer $_token'};

  /// Enregistre la connexion reussie et previent les ecrans a l'ecoute.
  void ouvrir({
    required String token,
    required Utilisateur utilisateur,
    bool seSouvenir = false,
  }) {
    _token = token;
    _utilisateur = utilisateur;
    _seSouvenir = seSouvenir;
    notifyListeners();
  }

  /// Met a jour le compte affiche (apres une modification du profil).
  void mettreAJour(Utilisateur utilisateur) {
    _utilisateur = utilisateur;
    notifyListeners();
  }

  /// Deconnecte : efface le jeton et le compte.
  void fermer() {
    _token = null;
    _utilisateur = null;
    _seSouvenir = false;
    notifyListeners();
  }
}
