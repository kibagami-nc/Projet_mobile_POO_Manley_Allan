package nc.manley_allan.poo_mobile.controller.dto;

import nc.manley_allan.poo_mobile.entity.Utilisateur;

public record UtilisateurDto(

        Long id,
        String nom,
        String email,
        String role) {

    public static UtilisateurDto from(Utilisateur utilisateur) {
        return new UtilisateurDto(

                utilisateur.getId(),

                utilisateur.getNom(),

                utilisateur.getEmail(),

                utilisateur.getRole());
    }
}
