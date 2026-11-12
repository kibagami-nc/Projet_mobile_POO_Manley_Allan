package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.ConnexionReponse;
import nc.manley_allan.poo_mobile.controller.dto.RegisterReponse;
import nc.manley_allan.poo_mobile.controller.dto.UtilisateurDto;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import nc.manley_allan.poo_mobile.enums.Role;
import nc.manley_allan.poo_mobile.config.JwtService;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;

@Service
public class AuthentificationService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder encodeurMotDePasse;
    private final JwtService jwtService;

    public AuthentificationService(UtilisateurRepository utilisateurRepository, PasswordEncoder encodeurMotDePasse,
                                   JwtService jwtService) {
        this.utilisateurRepository = utilisateurRepository;
        this.encodeurMotDePasse = encodeurMotDePasse;
        this.jwtService = jwtService;
    }

    public Optional<ConnexionReponse> connexion(String email, String motDePasse) {

        return utilisateurRepository.findByEmailIgnoreCase(email.trim())
                // Compare le mot de passe saisi à l'empreinte BCrypt enregistrée
                .filter(utilisateur -> encodeurMotDePasse.matches(motDePasse, utilisateur.getMotDePasse()))
                .map(utilisateur -> new ConnexionReponse(
                        jwtService.creerJeton(utilisateur),
                        UtilisateurDto.from(utilisateur)));
    }

    public Optional<ConnexionReponse> register(String nom, String email, String motDePasse) {
        String emailNettoye = email.trim().toLowerCase();

        // Vérifier si l'email existe déjà
        if (utilisateurRepository.findByEmailIgnoreCase(emailNettoye).isPresent()) {
            return Optional.empty(); // Va déclencher le 409 CONFLICT
        }

        // Créer l'utilisateur
        Utilisateur nouvelUtilisateur = new Utilisateur();
        nouvelUtilisateur.setNom(nom.trim());
        nouvelUtilisateur.setEmail(emailNettoye);
        nouvelUtilisateur.setMotDePasse(encodeurMotDePasse.encode(motDePasse)); // jamais en clair : empreinte BCrypt
        // Colonnes NOT NULL : Hibernate envoie null au lieu du DEFAULT de la base
        nouvelUtilisateur.setDateInscription(LocalDate.now());
        nouvelUtilisateur.setRole(Role.MEMBRE.name());

        Utilisateur utilisateurSauvegarde = utilisateurRepository.save(nouvelUtilisateur);

        // Connecter immédiatement le nouvel utilisateur
        return Optional.of(new ConnexionReponse(
                jwtService.creerJeton(utilisateurSauvegarde),
                UtilisateurDto.from(utilisateurSauvegarde)
        ));
    }
}