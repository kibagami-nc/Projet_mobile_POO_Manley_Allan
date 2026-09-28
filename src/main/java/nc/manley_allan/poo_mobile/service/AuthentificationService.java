package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.ConnexionReponse;
import nc.manley_allan.poo_mobile.controller.dto.UtilisateurDto;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

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
                        UtilisateurDto.from(utilisateur)));
    }
}
