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
