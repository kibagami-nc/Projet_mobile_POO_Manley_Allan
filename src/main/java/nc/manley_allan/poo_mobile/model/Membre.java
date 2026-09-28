package nc.manley_allan.poo_mobile.model;

import lombok.*;
import nc.manley_allan.poo_mobile.entity.Utilisateur;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Membre extends Visiteur {

    private Utilisateur utilisateur;
}
