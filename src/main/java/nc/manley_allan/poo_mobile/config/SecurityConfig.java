package nc.manley_allan.poo_mobile.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Configuration de Spring Security pour une API consommée par un mobile.
 *
 * Sans cette classe, la seule présence de {@code spring-boot-starter-security}
 * protège toutes les routes derrière une authentification HTTP Basic : Flutter
 * recevrait un 401 avant même d'atteindre le contrôleur.
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain chaineDeFiltres(HttpSecurity http) throws Exception {
        http
                // Pas de formulaire ni de cookie de session : la protection CSRF
                // n'a pas d'objet et empêcherait les POST du téléphone.
                .csrf(csrf -> csrf.disable())
                .httpBasic(basic -> basic.disable())
                .formLogin(form -> form.disable())
                // Chaque appel porte ses propres identifiants, le serveur ne
                // garde aucun état entre deux requêtes.
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(routes -> routes
                        // La connexion doit rester ouverte, sinon personne
                        // ne pourrait jamais obtenir de jeton.
                        .requestMatchers("/api/auth/**").permitAll()
                        // Reste ouvert tant qu'aucun filtre ne sait valider un
                        // jeton : à refermer en .authenticated() le jour où le
                        // JWT et son filtre de vérification seront en place.
                        .anyRequest().permitAll());

        return http.build();
    }

    /**
     * Algorithme de hachage des mots de passe.
     * BCrypt intègre son propre sel, il n'y a pas de colonne à ajouter.
     */
    @Bean
    public PasswordEncoder encodeurMotDePasse() {
        return new BCryptPasswordEncoder();
    }

    /**
     * Autorise les appels du navigateur en développement, utile si le front
     * est lancé avec {@code flutter run -d chrome}. Sans effet sur Android.
     */
    @Bean
    public WebMvcConfigurer configurationCors() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registre) {
                registre.addMapping("/api/**")
                        .allowedOriginPatterns("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS");
            }
        };
    }
}
