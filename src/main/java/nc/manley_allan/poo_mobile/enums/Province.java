package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Les trois provinces de Nouvelle-Calédonie.
 */
@Getter
@RequiredArgsConstructor
public enum Province {
    SUD("Province Sud"),
    NORD("Province Nord"),
    ILES("Îles Loyauté");

    /** Libellé affiché à l'utilisateur. */
    private final String libelle;
}
