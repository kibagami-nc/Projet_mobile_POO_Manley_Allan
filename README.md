# Caillou Tour

Application mobile de découverte touristique de la Nouvelle-Calédonie.

Projet de fin d'année du BTS SIO option SLAM, réalisé en binôme par Manley et Allan pour Caillou Évasion, agence de tourisme réceptive basée à Nouméa (commanditaire fictif).

## Présentation

Caillou Tour permet à un visiteur de découvrir, localiser et rejoindre les lieux emblématiques du territoire depuis son smartphone : du parc zoologique et forestier Michel-Corbasson à la Poule de Hienghène, en passant par les îles Loyauté.

L'application repose sur une carte interactive OpenStreetMap centrée sur la Nouvelle-Calédonie et sur un catalogue de lieux administré par l'agence, couvrant les trois provinces (Sud, Nord, îles Loyauté).

## Acteurs

| Acteur | Rôle |
|---|---|
| Visiteur | Consulte la carte, les fiches lieux, recherche et filtre, sans compte. |
| Membre | Visiteur ayant créé un compte : gère ses favoris, dépose des avis et des notes. |
| Administrateur | Personnel de l'agence : gère le catalogue des lieux et catégories, modère les avis. |

## Fonctionnalités

Priorisation MoSCoW.

**Must**

- Carte interactive OpenStreetMap avec marqueurs cliquables.
- Fiche détaillée d'un lieu : photos, description, catégorie, commune, province, informations pratiques.
- Liste des lieux avec recherche par nom et filtres par catégorie et par province.
- Position de l'utilisateur sur la carte après consentement explicite.
- Inscription et connexion sécurisées (jeton JWT, mot de passe haché).
- Gestion des favoris pour le membre connecté.
- Administration intégrée : création, modification et suppression des lieux et des catégories, téléversement des photos.

**Should**

- Avis et notes de 1 à 5 étoiles, avec modération par l'administrateur.
- Bouton « Y aller » ouvrant l'application GPS du téléphone.
- Tri des lieux par distance, calculé sur le téléphone.
- Cache local pour consulter sans réseau les lieux déjà chargés.

**Could**

- Interface bilingue français / anglais.
- Circuits thématiques proposés par l'agence.
- Mode sombre.

## Architecture

Architecture trois tiers :

```
Application mobile Flutter  -->  API REST Java Spring Boot  -->  PostgreSQL
        (Android)                    (JSON / HTTPS)
```

L'application interroge en parallèle un serveur de tuiles OpenStreetMap pour le fond de carte, dans le respect de sa politique d'usage : attribution visible, identifiant d'application déclaré, cache respecté et aucun téléchargement massif de tuiles.

## Technologies

| Brique | Rôle |
|---|---|
| Flutter (Dart) | Application mobile Android. |
| flutter_map + latlong2 | Carte OpenStreetMap et marqueurs. |
| geolocator | Géolocalisation et calcul de distances sur le téléphone. |
| dio + flutter_secure_storage | Appels HTTP et stockage chiffré du jeton. |
| Spring Web + Spring Data JPA | API REST et persistance des entités. |
| Spring Security + jjwt | Authentification JWT, rôles MEMBRE / ADMIN, hachage BCrypt. |
| Liquibase | Versionnage du schéma de base de données. |
| PostgreSQL | Base de données relationnelle. |
| springdoc-openapi | Documentation Swagger de l'API. |

## Structure du dépôt

```
src/main/
  flutter/            Application mobile
    lib/
      pages/          Écrans (accueil, explorer, connexion, inscription...)
      models/         Modèles de données
      widgets/        Composants réutilisables
  java/nc/manley_allan/poo_mobile/
    entity/           Entités JPA
    model/            Objets métier non persistés (acteurs)
    enums/            Énumérations partagées
    repository/       Accès aux données
    service/          Logique métier
    controller/       API REST
  resources/
    db/changelog/     Changelog Liquibase
docs/                 Diagrammes et documents de conception
```

## Lancer le projet

### API Spring Boot

Prérequis : Java 26, PostgreSQL avec une base `caillou_tour`.

Renseigner les identifiants de connexion dans `src/main/resources/application.properties`, puis :

```
./mvnw spring-boot:run
```

Liquibase crée le schéma au démarrage.

### Application Flutter

Prérequis : Flutter 3.13 ou supérieur.

```
cd src/main/flutter
flutter pub get
flutter run
```

Par défaut, l'application vise `http://10.0.2.2:8080` sur l'émulateur Android et `http://localhost:8080` ailleurs. Sur un téléphone physique, donner l'adresse du PC :

```
flutter run --dart-define=API_URL=http://192.168.1.20:8080
```

