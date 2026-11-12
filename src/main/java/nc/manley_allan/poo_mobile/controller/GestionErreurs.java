package nc.manley_allan.poo_mobile.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.server.ResponseStatusException;

import java.util.Map;

/**
 * Transforme les erreurs en réponses JSON simples : { "message": "..." }.
 * L'application affiche ce message à l'utilisateur.
 */
@RestControllerAdvice
public class GestionErreurs {

    // Erreurs lancées par les services : 404 lieu introuvable, 400 catégorie inconnue, 409 e-mail déjà utilisé...
    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Map<String, String>> erreurMetier(ResponseStatusException e) {
        String message = e.getReason() == null ? "Requête refusée" : e.getReason();
        return ResponseEntity.status(e.getStatusCode()).body(Map.of("message", message));
    }

    // Données invalides (@NotBlank, @Size... avec @Valid) : on renvoie le premier message
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> donneesInvalides(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().getFirst().getDefaultMessage();
        return ResponseEntity.badRequest().body(Map.of("message", message));
    }

    // Corps de requête absent ou qui n'est pas du JSON valide
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map<String, String>> corpsIllisible() {
        return ResponseEntity.badRequest().body(Map.of("message", "Données envoyées illisibles"));
    }
}
