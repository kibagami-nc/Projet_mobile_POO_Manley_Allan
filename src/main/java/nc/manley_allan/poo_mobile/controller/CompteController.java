package nc.manley_allan.poo_mobile.controller;

import jakarta.validation.Valid;
import nc.manley_allan.poo_mobile.controller.dto.CompteReponse;
import nc.manley_allan.poo_mobile.controller.dto.CompteRequete;
import nc.manley_allan.poo_mobile.controller.dto.MotDePasseRequete;
import nc.manley_allan.poo_mobile.service.CompteService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

/**
 * « Mon compte » : réservé au membre connecté (jeton JWT obligatoire, sinon 401).
 * Principal.getName() renvoie l'identifiant du compte lu dans le jeton par JwtFiltre.
 */
@RestController
@RequestMapping(path = "/api/compte", produces = MediaType.APPLICATION_JSON_VALUE)
public class CompteController {

    private final CompteService compteService;

    public CompteController(CompteService compteService) {
        this.compteService = compteService;
    }

    @GetMapping
    public CompteReponse consulter(Principal principal) {
        return CompteReponse.from(compteService.trouver(principal.getName()));
    }

    @PutMapping(consumes = MediaType.APPLICATION_JSON_VALUE)
    public CompteReponse modifier(Principal principal, @Valid @RequestBody CompteRequete requete) {
        return CompteReponse.from(compteService.modifier(principal.getName(), requete));
    }

    @PutMapping(path = "/mot-de-passe", consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void changerMotDePasse(Principal principal, @Valid @RequestBody MotDePasseRequete requete) {
        compteService.changerMotDePasse(principal.getName(), requete);
    }

    @DeleteMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void supprimer(Principal principal) {
        compteService.supprimer(principal.getName());
    }
}
