package nc.manley_allan.poo_mobile.controller;

import jakarta.validation.Valid;
import nc.manley_allan.poo_mobile.controller.dto.LieuRequete;
import nc.manley_allan.poo_mobile.entity.Lieu;
import nc.manley_allan.poo_mobile.service.LieuService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * Lieux touristiques.
 * Lecture ouverte à tous (M1, M2, M3) ; création, modification et suppression réservées
 * au rôle ADMIN (M7), règle posée dans SecurityConfig.
 */
@RestController
@RequestMapping(path = "/api/lieux", produces = MediaType.APPLICATION_JSON_VALUE)
public class LieuController {

    private final LieuService lieuService;

    public LieuController(LieuService lieuService) {
        this.lieuService = lieuService;
    }

    /** Exemple : GET /api/lieux?recherche=poule&categorie=5&province=NORD */
    @GetMapping
    public List<Lieu> lister(@RequestParam(name = "recherche", required = false) String recherche,
                             @RequestParam(name = "categorie", required = false) Long categorieId,
                             @RequestParam(name = "province", required = false) String province) {
        return lieuService.rechercher(recherche, categorieId, province);
    }

    @GetMapping("/{id}")
    public Lieu trouver(@PathVariable("id") Long id) {
        return lieuService.trouver(id);
    }

    @PostMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public Lieu creer(@Valid @RequestBody LieuRequete requete) {
        return lieuService.creer(requete);
    }

    @PutMapping(path = "/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
    public Lieu modifier(@PathVariable("id") Long id, @Valid @RequestBody LieuRequete requete) {
        return lieuService.modifier(id, requete);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void supprimer(@PathVariable("id") Long id) {
        lieuService.supprimer(id);
    }
}
