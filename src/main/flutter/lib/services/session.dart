import 'package:flutter/foundation.dart';

import '../models/utilisateur.dart';

/// Etat de connexion de l'application : jeton JWT et compte courant.
///
/// Point d'acces unique via [Session.instance], pour que n'importe quel ecran
/// sache qui est connecte sans se le faire passer de page en page.
///
/// La session vit en memoire : fermer l'application deconnecte. Rendre
/// « Se souvenir de moi » persistant se fait en ecrivant [token] dans un
/// stockage chiffre (`flutter_secure_storage`, prevu au README) depuis
/// [ouvrir] et en le relisant au demarrage.
class Session extends ChangeNotifier {
  Session._();

  static final Session instance = Session._();

  String? _token;
  Utilisateur? _utilisateur;
  bool _seSouvenir = false;

  /// Jeton JWT courant, `null` si personne n'est connecte.
  String? get token => _token;

  /// Compte connecte, `null` si personne n'est connecte.
  Utilisateur? get utilisateur => _utilisateur;

  /// Choix fait par l'utilisateur a la connexion.
  bool get seSouvenir => _seSouvenir;

  bool get estConnecte => _token != null;

  /// En-tete a joindre aux appels proteges de l'API.
  ///
  ///   http.get(ApiConfig.uri('/api/favoris'),
  ///            headers: {...ApiConfig.enTetesJson, ...Session.instance.enTetesAuth});
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

  /// Deconnecte : efface le jeton et le compte.
  void fermer() {
    _token = null;
    _utilisateur = null;
    _seSouvenir = false;
    notifyListeners();
  }
}
