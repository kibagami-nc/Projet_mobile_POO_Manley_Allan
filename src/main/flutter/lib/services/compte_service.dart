import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/compte.dart';
import 'api_config.dart';
import 'appel_api.dart';
import 'session.dart';

/// « Mon compte » : consulter, modifier et supprimer son compte (droits RGPD).
/// Chaque appel joint le jeton JWT de la session.
class CompteService {
  final http.Client _client;

  CompteService({http.Client? client}) : _client = client ?? http.Client();

  Future<Compte> consulter() async {
    final corps = await appelerApi(
        () => _client.get(ApiConfig.uri('/api/compte'), headers: _enTetes()));
    return Compte.fromJson(corps as Map<String, dynamic>);
  }

  Future<Compte> modifier({required String nom, required String email}) async {
    final corps = await appelerApi(() => _client.put(ApiConfig.uri('/api/compte'),
        headers: _enTetes(), body: jsonEncode({'nom': nom, 'email': email})));
    return Compte.fromJson(corps as Map<String, dynamic>);
  }

  Future<void> changerMotDePasse({required String ancien, required String nouveau}) async {
    await appelerApi(() => _client.put(ApiConfig.uri('/api/compte/mot-de-passe'),
        headers: _enTetes(), body: jsonEncode({'ancien': ancien, 'nouveau': nouveau})));
  }

  Future<void> supprimer() async {
    await appelerApi(() => _client.delete(ApiConfig.uri('/api/compte'), headers: _enTetes()));
  }

  Map<String, String> _enTetes() => {...ApiConfig.enTetesJson, ...Session.instance.enTetesAuth};

  /// Libere les ressources du client HTTP.
  void fermer() => _client.close();
}
