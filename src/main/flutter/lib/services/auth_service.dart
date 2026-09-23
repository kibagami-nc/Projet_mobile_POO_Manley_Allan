import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;

import '../models/utilisateur.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// Ce que renvoie une connexion reussie : le jeton et le compte associe.
class ResultatConnexion {
  final String token;
  final Utilisateur utilisateur;

  const ResultatConnexion({required this.token, required this.utilisateur});
}

class AuthService {
  final http.Client _client;

  /// Le client est injectable pour pouvoir tester sans serveur.
  AuthService({http.Client? client}) : _client = client ?? http.Client();

  /// Chemin de la route de connexion.
  static const String cheminLogin = '/api/auth/login';

  /// Envoie les identifiants a l'API.
  ///
  /// Renvoie le jeton et le compte, ou leve une [ApiException] dont le
  /// `message` est directement affichable.
  Future<ResultatConnexion> connexion({
    required String email,
    required String motDePasse,
  }) async {
    final http.Response reponse;

    try {
      reponse = await _client
          .post(
            ApiConfig.uri(cheminLogin),
            headers: ApiConfig.enTetesJson,
            body: jsonEncode({
              'email': email.trim(),
              'motDePasse': motDePasse,
            }),
          )
          .timeout(ApiConfig.delaiMax);
    } on TimeoutException {
      throw const ApiException(
        'Le serveur met trop de temps a repondre. Reessayez.',
      );
    } on SocketException {
      throw ApiException(_messageInjoignable());
    } on http.ClientException {
      throw ApiException(_messageInjoignable());
    }

    return _lireReponse(reponse);
  }

  /// Libere les ressources du client HTTP.
  void fermer() => _client.close();

  // ---------------------------------------------------------------------------

  String _messageInjoignable() =>
      'Serveur injoignable (${ApiConfig.baseUrl}).\n'
      'Verifiez que l\'API Spring Boot est demarree.';

  ResultatConnexion _lireReponse(http.Response reponse) {
    final code = reponse.statusCode;

    if (code == 200 || code == 201) {
      return _extraire(reponse);
    }

    if (code == 401 || code == 403) {
      throw const ApiException(
        'E-mail ou mot de passe incorrect.',
        codeHttp: 401,
      );
    }

    if (code == 404) {
      throw const ApiException(
        'La route $cheminLogin n\'existe pas encore sur l\'API.',
        codeHttp: 404,
      );
    }

    if (code >= 500) {
      throw ApiException(
        'Erreur du serveur, reessayez plus tard.',
        codeHttp: code,
      );
    }

    // 400 et autres : on affiche le message du serveur s'il en fournit un.
    throw ApiException(
      _messageServeur(reponse) ?? 'Connexion refusee (erreur $code).',
      codeHttp: code,
    );
  }

  ResultatConnexion _extraire(http.Response reponse) {
    final Map<String, dynamic> corps;
    try {
      // bodyBytes + utf8 : sinon les accents des messages serveur sont casses.
      corps = jsonDecode(utf8.decode(reponse.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('Reponse illisible envoyee par le serveur.');
    }

    final token = (corps['token'] ?? corps['accessToken']) as String?;
    if (token == null || token.isEmpty) {
      throw const ApiException('Le serveur n\'a pas renvoye de jeton.');
    }

    // Le compte peut etre imbrique, ou a plat a cote du jeton.
    final brut = corps['utilisateur'] ?? corps['user'] ?? corps;
    if (brut is! Map<String, dynamic>) {
      throw const ApiException('Compte absent de la reponse du serveur.');
    }

    return ResultatConnexion(
      token: token,
      utilisateur: Utilisateur.fromJson(brut),
    );
  }

  String? _messageServeur(http.Response reponse) {
    try {
      final corps = jsonDecode(utf8.decode(reponse.bodyBytes));
      if (corps is Map<String, dynamic>) {
        final message = corps['message'] ?? corps['error'];
        if (message is String && message.isNotEmpty) return message;
      }
    } catch (_) {
      // Corps vide ou non JSON : on retombe sur le message generique.
    }
    return null;
  }
}
