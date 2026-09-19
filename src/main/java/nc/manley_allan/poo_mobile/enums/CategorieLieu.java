package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Catégories proposées dans l'application (filtres de la carte et de l'onglet Explorer).
 */
@Getter
@RequiredArgsConstructor
public enum CategorieLieu {
    LIEUX("Lieux"),
    RESTAURANTS("Restaurants"),
    ACTIVITES("Activités"),
    ENREGISTRES("Enregistrés"),
    LES_PLUS_VISITES("Les plus visités");

    /** Libellé affiché à l'utilisateur. */
    private final String libelle;
}
