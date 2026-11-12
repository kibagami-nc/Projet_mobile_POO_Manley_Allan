package nc.manley_allan.poo_mobile.controller.dto;

import nc.manley_allan.poo_mobile.entity.Utilisateur;

import java.time.LocalDate;

/** Données du compte connecté (droit d'accès RGPD), sans le mot de passe. */
public record CompteReponse(
        Long id,
        String nom,
        String email,
        String role,
        LocalDate dateInscription) {

    public static CompteReponse from(Utilisateur utilisateur) {
        return new CompteReponse(utilisateur.getId(), utilisateur.getNom(), utilisateur.getEmail(),
                utilisateur.getRole(), utilisateur.getDateInscription());
    }
}
