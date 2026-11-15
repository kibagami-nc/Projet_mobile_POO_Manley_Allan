package nc.manley_allan.poo_mobile.config;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import nc.manley_allan.poo_mobile.entity.Utilisateur;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

/**
 * Crée et vérifie les jetons JWT (JSON Web Token).
 * Un jeton contient l'identifiant du compte, son rôle (MEMBRE ou ADMIN) et une date d'expiration.
 * Il est signé avec une clé secrète connue du serveur seulement : s'il est modifié, il est refusé.
 */
@Service
public class JwtService {

    private final SecretKey cle;
    private final long dureeHeures;

    // En production, la clé vient de la variable d'environnement CAILLOU_JWT_SECRET (32 caractères minimum)
    public JwtService(@Value("${caillou.jwt.secret:cle-de-developpement-caillou-tour-a-changer-en-production}") String secret,
                      @Value("${caillou.jwt.duree-heures:24}") long dureeHeures) {
        this.cle = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
        this.dureeHeures = dureeHeures;
    }

    public String creerJeton(Utilisateur utilisateur) {
        Instant maintenant = Instant.now();
        return Jwts.builder()
                .subject(String.valueOf(utilisateur.getId()))
                .claim("role", utilisateur.getRole())
                .issuedAt(Date.from(maintenant))
                .expiration(Date.from(maintenant.plus(dureeHeures, ChronoUnit.HOURS)))
                .signWith(cle, Jwts.SIG.HS256)
                .compact();
    }

    /** Vérifie la signature et l'expiration du jeton, puis renvoie son contenu (JwtException sinon). */
    public Claims lireJeton(String jeton) {
        return Jwts.parser()
                .verifyWith(cle)
                .build()
                .parseSignedClaims(jeton)
                .getPayload();
    }
}
