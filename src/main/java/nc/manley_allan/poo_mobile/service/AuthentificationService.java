package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.ConnexionReponse;
import nc.manley_allan.poo_mobile.controller.dto.RegisterReponse;
import nc.manley_allan.poo_mobile.controller.dto.UtilisateurDto;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import nc.manley_allan.poo_mobile.enums.Role;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;
import java.util.UUID;

@Service
public class AuthentificationService {

    private final UtilisateurRepository utilisateurRepository;

    public AuthentificationService(UtilisateurRepository utilisateurRepository) {
        this.utilisateurRepository = utilisateurRepository;
    }

    public Optional<ConnexionReponse> connexion(String email, String motDePasse) {

        return utilisateurRepository.findByEmailIgnoreCase(email.trim())
                .filter(utilisateur -> motDePasse.equals(utilisateur.getMotDePasse()))
                .map(utilisateur -> new ConnexionReponse(
                        UUID.randomUUID().toString(),
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
        nouvelUtilisateur.setMotDePasse(motDePasse); // N.B: Penser au hachage BCrypt plus tard si besoin
        // Colonnes NOT NULL : Hibernate envoie null au lieu du DEFAULT de la base
        nouvelUtilisateur.setDateInscription(LocalDate.now());
        nouvelUtilisateur.setRole(Role.MEMBRE.name());

        Utilisateur utilisateurSauvegarde = utilisateurRepository.save(nouvelUtilisateur);

        // Connecter immédiatement le nouvel utilisateur
        return Optional.of(new ConnexionReponse(
                UUID.randomUUID().toString(),
                UtilisateurDto.from(utilisateurSauvegarde)
        ));
    }
}