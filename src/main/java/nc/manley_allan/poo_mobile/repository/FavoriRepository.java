package nc.manley_allan.poo_mobile.repository;

import nc.manley_allan.poo_mobile.entity.Favori;
import nc.manley_allan.poo_mobile.entity.FavoriId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

public interface FavoriRepository extends JpaRepository<Favori, FavoriId> {


    @Modifying
    @Transactional
    @Query(value = "INSERT INTO favori (utilisateur_id, lieu_id) VALUES (:utilisateurId, :lieuId)",
            nativeQuery = true)
    void ajouter(@Param("utilisateurId") Long utilisateurId, @Param("lieuId") Long lieuId);
}
