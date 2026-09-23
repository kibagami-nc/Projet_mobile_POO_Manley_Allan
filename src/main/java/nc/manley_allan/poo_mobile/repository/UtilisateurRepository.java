package nc.manley_allan.poo_mobile.repository;

import nc.manley_allan.poo_mobile.entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * Accès aux comptes. Spring Data génère l'implémentation au démarrage.
 */
public interface UtilisateurRepository extends JpaRepository<Utilisateur, Long> {

    /**
     * Retrouve un compte par son adresse e-mail, sans tenir compte de la casse.
     * La colonne porte une contrainte d'unicité, le résultat est donc unique.
     *
     * @param email adresse saisie à la connexion
     * @return le compte, ou {@link Optional#empty()} si l'adresse est inconnue
     */
    Optional<Utilisateur> findByEmailIgnoreCase(String email);
}
