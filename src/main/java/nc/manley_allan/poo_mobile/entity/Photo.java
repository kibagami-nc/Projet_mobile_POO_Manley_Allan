package nc.manley_allan.poo_mobile.entity;

import jakarta.persistence.*;
import lombok.*;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Photo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "url")
    private String url;
    @Column(name = "taille_ko")
    private int tailleKo;

    // --- CLÉS ÉTRANGÈRES / RELATIONS ---

    @ManyToOne
    @JoinColumn(name = "lieu_id")
    private Lieu lieuId;
}
