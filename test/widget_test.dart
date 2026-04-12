import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reisetagebuch/main.dart';

void main() {
  testWidgets('Basic app smoke test', (WidgetTester tester) async {
    // App starten
    await tester.pumpWidget(const MyApp());

    // Warten bis die Widgets gerendert sind
    await tester.pumpAndSettle();

    // Beispiel: Überprüfen, dass ein Text aus der LoginPage angezeigt wird
    expect(
      find.text('Login'),
      findsOneWidget,
    ); // Passe an, was auf deiner LoginPage steht

    // Beispiel: Prüfen, dass ein Icon (z.B. Add-Button) vorhanden ist
    expect(
      find.byIcon(Icons.add),
      findsNothing,
    ); // LoginPage hat noch keinen Add-Button
  });
}
