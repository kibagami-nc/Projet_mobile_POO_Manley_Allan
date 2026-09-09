package nc.manley_allan.poo_mobile.data;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Lieu {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "nom")
    private String nom;

    @Column(name = "description")
    private String description;

    @Column(name = "province")
    private String province;

    @Column(name = "latitude")
    private double latitude;

    @Column(name = "longitude")
    private double longitude;

    // --- CLÉS ÉTRANGÈRES / RELATIONS ---

    @ManyToOne
    @Column(name = "categorie_id")
    private Categorie categorie;
}
