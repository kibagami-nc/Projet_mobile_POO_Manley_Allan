package nc.manley_allan.poo_mobile.model;

import lombok.*;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Visiteur {

    private String langue = "FR";

    private boolean modeSombre = false;

    private boolean consentementGeoloc = false;
}
