import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';

/// Envoie une requete a l'API et renvoie le corps JSON decode (`null` s'il est vide).
///
/// En cas d'echec, leve une [ApiException] dont le message est affichable :
/// celui renvoye par l'API ({"message": "..."}) quand il existe.
Future<dynamic> appelerApi(Future<http.Response> Function() requete) async {
  final http.Response reponse;
  try {
    reponse = await requete().timeout(ApiConfig.delaiMax);
  } on TimeoutException {
    throw const ApiException('Le serveur met trop de temps a repondre. Reessayez.');
  } on SocketException {
    throw ApiException(_messageInjoignable());
  } on http.ClientException {
    throw ApiException(_messageInjoignable());
  }

  // bodyBytes + utf8 : sinon les accents sont casses.
  final texte = utf8.decode(reponse.bodyBytes);
  final code = reponse.statusCode;
  if (code >= 200 && code < 300) {
    return texte.isEmpty ? null : jsonDecode(texte);
  }
  throw ApiException(_messageErreur(texte, code), codeHttp: code);
}

String _messageInjoignable() =>
    'Serveur injoignable (${ApiConfig.baseUrl}).\n'
    'Verifiez que l\'API Spring Boot est demarree.';

String _messageErreur(String texte, int code) {
  try {
    final corps = jsonDecode(texte);
    if (corps is Map<String, dynamic> && corps['message'] is String) {
      return corps['message'] as String;
    }
  } catch (_) {
    // Corps vide ou non JSON : message par defaut selon le code.
  }
  return switch (code) {
    401 => 'Vous devez vous connecter.',
    403 => 'Action reservee a l\'administrateur.',
    404 => 'Element introuvable.',
    >= 500 => 'Erreur du serveur, reessayez plus tard.',
    _ => 'Requete refusee (erreur $code).',
  };
}
