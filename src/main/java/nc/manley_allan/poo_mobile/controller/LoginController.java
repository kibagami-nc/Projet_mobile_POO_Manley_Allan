package nc.manley_allan.poo_mobile.controller;

import nc.manley_allan.poo_mobile.controller.dto.ConnexionRequete;
import nc.manley_allan.poo_mobile.controller.dto.ConnexionReponse;
import nc.manley_allan.poo_mobile.controller.dto.RegisterRequete;
import nc.manley_allan.poo_mobile.controller.dto.RegisterReponse;
import nc.manley_allan.poo_mobile.service.AuthentificationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "/api/auth", produces = MediaType.APPLICATION_JSON_VALUE)
public class LoginController {

    private final AuthentificationService authentificationService;

    public LoginController(AuthentificationService authentificationService) {
        this.authentificationService = authentificationService;
    }

    @PostMapping(path = "/login", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ConnexionReponse> login(@RequestBody ConnexionRequete requete) {

        if (estVide(requete.email()) || estVide(requete.motDePasse())) {
            return ResponseEntity.badRequest().build();
        }

        return authentificationService
                .connexion(requete.email(), requete.motDePasse())
                .map(ResponseEntity::ok)
                .orElseGet(() -> ResponseEntity.status(HttpStatus.UNAUTHORIZED).build());
    }

    // Register
    @PostMapping(path = "/register", consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ConnexionReponse> register(@RequestBody RegisterRequete requete) {

        if (estVide(requete.email()) || estVide(requete.motDePasse()) || estVide(requete.nom())) {
            return ResponseEntity.badRequest().build();
        }

        return authentificationService
                .register(requete.nom(), requete.email(), requete.motDePasse())
                .map(reponse -> ResponseEntity.status(HttpStatus.CREATED).body(reponse))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.CONFLICT).build()); // 409 si l'email existe déjà
    }

    private boolean estVide(String valeur) {
        return valeur == null || valeur.isBlank();
    }
}