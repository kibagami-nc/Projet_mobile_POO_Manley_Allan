package nc.manley_allan.poo_mobile.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain chaineDeFiltres(HttpSecurity http, JwtService jwtService) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .httpBasic(basic -> basic.disable())
                .formLogin(form -> form.disable())
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(routes -> routes
                        // Page d'erreur de Spring et pré-vérifications CORS : toujours permises
                        // (sinon une erreur 400 ou 403 deviendrait un 401)
                        .requestMatchers("/error").permitAll()
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        // Catalogue : lecture ouverte à tous les visiteurs (M1, M2, M3)
                        .requestMatchers(HttpMethod.GET, "/api/lieux/**", "/api/categories/**").permitAll()
                        // Ajouter, modifier, supprimer un lieu ou une catégorie : administrateurs seulement (M7)
                        .requestMatchers("/api/lieux/**", "/api/categories/**").hasRole("ADMIN")
                        // Tout le reste : il faut être connecté (jeton valide)
                        .anyRequest().authenticated())

                // Sans jeton valide : 401 (non connecté). Connecté sans le bon rôle : 403 (interdit)
                .exceptionHandling(erreurs -> erreurs.authenticationEntryPoint(
                        new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))

                // Le filtre lit le jeton avant le traitement de la requête
                .addFilterBefore(new JwtFiltre(jwtService), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /** Hachage des mots de passe avec BCrypt : empreinte salée, impossible à inverser. */
    @Bean
    public PasswordEncoder encodeurMotDePasse() {
        return new BCryptPasswordEncoder();
    }

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
