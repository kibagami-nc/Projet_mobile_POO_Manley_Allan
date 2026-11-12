package nc.manley_allan.poo_mobile;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.security.autoconfigure.UserDetailsServiceAutoConfiguration;

// Les comptes sont dans la table utilisateur (jeton JWT) : pas d'utilisateur en mémoire généré par Spring
@SpringBootApplication(exclude = UserDetailsServiceAutoConfiguration.class)
public class PooMobileApplication {

	public static void main(String[] args) {
		SpringApplication.run(PooMobileApplication.class, args);
	}

}
