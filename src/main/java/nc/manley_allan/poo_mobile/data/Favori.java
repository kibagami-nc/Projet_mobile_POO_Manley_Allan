package nc.manley_allan.poo_mobile.data;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "favori")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Favori {

    @EmbeddedId
    private FavoriId id;

    @ManyToOne
    @MapsId("utilisateurId") // Fait le lien avec l'attribut 'utilisateurId' de la classe FavoriId
    @JoinColumn(name = "utilisateur_id")
    private Utilisateur utilisateur;

    @ManyToOne
    @MapsId("lieuId") // Fait le lien avec l'attribut 'lieuId' de la classe FavoriId
    @JoinColumn(name = "lieu_id")
    private Lieu lieu;
}