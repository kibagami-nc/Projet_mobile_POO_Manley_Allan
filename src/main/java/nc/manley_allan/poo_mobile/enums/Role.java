package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum Role {
    ADMIN("Administrateur"),
    MEMBRE("Membre"),
    VISITEUR("Visiteur");

    private final String libelle;
}
