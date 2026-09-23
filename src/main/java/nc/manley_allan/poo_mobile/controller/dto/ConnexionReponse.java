package nc.manley_allan.poo_mobile.controller.dto;

/**
 * Réponse renvoyée après une connexion réussie.
 *
 * <pre>
 * {
 *   "token": "...",
 *   "utilisateur": { "id": 1, "nom": "Jean", "email": "...", "role": "MEMBRE" }
 * }
 * </pre>
 */
public record ConnexionReponse(String token, UtilisateurDto utilisateur) {
}
