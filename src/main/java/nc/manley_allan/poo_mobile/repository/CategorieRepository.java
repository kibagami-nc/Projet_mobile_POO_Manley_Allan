package nc.manley_allan.poo_mobile.repository;

import nc.manley_allan.poo_mobile.entity.Categorie;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategorieRepository extends JpaRepository<Categorie, Long> {

    List<Categorie> findAllByOrderByLibelleAsc();
}
