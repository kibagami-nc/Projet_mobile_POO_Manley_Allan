import 'package:flutter/foundation.dart';

import '../models/utilisateur.dart';

/// Etat de connexion de l'application : compte courant.
///
/// Point d'acces unique via [Session.instance], pour que n'importe quel ecran
/// sache qui est connecte sans se le faire passer de page en page.
///
/// La session vit en memoire : fermer l'application deconnecte.
class Session extends ChangeNotifier {
  Session._();

  static final Session instance = Session._();

  Utilisateur? _utilisateur;
  bool _seSouvenir = false;

  /// Compte connecte, `null` si personne n'est connecte.
  Utilisateur? get utilisateur => _utilisateur;

  /// Choix fait par l'utilisateur a la connexion.
  bool get seSouvenir => _seSouvenir;

  bool get estConnecte => _utilisateur != null;

  /// Enregistre la connexion reussie et previent les ecrans a l'ecoute.
  void ouvrir({
    required Utilisateur utilisateur,
    bool seSouvenir = false,
  }) {
    _utilisateur = utilisateur;
    _seSouvenir = seSouvenir;
    notifyListeners();
  }

  /// Deconnecte : efface le compte.
  void fermer() {
    _utilisateur = null;
    _seSouvenir = false;
    notifyListeners();
  }
}
