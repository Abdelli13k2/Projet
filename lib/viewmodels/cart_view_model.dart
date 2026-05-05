import 'package:flutter/foundation.dart';
import '../repository/local_storage.dart';

// ViewModel qui gère l'état du panier
// Il utilise ChangeNotifier pour notifier l'UI des changements
class CartViewModel extends ChangeNotifier {
  // Instance du stockage local (ex: SharedPreferences, base locale…)
  //final LocalStorage _store;

  // Map contenant les produits du panier
  // clé = id du produit, valeur = quantité
  Map<int, int> _cart = {};

  // ------------------ AJOUT POUR LES TESTS ------------------

  List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> generateTasks() async {
    _tasks = List.generate(
      5,
      (index) => Task(
        title: 'title $index',
        description: 'description $index',
        tag: 'tag $index',
      ),
    );

    notifyListeners();
  }

  // ------------------ FIN AJOUT ------------------

  // Constructeur avec injection optionnelle du stockage (utile pour les tests)
  //CartViewModel({LocalStorage? store}) : _store = store ?? LocalStorage();

  // Getter public en lecture seule (empêche modification directe depuis l'extérieur)
  Map<int, int> get cart => Map.unmodifiable(_cart);

  // Retourne la quantité d’un produit spécifique
  int qty(int id) => _cart[id] ?? 0;

  // Charge le panier depuis le stockage local
  Future<void> load() async {
    _cart = await LocalStorage.loadCart() ?? {}; // récupération des données
    notifyListeners(); // met à jour l'UI
  }

  // Ajoute un produit au panier (ou incrémente sa quantité)
  Future<void> add(int id) async {
    final q = (_cart[id] ?? 0) + 1; // quantité actuelle + 1
    _cart[id] = q;

    // Sauvegarde en base (commentée ici)
    // await _store.setCartQty(id, q);

    notifyListeners(); // notifie l'interface
  }

  // Retire une unité d’un produit
  Future<void> removeOne(int id) async {
    final q = (_cart[id] ?? 0) - 1;

    // Sauvegarde en base (commentée ici)
    // await _store.setCartQty(id, q);

    // Si quantité <= 0 → on supprime le produit du panier
    if (q <= 0)
      _cart.remove(id);
    else
      _cart[id] = q;

    notifyListeners(); // met à jour l'UI
  }

  // Vide complètement le panier
  Future<void> clear() async {
    // Suppression en base (commentée ici)
    // await _store.clearCart();

    _cart.clear(); // vide la Map
    notifyListeners(); // met à jour l'UI
  }
}

// ------------------ MODÈLE TASK (EN DEHORS DE LA CLASSE) ------------------

class Task {
  final String title;
  final String description;
  final String tag;

  Task({
    required this.title,
    required this.description,
    required this.tag,
  });
}
