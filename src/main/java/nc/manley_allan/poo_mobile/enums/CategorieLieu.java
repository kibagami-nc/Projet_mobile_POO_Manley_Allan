package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CategorieLieu {
    LIEUX("Lieux"),
    RESTAURANTS("Restaurants"),
    ACTIVITES("Activités"),
    ENREGISTRES("Enregistrés"),
    LES_PLUS_VISITES("Les plus visités");

    private final String libelle;
}
