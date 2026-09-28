package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Province {
    SUD("Province Sud"),
    NORD("Province Nord"),
    ILES("Îles Loyauté");

    private final String libelle;
}
