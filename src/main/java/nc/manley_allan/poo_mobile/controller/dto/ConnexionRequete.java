package nc.manley_allan.poo_mobile.controller.dto;

/**
 * Corps JSON envoyé par l'application Flutter sur {@code POST /api/auth/login}.
 *
 * <pre>
 * { "email": "jean@exemple.nc", "motDePasse": "secret" }
 * </pre>
 *
 * Les noms des champs doivent rester identiques côté Dart
 * ({@code lib/services/auth_service.dart}).
 */
public record ConnexionRequete(String email, String motDePasse) {
}
