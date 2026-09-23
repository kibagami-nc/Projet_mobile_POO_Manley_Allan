import 'package:flutter/foundation.dart';

/// Adresse de l'API Spring Boot interrogee par l'application.
///
/// Par defaut :
///   - emulateur Android : http://10.0.2.2:8080
///     (10.0.2.2 est l'alias de la machine hote vue depuis l'emulateur ;
///      « localhost » designerait l'emulateur lui-meme)
///   - bureau (Linux / Windows / macOS) : http://localhost:8080
///
/// Pour un telephone physique, l'emulateur ne suffit pas : il faut viser
/// l'adresse IP du PC sur le reseau local, au lancement :
///
///   flutter run --dart-define=API_URL=http://192.168.1.20:8080
class ApiConfig {
  const ApiConfig._();

  /// Surcharge fournie par `--dart-define=API_URL=...`, vide si absente.
  static const String _surcharge = String.fromEnvironment('API_URL');

  /// Racine de l'API, sans barre oblique finale.
  static String get baseUrl {
    if (_surcharge.isNotEmpty) {
      return _surcharge.endsWith('/')
          ? _surcharge.substring(0, _surcharge.length - 1)
          : _surcharge;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://localhost:8080';
  }

  /// Construit l'URL complete d'une route, par exemple `/api/auth/login`.
  static Uri uri(String chemin) => Uri.parse('$baseUrl$chemin');

  /// Delai au dela duquel un appel est abandonne.
  static const Duration delaiMax = Duration(seconds: 10);

  /// En-tetes communs a tous les appels JSON.
  static const Map<String, String> enTetesJson = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  };
}
