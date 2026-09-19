package nc.manley_allan.poo_mobile.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Rôles des acteurs de l'application.
 * ADMIN et MEMBRE correspondent aux valeurs de la colonne {@code role}
 * de la table {@code utilisateur} ; VISITEUR n'a pas de compte.
 */
@Getter
@RequiredArgsConstructor
public enum Role {
    ADMIN("Administrateur"),
    MEMBRE("Membre"),
    VISITEUR("Visiteur");

    /** Libellé affiché à l'utilisateur. */
    private final String libelle;
}