### Comptes de démonstration

Créés par Liquibase (changeSet `11-comptes-demo`) pour la recette et la soutenance. À supprimer ou à changer avant une vraie mise en production.

| Rôle | E-mail | Mot de passe |
|---|---|---|
| Administrateur | admin@caillou-evasion.nc | `Admin-Caillou-2026` |
| Membre | membre@caillou-evasion.nc | `Membre-Caillou-2026` |

L'administrateur trouve le bouton « Administration des lieux » dans l'onglet « Mon compte ».

### Clé de signature des jetons

Les jetons JWT (valables 24 h) sont signés avec la propriété `caillou.jwt.secret`. Sa valeur par défaut ne sert qu'en développement : en production, la fournir par la variable d'environnement `CAILLOU_JWT_SECRET` (au moins 32 caractères).

### Tests

```
./mvnw test
```

16 tests JUnit 5 : le démarrage de l'application et 15 tests d'intégration de l'API (`ApiTest`, MockMvc) sur une base H2 en mémoire, sans PostgreSQL. Ils couvrent la connexion, l'inscription, l'accès selon le rôle, les lieux et le compte.

## API REST

Échanges en JSON. Les routes marquées « jeton » attendent l'en-tête `Authorization: Bearer <jeton>` renvoyé à la connexion.

| Méthode | Route | Accès | Rôle |
|---|---|---|---|
| POST | `/api/auth/register` | public | Inscription, renvoie le jeton |
| POST | `/api/auth/login` | public | Connexion, renvoie le jeton |
| GET | `/api/lieux?recherche=&categorie=&province=` | public | Lieux triés par nom, recherche et filtres facultatifs |
| GET | `/api/lieux/{id}` | public | Fiche d'un lieu |
| POST | `/api/lieux` | jeton ADMIN | Ajouter un lieu |
| PUT | `/api/lieux/{id}` | jeton ADMIN | Modifier un lieu |
| DELETE | `/api/lieux/{id}` | jeton ADMIN | Supprimer un lieu |
| GET | `/api/categories` | public | Catégories |
| GET | `/api/compte` | jeton | Consulter son compte (droit d'accès) |
| PUT | `/api/compte` | jeton | Modifier son pseudo et son e-mail (rectification) |
| PUT | `/api/compte/mot-de-passe` | jeton | Changer de mot de passe (l'ancien est vérifié) |
| DELETE | `/api/compte` | jeton | Supprimer son compte (effacement) |

Codes d'erreur : 400 données invalides, 401 non connecté ou identifiants faux, 403 rôle insuffisant, 404 lieu inconnu, 409 e-mail déjà utilisé. Les erreurs de saisie renvoient un message lisible : `{"message": "..."}`.

## Base de données

Le schéma et les données initiales (5 catégories, 16 lieux, 2 comptes de démonstration) sont versionnés par Liquibase dans `src/main/resources/db/changelog/db.changelog-master.yaml`. Sur PostgreSQL, le changelog ajoute aussi :

| Objet | Rôle |
|---|---|
| Vue `vue_lieu_note` | Note moyenne et nombre d'avis publiés de chaque lieu |
| Vue `vue_avis_en_attente` | Avis à modérer |
| Déclencheur `trg_anonymiser_avis` | À la suppression d'un compte, ses avis restent, sans son nom |
| Déclencheur `trg_avis_modifie` | Un avis dont la note ou le commentaire change repasse en modération |
| Procédure `moderer_avis(id, décision)` | Publie (`PUBLIE`) ou refuse (`REJETE`) un avis en attente |
| Procédure `supprimer_compte(email)` | Supprime un compte membre ; refuse un compte administrateur |

## Protection des données

Le projet applique les standards RGPD dès la conception : collecte minimale (e-mail, pseudonyme, mot de passe haché, favoris, avis), position GPS traitée uniquement sur le téléphone et jamais transmise au serveur, consultation, rectification et suppression du compte depuis l'application.

## Planning

| Période | Jalon |
|---|---|
| Septembre à octobre 2026 | Cahier des charges validé, maquettes, modèle de données |
| Novembre à décembre 2026 | API Spring Boot testable |
| Janvier 2027 | Prototype Flutter navigable |
| Février 2027 | Version bêta (fin des « Must ») |
| Mars 2027 | Version candidate (« Should ») |
| Avril 2027 | Livraison v1.0 |

## Livrables

- Application Android (APK signé) et code source Flutter et Spring Boot.
- API REST documentée (Swagger) et script de création de la base avec le jeu de données initial de 16 lieux.
- Documentation technique, manuel utilisateur et cahier de recette.

## Auteurs

Manley et Allan, BTS SIO SLAM.
