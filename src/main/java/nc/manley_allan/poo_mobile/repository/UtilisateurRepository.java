package nc.manley_allan.poo_mobile.repository;

import nc.manley_allan.poo_mobile.entity.Utilisateur;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UtilisateurRepository extends JpaRepository<Utilisateur, Long> {

    Optional<Utilisateur> findByEmailIgnoreCase(String email);
}
