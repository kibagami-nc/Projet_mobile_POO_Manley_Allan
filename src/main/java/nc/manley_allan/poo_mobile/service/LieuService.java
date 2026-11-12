package nc.manley_allan.poo_mobile.service;

import nc.manley_allan.poo_mobile.controller.dto.LieuRequete;
import nc.manley_allan.poo_mobile.entity.Categorie;
import nc.manley_allan.poo_mobile.entity.Lieu;
import nc.manley_allan.poo_mobile.enums.Province;
import nc.manley_allan.poo_mobile.repository.CategorieRepository;
import nc.manley_allan.poo_mobile.repository.LieuRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

/** Catalogue des lieux : recherche (tout le monde) et gestion (administrateur). */
@Service
public class LieuService {

    private final LieuRepository lieuRepository;
    private final CategorieRepository categorieRepository;

    public LieuService(LieuRepository lieuRepository, CategorieRepository categorieRepository) {
        this.lieuRepository = lieuRepository;
        this.categorieRepository = categorieRepository;
    }

    public List<Lieu> rechercher(String recherche, Long categorieId, String province) {
        // "poule" devient "%poule%" : le nom doit CONTENIR le texte, sans tenir compte des majuscules
        String motif = "%" + (recherche == null ? "" : recherche.trim().toLowerCase()) + "%";
        String provinceFiltre = (province == null || province.isBlank()) ? null : verifierProvince(province);
        return lieuRepository.rechercher(motif, categorieId, provinceFiltre);
    }

    public Lieu trouver(Long id) {
        return lieuRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Lieu introuvable"));
    }

    public Lieu creer(LieuRequete requete) {
        Lieu lieu = new Lieu();
        remplir(lieu, requete);
        return lieuRepository.save(lieu);
    }

    public Lieu modifier(Long id, LieuRequete requete) {
        Lieu lieu = trouver(id);   // 404 si le lieu n'existe pas
        remplir(lieu, requete);
        return lieuRepository.save(lieu);
    }

    public void supprimer(Long id) {
        // La base supprime aussi ses photos, ses favoris et ses avis (ON DELETE CASCADE)
        lieuRepository.delete(trouver(id));
    }

    private void remplir(Lieu lieu, LieuRequete requete) {
        Categorie categorie = categorieRepository.findById(requete.categorieId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Catégorie inconnue"));
        lieu.setNom(requete.nom().trim());
        lieu.setDescription(requete.description() == null ? null : requete.description().trim());
        lieu.setProvince(verifierProvince(requete.province()));
        lieu.setLatitude(requete.latitude());
        lieu.setLongitude(requete.longitude());
        lieu.setCategorie(categorie);
    }

    /** La province doit être une valeur de l'énumération Province : SUD, NORD ou ILES. */
    private String verifierProvince(String province) {
        try {
            return Province.valueOf(province.trim().toUpperCase()).name();
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Province inconnue : SUD, NORD ou ILES");
        }
    }
}
