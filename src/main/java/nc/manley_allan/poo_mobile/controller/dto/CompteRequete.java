package nc.manley_allan.poo_mobile.controller.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Modification du compte par son propriétaire (droit de rectification RGPD). */
public record CompteRequete(

        @NotBlank(message = "Le pseudo est obligatoire")
        @Size(max = 100, message = "Le pseudo ne doit pas dépasser 100 caractères")
        String nom,

        @NotBlank(message = "L'e-mail est obligatoire")
        @Email(message = "L'e-mail n'est pas valide")
        @Size(max = 255, message = "L'e-mail ne doit pas dépasser 255 caractères")
        String email) {
}
