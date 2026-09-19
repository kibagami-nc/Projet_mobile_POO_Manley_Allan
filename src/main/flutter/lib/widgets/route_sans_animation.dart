import 'package:flutter/material.dart';

/// Route sans aucune durée de transition, à l'ouverture comme au retour.
///
/// `MaterialPageRoute` garde une durée de 300 ms même quand l'animation
/// est masquée par le thème : la page fermée ne disparaît qu'à la fin de ce
/// délai. Ici, les deux durées sont à zéro, donc le changement est immédiat.
class RouteSansAnimation<T> extends MaterialPageRoute<T> {
  RouteSansAnimation({required super.builder});

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;
}
