package nc.manley_allan.poo_mobile.repository;

import nc.manley_allan.poo_mobile.entity.Lieu;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LieuRepository extends JpaRepository<Lieu, Long> {

    /**
     * Recherche des lieux (exigence M3), triés par nom. Un filtre à null est ignoré.
     * - motif : texte cherché dans le nom, au format LIKE en minuscules (ex. "%poule%")
     * - categorieId : identifiant de la catégorie
     * - province : SUD, NORD ou ILES
     * Les valeurs sont passées en paramètres : pas d'injection SQL possible.
     */
    @Query("""
            SELECT l FROM Lieu l
            WHERE LOWER(l.nom) LIKE :motif
              AND (:categorieId IS NULL OR l.categorie.id = :categorieId)
              AND (:province IS NULL OR l.province = :province)
            ORDER BY l.nom
            """)
    List<Lieu> rechercher(@Param("motif") String motif,
                          @Param("categorieId") Long categorieId,
                          @Param("province") String province);
}
