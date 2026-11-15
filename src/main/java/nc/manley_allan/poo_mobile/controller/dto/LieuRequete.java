package nc.manley_allan.poo_mobile.controller.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

/**
 * Données envoyées par l'administrateur pour créer ou modifier un lieu (exigence M7).
 * La position doit être en Nouvelle-Calédonie : les mêmes limites que la carte de l'application.
 */
public record LieuRequete(

        @NotBlank(message = "Le nom est obligatoire")
        @Size(max = 150, message = "Le nom ne doit pas dépasser 150 caractères")
        String nom,

        @Size(max = 2000, message = "La description ne doit pas dépasser 2000 caractères")
        String description,

        @NotBlank(message = "La province est obligatoire")
        String province,

        @NotNull(message = "La latitude est obligatoire")
        @DecimalMin(value = "-24", message = "La latitude doit être comprise entre -24 et -18,5 (Nouvelle-Calédonie)")
        @DecimalMax(value = "-18.5", message = "La latitude doit être comprise entre -24 et -18,5 (Nouvelle-Calédonie)")
        Double latitude,

        @NotNull(message = "La longitude est obligatoire")
        @DecimalMin(value = "163", message = "La longitude doit être comprise entre 163 et 169 (Nouvelle-Calédonie)")
        @DecimalMax(value = "169", message = "La longitude doit être comprise entre 163 et 169 (Nouvelle-Calédonie)")
        Double longitude,

        @NotNull(message = "La catégorie est obligatoire")
        Long categorieId) {
}
