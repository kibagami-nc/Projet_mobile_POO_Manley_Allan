package nc.manley_allan.poo_mobile.controller;

import nc.manley_allan.poo_mobile.repository.FavoriRepository;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/favoris")
public class FavoriController {

    private final FavoriRepository favoriRepository;

    public FavoriController(FavoriRepository favoriRepository) {
        this.favoriRepository = favoriRepository;
    }

    @PostMapping("/{lieuId}")
    public void ajouter(Principal principal, @PathVariable("lieuId") Long lieuId) {
        favoriRepository.ajouter(Long.valueOf(principal.getName()), lieuId);
    }
}
