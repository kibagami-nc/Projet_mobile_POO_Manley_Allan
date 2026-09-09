package nc.manley_allan.poo_mobile.data;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;


@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Utilisateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Column(name = "nom")
    private String nom;
    @Column(name = "email")
    private String email;
    @Column(name = "mot_de_passe")
    private String mot_de_passe;
    @Column(name = "date_inscription")
    private LocalDate date_inscription;
    @Column(name = "role")
    private String role;
}