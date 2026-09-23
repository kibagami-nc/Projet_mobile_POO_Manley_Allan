package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.ConnexionReponse;
import nc.manley_allan.poo_mobile.controller.dto.UtilisateurDto;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.Optional;

/**
 * Vérification des identifiants et ouverture de session.
 */
@Service
public class AuthentificationService {

    private final UtilisateurRepository utilisateurRepository;
    private final PasswordEncoder encodeurMotDePasse;
    private final SecureRandom aleatoire = new SecureRandom();

    /**
     * Hachage valide ne correspondant à aucun compte, calculé une fois au
     * démarrage. Sert uniquement à occuper le processeur quand l'adresse est
     * inconnue (voir {@link #connexion}).
     */
    private final String hachageLeurre;

    public AuthentificationService(UtilisateurRepository utilisateurRepository,
                                   PasswordEncoder encodeurMotDePasse) {
        this.utilisateurRepository = utilisateurRepository;
        this.encodeurMotDePasse = encodeurMotDePasse;
        this.hachageLeurre = encodeurMotDePasse.encode(
                "compte-inexistant-" + aleatoire.nextLong());
    }

    /**
     * Vérifie un couple e-mail / mot de passe.
     *
     * Renvoie la même absence de résultat que l'adresse soit inconnue ou que
     * le mot de passe soit faux : sinon, l'écart de réponse permettrait de
     * deviner quelles adresses sont inscrites.
     *
     * @return le jeton et le compte, ou {@link Optional#empty()} si le couple
     *         est invalide
     */
    @Transactional(readOnly = true)
    public Optional<ConnexionReponse> connexion(String email, String motDePasse) {
        Optional<Utilisateur> compte =
                utilisateurRepository.findByEmailIgnoreCase(email.trim());

        if (compte.isEmpty()) {
            // Comparaison sur un leurre : le temps de réponse reste comparable
            // à celui d'un compte existant, les adresses inscrites ne sont donc
            // pas devinables au chronomètre.
            encodeurMotDePasse.matches(motDePasse, hachageLeurre);
            return Optional.empty();
        }

        Utilisateur utilisateur = compte.get();
        if (!encodeurMotDePasse.matches(motDePasse, utilisateur.getMotDePasse())) {
            return Optional.empty();
        }

        return Optional.of(new ConnexionReponse(
                genererJeton(),
                UtilisateurDto.depuis(utilisateur)));
    }

    /**
     * Produit le jeton de session renvoyé au téléphone.
     *
     * Jeton opaque tiré au hasard, pour l'instant : il prouve que la connexion
     * a réussi mais aucune route ne sait encore le vérifier. Le passage au JWT
     * signé prévu au cahier des charges ne touche que cette méthode, plus
     * l'ajout de la dépendance jjwt et d'un filtre de validation.
     */
    private String genererJeton() {
        byte[] octets = new byte[32];
        aleatoire.nextBytes(octets);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(octets);
    }
}
