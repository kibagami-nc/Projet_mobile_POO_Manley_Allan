package nc.manley_allan.poo_mobile.controller;

import nc.manley_allan.poo_mobile.entity.Categorie;
import nc.manley_allan.poo_mobile.repository.CategorieRepository;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** Catégories de lieux, pour les filtres de l'application et le formulaire d'administration. */
@RestController
@RequestMapping(path = "/api/categories", produces = MediaType.APPLICATION_JSON_VALUE)
public class CategorieController {

    private final CategorieRepository categorieRepository;

    public CategorieController(CategorieRepository categorieRepository) {
        this.categorieRepository = categorieRepository;
    }

    @GetMapping
    public List<Categorie> lister() {
        return categorieRepository.findAllByOrderByLibelleAsc();
    }
}
