package nc.manley_allan.poo_mobile.controller.dto;

/** Réponse à une connexion ou une inscription réussie : le jeton JWT et le compte. */
public record ConnexionReponse(
        String token,
        UtilisateurDto utilisateur) {
}
