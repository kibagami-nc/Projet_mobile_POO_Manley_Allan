package nc.manley_allan.poo_mobile.data;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;


@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FavoriId implements Serializable {

    @Column(name = "utilisateur_id")
    private Long utilisateurId;

    @Column(name = "lieu_id")
    private Long lieuId;
}