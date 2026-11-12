package nc.manley_allan.poo_mobile.controller.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Changement de mot de passe : l'ancien est vérifié avant d'enregistrer le nouveau. */
public record MotDePasseRequete(

        @NotBlank(message = "L'ancien mot de passe est obligatoire")
        String ancien,

        @NotBlank(message = "Le nouveau mot de passe est obligatoire")
        @Size(min = 8, max = 72, message = "Le nouveau mot de passe doit contenir entre 8 et 72 caractères")
        String nouveau) {
}
