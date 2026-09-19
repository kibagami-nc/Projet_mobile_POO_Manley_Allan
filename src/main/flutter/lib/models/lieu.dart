// ------------------------------------
//
//  Le contenue de ce fichier est temporaire
//  A refaire en interrogeant la BDD
//
// ------------------------------------

class Lieu {
  final String nom;
  final String description;
  final String province;

  const Lieu({
    required this.nom,
    required this.description,
    required this.province,
  });
}

/// Favoris d'exemple, en attendant les données du backend.
const List<Lieu> lieuxFavoris = [
  Lieu(
    nom: 'Baie des Citrons',
    description: 'Plage en ville, idéale pour la baignade.',
    province: 'Province Sud',
  ),
  Lieu(
    nom: 'Île des Pins',
    description: 'Piscine naturelle et baie d’Oro.',
    province: 'Province Sud',
  ),
  Lieu(
    nom: 'Cœur de Voh',
    description: 'Mangrove en forme de cœur, vue du ciel.',
    province: 'Province Nord',
  ),
  Lieu(
    nom: 'Poé',
    description: 'Lagon turquoise et plage de sable blanc.',
    province: 'Province Sud',
  ),
  Lieu(
    nom: 'Lifou',
    description: 'Falaises de Jokin et plage de Luengoni.',
    province: 'Îles Loyauté',
  ),
];
