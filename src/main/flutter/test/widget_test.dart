import 'package:flutter_test/flutter_test.dart';

import 'package:poo_mobile_front/main.dart';

void main() {
  testWidgets('La barre de navigation affiche les trois onglets',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MonApp());

    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Recherche'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
