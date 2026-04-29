import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bloc2_store/screens/cart.dart';
import 'package:bloc2_store/viewmodels/cart_view_model.dart';

void main() {
  // Groupe de tests pour l'écran Ecran1
  group('Ecran1 (Tâches générées aléatoirement)', () {
    // Test : vérifie que la liste de tâches s'affiche
    testWidgets('affiche une liste de tâches', (WidgetTester tester) async {
      // --- ARRANGE ---
      // Création du ViewModel et génération de tâches fictives
      final cartViewModel = CartViewModel();
      await cartViewModel.generateTasks();

      // Injection du ViewModel dans l'arbre des widgets avec Provider
      await tester.pumpWidget(
        ChangeNotifierProvider<CartViewModel>.value(
          value: cartViewModel,
          child: const MaterialApp(
            home: Scaffold(
              body: Ecran1(), // écran testé
            ),
          ),
        ),
      );

      // Attend que tous les widgets soient rendus
      await tester.pumpAndSettle();

      // --- ASSERT ---
      // Vérifie la présence des composants principaux de la liste
      expect(find.byType(Card), findsWidgets); // chaque tâche est dans une Card
      expect(find.byType(ListTile), findsWidgets); // structure des items
      expect(find.byType(CircleAvatar), findsWidgets); // avatar affiché
      expect(find.byType(Card), findsWidgets);
    });

    // Test : vérifie que les données des tâches sont bien affichées
    testWidgets('affiche les informations des tâches correctement',
        (WidgetTester tester) async {
      final cartViewModel = CartViewModel();
      await cartViewModel.generateTasks();

      await tester.pumpWidget(
        ChangeNotifierProvider<CartViewModel>.value(
          value: cartViewModel,
          child: const MaterialApp(
            home: Scaffold(
              body: Ecran1(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // --- ASSERT ---
      // Vérifie la présence de textes spécifiques
      expect(find.text('title 0'), findsOneWidget);
      expect(find.text('title 1'), findsOneWidget);
      expect(find.textContaining('tag 0'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    // Test : vérifie que chaque tâche possède un bouton d'édition
    testWidgets('affiche des boutons edit pour chaque tâche',
        (WidgetTester tester) async {
      final cartViewModel = CartViewModel();
      await cartViewModel.generateTasks();

      await tester.pumpWidget(
        ChangeNotifierProvider<CartViewModel>.value(
          value: cartViewModel,
          child: const MaterialApp(
            home: Scaffold(
              body: Ecran1(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // --- ASSERT ---
      // Vérifie qu'il existe des icônes "edit"
      expect(find.byIcon(Icons.edit), findsWidgets);
    });

    // Test : vérifie la navigation vers l'écran d'édition
    testWidgets(
        'navigue vers le formulaire d\'édition quand on clique sur edit',
        (WidgetTester tester) async {
      final cartViewModel = CartViewModel();
      await cartViewModel.generateTasks();

      await tester.pumpWidget(
        ChangeNotifierProvider<CartViewModel>.value(
          value: cartViewModel,
          child: const MaterialApp(
            home: Scaffold(
              body: Ecran1(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // --- ACT ---
      // Simule un clic sur le premier bouton edit
      final editButton = find.byIcon(Icons.edit).first;
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // --- ASSERT ---
      // Vérifie que l'écran d'édition s'affiche avec ses champs
      expect(find.text('Modifier la tâche'), findsOneWidget);
      expect(find.text('Titre'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Enregistrer'), findsOneWidget);
    });

    // Test : vérifie que les Cards utilisent le thème de l'application
    testWidgets('utilise le thème du contexte pour les Cards',
        (WidgetTester tester) async {
      final cartViewModel = CartViewModel();
      await cartViewModel.generateTasks();

      await tester.pumpWidget(
        ChangeNotifierProvider<CartViewModel>.value(
          value: cartViewModel,
          child: MaterialApp(
            theme: ThemeData.light(), // thème appliqué
            home: const Scaffold(
              body: Ecran1(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Récupère la première Card affichée
      final card = tester.widget<Card>(find.byType(Card).first);

      // Vérifie que la couleur de la Card est bien définie (vient du thème)
      expect(card.color, isNotNull);
    });
  });
}
