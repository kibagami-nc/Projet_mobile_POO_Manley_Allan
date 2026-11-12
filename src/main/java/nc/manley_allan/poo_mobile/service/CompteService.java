package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.CompteRequete;
import nc.manley_allan.poo_mobile.controller.dto.MotDePasseRequete;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import nc.manley_allan.poo_mobile.enums.Role;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

/**
 * Compte du membre connecté : les droits RGPD d'accès, de rectification et d'effacement.
 * Le compte est désigné par l'identifiant contenu dans le jeton JWT.
 */
@Service
public class CompteService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder encodeurMotDePasse;

    public CompteService(UtilisateurRepository utilisateurRepository, PasswordEncoder encodeurMotDePasse) {
        this.utilisateurRepository = utilisateurRepository;
        this.encodeurMotDePasse = encodeurMotDePasse;
    }

    public Utilisateur trouver(String idCompte) {
        return utilisateurRepository.findById(Long.valueOf(idCompte))
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Compte introuvable"));
    }

    public Utilisateur modifier(String idCompte, CompteRequete requete) {
        Utilisateur utilisateur = trouver(idCompte);
        String email = requete.email().trim().toLowerCase();

        // L'e-mail reste unique : il ne doit pas déjà appartenir à un autre compte
        boolean emailPris = utilisateurRepository.findByEmailIgnoreCase(email)
                .filter(autre -> !autre.getId().equals(utilisateur.getId()))
                .isPresent();
        if (emailPris) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Un compte existe déjà avec cet e-mail");
        }

        utilisateur.setNom(requete.nom().trim());
        utilisateur.setEmail(email);
        return utilisateurRepository.save(utilisateur);
    }

    public void changerMotDePasse(String idCompte, MotDePasseRequete requete) {
        Utilisateur utilisateur = trouver(idCompte);
        if (!encodeurMotDePasse.matches(requete.ancien(), utilisateur.getMotDePasse())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "L'ancien mot de passe est incorrect");
        }
        utilisateur.setMotDePasse(encodeurMotDePasse.encode(requete.nouveau()));
        utilisateurRepository.save(utilisateur);
    }

    public void supprimer(String idCompte) {
        Utilisateur utilisateur = trouver(idCompte);
        if (Role.ADMIN.name().equals(utilisateur.getRole())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN,
                    "Un compte administrateur ne peut pas être supprimé depuis l'application");
        }
        // La base supprime ses favoris (ON DELETE CASCADE) ; un déclencheur anonymise ses avis
        utilisateurRepository.delete(utilisateur);
    }
}
