package nc.manley_allan.poo_mobile;

import com.jayway.jsonpath.JsonPath;
import nc.manley_allan.poo_mobile.config.JwtService;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import nc.manley_allan.poo_mobile.repository.CategorieRepository;
import nc.manley_allan.poo_mobile.repository.UtilisateurRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Tests d'intégration : l'API complète est démarrée (sécurité, contrôleurs, services, base H2)
 * et appelée comme le ferait l'application mobile, grâce à MockMvc.
 * Liquibase a inséré les 16 lieux, les 5 catégories et les comptes de démonstration.
 */
@SpringBootTest
@AutoConfigureMockMvc
class ApiTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private JwtService jwtService;
    @Autowired
    private UtilisateurRepository utilisateurRepository;
    @Autowired
    private CategorieRepository categorieRepository;

    /** Jeton du compte administrateur de démonstration (créé par Liquibase). */
    private String jetonAdmin() {
        Utilisateur admin = utilisateurRepository.findByEmailIgnoreCase("admin@caillou-evasion.nc").orElseThrow();
        return "Bearer " + jwtService.creerJeton(admin);
    }

    /** Crée un membre par l'API et renvoie son jeton. */
    private String inscrire(String email) throws Exception {
        String reponse = mockMvc.perform(post("/api/auth/register").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nom\":\"Test\",\"email\":\"" + email + "\",\"motDePasse\":\"MotDePasse2026\"}"))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        return "Bearer " + JsonPath.read(reponse, "$.token");
    }

    private String lieuJson(String nom, double latitude) {
        Long plage = categorieRepository.findAllByOrderByLibelleAsc().stream()
                .filter(c -> c.getLibelle().equals("Plage")).findFirst().orElseThrow().getId();
        return "{\"nom\":\"" + nom + "\",\"description\":\"Lieu de test\",\"province\":\"SUD\","
                + "\"latitude\":" + latitude + ",\"longitude\":166.5,\"categorieId\":" + plage + "}";
    }

    // ------------------------------------------------------------ Lieux (M1, M2, M3)

    @Test
    void unVisiteur_peutLireLesLieuxEtLesCategories() throws Exception {
        mockMvc.perform(get("/api/lieux")).andExpect(status().isOk());
        mockMvc.perform(get("/api/categories")).andExpect(status().isOk()).andExpect(jsonPath("$", hasSize(5)));
    }

    @Test
    void laRecherche_filtreParNomEtParProvince() throws Exception {
        mockMvc.perform(get("/api/lieux").param("recherche", "POULE"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].nom").value("La Poule de Hienghène"));

        mockMvc.perform(get("/api/lieux").param("province", "ILES"))
                .andExpect(jsonPath("$", hasSize(3)));
    }

    @Test
    void uneProvinceInconnue_estRefuseeAvecUnMessage() throws Exception {
        mockMvc.perform(get("/api/lieux").param("province", "MARS"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("Province inconnue : SUD, NORD ou ILES"));
    }

    @Test
    void unLieuInexistant_renvoie404() throws Exception {
        mockMvc.perform(get("/api/lieux/99999")).andExpect(status().isNotFound());
    }

    // ------------------------------------------------------------ Administration (M7)

    @Test
    void unVisiteur_nePeutPasCreerDeLieu() throws Exception {
        mockMvc.perform(post("/api/lieux").contentType(MediaType.APPLICATION_JSON).content(lieuJson("Visiteur", -22.3)))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void unMembre_nePeutPasCreerDeLieu() throws Exception {
        String jetonMembre = inscrire("membre.test@caillou.nc");
        mockMvc.perform(post("/api/lieux").header("Authorization", jetonMembre)
                        .contentType(MediaType.APPLICATION_JSON).content(lieuJson("Membre", -22.3)))
                .andExpect(status().isForbidden());
    }

    @Test
    void unAdmin_creeModifieEtSupprimeUnLieu() throws Exception {
        String jeton = jetonAdmin();
        String reponse = mockMvc.perform(post("/api/lieux").header("Authorization", jeton)
                        .contentType(MediaType.APPLICATION_JSON).content(lieuJson("Belvédère de test", -22.3)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.categorie.libelle").value("Plage"))
                .andReturn().getResponse().getContentAsString();
        Integer id = JsonPath.read(reponse, "$.id");

        mockMvc.perform(put("/api/lieux/" + id).header("Authorization", jeton)
                        .contentType(MediaType.APPLICATION_JSON).content(lieuJson("Belvédère modifié", -22.3)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nom").value("Belvédère modifié"));

        mockMvc.perform(delete("/api/lieux/" + id).header("Authorization", jeton)).andExpect(status().isNoContent());
        mockMvc.perform(get("/api/lieux/" + id)).andExpect(status().isNotFound());
    }

    @Test
    void unLieuHorsDeNouvelleCaledonie_estRefuse() throws Exception {
        mockMvc.perform(post("/api/lieux").header("Authorization", jetonAdmin())
                        .contentType(MediaType.APPLICATION_JSON).content(lieuJson("Tour Eiffel", 48.85)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value("La latitude doit être comprise entre -24 et -18,5 (Nouvelle-Calédonie)"));
    }

    @Test
    void unJetonModifie_estRefuse() throws Exception {
        mockMvc.perform(post("/api/lieux").header("Authorization", jetonAdmin() + "x")
                        .contentType(MediaType.APPLICATION_JSON).content(lieuJson("Jeton modifié", -22.3)))
                .andExpect(status().isUnauthorized());
    }

    // ------------------------------------------------------------ Comptes (M5, RGPD)

    @Test
    void inscription_hacheLeMotDePasseEtRenvoieUnJeton() throws Exception {
        inscrire("hachage@caillou.nc");
        Utilisateur compte = utilisateurRepository.findByEmailIgnoreCase("hachage@caillou.nc").orElseThrow();
        assertThat(compte.getMotDePasse()).startsWith("$2a$").isNotEqualTo("MotDePasse2026");
        assertThat(compte.getRole()).isEqualTo("MEMBRE");
    }

    @Test
    void connexion_verifieLeMotDePasse() throws Exception {
        inscrire("connexion@caillou.nc");
        mockMvc.perform(post("/api/auth/login").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"connexion@caillou.nc\",\"motDePasse\":\"MotDePasse2026\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token", startsWith("eyJ")));
        mockMvc.perform(post("/api/auth/login").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"connexion@caillou.nc\",\"motDePasse\":\"mauvais\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void inscription_avecUnEmailDejaUtilise_estRefusee() throws Exception {
        inscrire("doublon@caillou.nc");
        mockMvc.perform(post("/api/auth/register").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nom\":\"Test\",\"email\":\"doublon@caillou.nc\",\"motDePasse\":\"MotDePasse2026\"}"))
                .andExpect(status().isConflict());
    }

    @Test
    void leCompte_estReserveAuMembreConnecte() throws Exception {
        mockMvc.perform(get("/api/compte")).andExpect(status().isUnauthorized());

        String jeton = inscrire("compte@caillou.nc");
        mockMvc.perform(get("/api/compte").header("Authorization", jeton))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("compte@caillou.nc"));
        mockMvc.perform(put("/api/compte").header("Authorization", jeton).contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nom\":\"Nouveau pseudo\",\"email\":\"compte@caillou.nc\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nom").value("Nouveau pseudo"));
    }

    @Test
    void unMembre_peutSupprimerSonCompte() throws Exception {
        String jeton = inscrire("supprime@caillou.nc");
        mockMvc.perform(delete("/api/compte").header("Authorization", jeton)).andExpect(status().isNoContent());
        mockMvc.perform(post("/api/auth/login").contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"supprime@caillou.nc\",\"motDePasse\":\"MotDePasse2026\"}"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    void unAdministrateur_nePeutPasSupprimerSonCompte() throws Exception {
        mockMvc.perform(delete("/api/compte").header("Authorization", jetonAdmin()))
                .andExpect(status().isForbidden());
    }
}
