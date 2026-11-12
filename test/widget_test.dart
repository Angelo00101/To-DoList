import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_do_list/main.dart';

Future<void> addTask(
  WidgetTester tester,
  String title, {
  bool important = false,
}) async {
  await tester.tap(find.text('Nuova attività'));
  await tester.pumpAndSettle();
  await tester.enterText(find.byType(TextFormField), title);
  if (important) {
    await tester.tap(find.byType(Switch));
    await tester.pump();
  }
  await tester.tap(find.text('Aggiungi attività'));
  await tester.pumpAndSettle();
}

String counterText(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('completed-counter'))).data!;

void main() {
  testWidgets('S2 variante: elenco vuoto mostra come aggiungere', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());
    expect(find.text('Nessuna attività'), findsOneWidget);
    expect(find.textContaining('Nuova attività'), findsWidgets);
  });

  testWidgets('S1: aggiunge attività, torna all\'elenco e mostra conferma', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());
    await addTask(tester, 'Studiare Flutter', important: true);

    expect(find.text('Le mie attività'), findsOneWidget);
    expect(find.text('Studiare Flutter'), findsOneWidget);
    expect(find.text('Importante'), findsOneWidget);
    expect(find.text('Da fare'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(counterText(tester), '0 di 1 completate');
  });

  testWidgets('S1 variante: titolo mancante, errore che scompare', (
    tester,
  ) async {
    await tester.pumpWidget(const TodoApp());
    await tester.tap(find.text('Nuova attività'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Aggiungi attività'));
    await tester.pumpAndSettle();
    expect(find.text('Il titolo è obbligatorio'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget); // ancora sul form

    await tester.enterText(find.byType(TextFormField), 'Fare la spesa');
    await tester.pump();
    expect(find.text('Il titolo è obbligatorio'), findsNothing);
  });

  testWidgets('S1 variante: rinuncia con il tasto indietro', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.tap(find.text('Nuova attività'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Non salvare');

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Nessuna attività'), findsOneWidget);
    expect(find.text('Non salvare'), findsNothing);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('S3: segna come completata e riporta a da fare', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await addTask(tester, 'A');
    await addTask(tester, 'B');
    expect(counterText(tester), '0 di 2 completate');

    await tester.tap(find.text('A'));
    await tester.pump();
    expect(counterText(tester), '1 di 2 completate');
    expect(find.text('Completata'), findsOneWidget);

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();
    expect(counterText(tester), '0 di 2 completate');
  });

  testWidgets('S4: elimina con conferma, oppure rinuncia', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await addTask(tester, 'Da tenere');
    await addTask(tester, 'Da eliminare');
    await tester.tap(find.text('Da eliminare'));
    await tester.pump();
    expect(counterText(tester), '1 di 2 completate');

    // Rinuncia.
    await tester.tap(find.byTooltip('Elimina').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();
    expect(find.text('Da eliminare'), findsOneWidget);
    expect(counterText(tester), '1 di 2 completate');

    // Conferma.
    await tester.tap(find.byTooltip('Elimina').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Elimina'));
    await tester.pumpAndSettle();
    expect(find.text('Da eliminare'), findsNothing);
    expect(counterText(tester), '0 di 1 completate');
  });
}
