package nc.manley_allan.poo_mobile.entity;

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
    @MapsId("utilisateurId")
    @JoinColumn(name = "utilisateur_id")
    private Utilisateur utilisateur;

    @ManyToOne
    @MapsId("lieuId")
    @JoinColumn(name = "lieu_id")
    private Lieu lieu;
}