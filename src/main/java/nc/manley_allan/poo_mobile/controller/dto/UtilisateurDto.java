package nc.manley_allan.poo_mobile.controller.dto;

import nc.manley_allan.poo_mobile.entity.Utilisateur;

/**
 * Vue publique d'un compte, renvoyée au client.
 *
 * Volontairement sans le mot de passe : le hachage ne doit jamais
 * quitter le serveur, même sur un canal chiffré.
 */
public record UtilisateurDto(Long id, String nom, String email, String role) {

    /** Convertit l'entité persistée en objet de transfert. */
    public static UtilisateurDto depuis(Utilisateur utilisateur) {
        String role = utilisateur.getRole() == null
                ? "MEMBRE"
                : utilisateur.getRole().toUpperCase();

        return new UtilisateurDto(
                utilisateur.getId(),
                utilisateur.getNom(),
                utilisateur.getEmail(),
                role);
    }
}
