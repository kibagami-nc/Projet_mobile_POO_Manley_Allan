import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'pages/menu.dart';

void main() {
  runApp(const MonApp());
}

/// Transition de page sans aucune animation : la nouvelle page s'affiche directement.
class _SansTransition extends PageTransitionsBuilder {
  const _SansTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

/// Permet de faire défiler les listes en glissant à la souris (bureau),
/// en plus du doigt et du pavé tactile.
class _DefilementSouris extends MaterialScrollBehavior {
  const _DefilementSouris();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        ...super.dragDevices,
        PointerDeviceKind.mouse,
      };
}

class MonApp extends StatelessWidget {
  const MonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _DefilementSouris(),
      theme: ThemeData(
        // Aucune animation lors des changements de page.
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (final plateforme in TargetPlatform.values)
              plateforme: const _SansTransition(),
          },
        ),
        // Aucun effet "ripple" / surbrillance animée au toucher.
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // Aucune animation d'élévation ou de couleur sur les boutons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            animationDuration: Duration.zero,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            animationDuration: Duration.zero,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            animationDuration: Duration.zero,
            splashFactory: NoSplash.splashFactory,
          ),
        ),
        checkboxTheme: const CheckboxThemeData(splashRadius: 0),
      ),
      home: const Menu(),
    );
  }
}
