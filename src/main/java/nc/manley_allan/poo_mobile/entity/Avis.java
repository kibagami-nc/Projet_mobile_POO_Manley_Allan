package nc.manley_allan.poo_mobile.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Avis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "note")
    private int note;

    @Column(name = "commentaire")
    private String commentaire;

    @Column(name = "date_publication")
    private LocalDate datePublication;

    @Column(name = "statut")
    private String statut;

    @Column(name = "anonyme")
    private boolean anonyme;

    // --- CLÉS ÉTRANGÈRES / RELATIONS ---
    @ManyToOne
    @JoinColumn(name = "lieu_id") // Indique le nom de la colonne FK en BDD
    private Lieu lieu;

    @ManyToOne
    @JoinColumn(name = "utilisateur_id") // Indique le nom de la colonne FK en BDD
    private Utilisateur utilisateur;
}
