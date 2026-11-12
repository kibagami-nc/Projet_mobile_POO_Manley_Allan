package nc.manley_allan.poo_mobile.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

/**
 * Filtre exécuté avant chaque requête.
 * Si l'en-tête « Authorization: Bearer <jeton> » contient un jeton valide, le compte est considéré
 * comme connecté pendant la requête, avec son rôle (ROLE_MEMBRE ou ROLE_ADMIN).
 * Sinon la requête continue en tant que visiteur : SecurityConfig décide si elle est permise.
 */
public class JwtFiltre extends OncePerRequestFilter {

    private final JwtService jwtService;

    public JwtFiltre(JwtService jwtService) {
        this.jwtService = jwtService;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest requete, HttpServletResponse reponse, FilterChain chaine)
            throws ServletException, IOException {

        String entete = requete.getHeader("Authorization");

        if (entete != null && entete.startsWith("Bearer ")) {
            try {
                Claims contenu = jwtService.lireJeton(entete.substring(7));   // on enlève « Bearer »
                var role = new SimpleGrantedAuthority("ROLE_" + contenu.get("role", String.class));

                // Le « principal » de la requête est l'identifiant du compte
                var authentification = UsernamePasswordAuthenticationToken.authenticated(
                        contenu.getSubject(), null, List.of(role));
                SecurityContextHolder.getContext().setAuthentication(authentification);
            } catch (JwtException | IllegalArgumentException e) {
                // Jeton expiré ou modifié : la requête continue comme celle d'un visiteur
                SecurityContextHolder.clearContext();
            }
        }

        chaine.doFilter(requete, reponse);
    }
}
