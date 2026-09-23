/// Erreur remontee par la couche reseau, avec un message deja redige
/// pour etre affiche tel quel a l'utilisateur.
class ApiException implements Exception {
  /// Message en francais, affichable directement dans l'interface.
  final String message;

  /// Code HTTP renvoye par le serveur, `null` si l'appel n'a jamais abouti
  /// (serveur eteint, pas de reseau, delai depasse).
  final int? codeHttp;

  const ApiException(this.message, {this.codeHttp});

  @override
  String toString() => 'ApiException'
      '${codeHttp == null ? '' : ' ($codeHttp)'} : $message';
}
