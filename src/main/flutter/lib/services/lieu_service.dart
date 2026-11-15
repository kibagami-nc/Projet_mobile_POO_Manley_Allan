import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/categorie.dart';
import '../models/lieu.dart';
import 'api_config.dart';
import 'appel_api.dart';
import 'session.dart';

/// Appels a l'API pour les lieux et les categories.
///
/// La lecture est ouverte a tous ; creer, modifier et supprimer un lieu
/// demandent un compte ADMIN (le jeton JWT est joint a la requete).
class LieuService {
  final http.Client _client;

  LieuService({http.Client? client}) : _client = client ?? http.Client();

  /// Lieux tries par nom, avec une recherche par nom et des filtres facultatifs (M3).
  Future<List<Lieu>> rechercher({
    String recherche = '',
    int? categorieId,
    String? province,
  }) async {
    // Seuls les filtres choisis sont envoyes : /api/lieux?recherche=poule&province=NORD
    final parametres = <String, String>{};
    if (recherche.trim().isNotEmpty) parametres['recherche'] = recherche.trim();
    if (categorieId != null) parametres['categorie'] = '$categorieId';
    if (province != null) parametres['province'] = province;
    final uri = ApiConfig.uri('/api/lieux')
        .replace(queryParameters: parametres.isEmpty ? null : parametres);
    final corps = await appelerApi(() => _client.get(uri, headers: ApiConfig.enTetesJson));
    return (corps as List<dynamic>)
        .map((json) => Lieu.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Categorie>> categories() async {
    final corps = await appelerApi(
        () => _client.get(ApiConfig.uri('/api/categories'), headers: ApiConfig.enTetesJson));
    return (corps as List<dynamic>)
        .map((json) => Categorie.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Ajoute un lieu (administrateur). [lieu] contient nom, description,
  /// province, latitude, longitude et categorieId.
  Future<Lieu> creer(Map<String, dynamic> lieu) async {
    final corps = await appelerApi(() => _client.post(ApiConfig.uri('/api/lieux'),
        headers: _enTetesAdmin(), body: jsonEncode(lieu)));
    return Lieu.fromJson(corps as Map<String, dynamic>);
  }

  Future<Lieu> modifier(int id, Map<String, dynamic> lieu) async {
    final corps = await appelerApi(() => _client.put(ApiConfig.uri('/api/lieux/$id'),
        headers: _enTetesAdmin(), body: jsonEncode(lieu)));
    return Lieu.fromJson(corps as Map<String, dynamic>);
  }

  Future<void> supprimer(int id) async {
    await appelerApi(
        () => _client.delete(ApiConfig.uri('/api/lieux/$id'), headers: _enTetesAdmin()));
  }

  Map<String, String> _enTetesAdmin() =>
      {...ApiConfig.enTetesJson, ...Session.instance.enTetesAuth};

  /// Libere les ressources du client HTTP.
  void fermer() => _client.close();
}
