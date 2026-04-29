import 'package:bloc2_store/models/article.dart';
import 'package:flutter/foundation.dart';
import '../repository/local_storage.dart';

// ViewModel qui gère les articles favoris
// Utilise ChangeNotifier pour mettre à jour l'interface automatiquement
class FavoritesViewModel extends ChangeNotifier {
  // Accès au stockage local (sauvegarde des favoris)
  final LocalStorage _store;

  // Ensemble des IDs des articles favoris
  // Set = pas de doublons
  Set<int> _ids = {};

  // Constructeur avec injection optionnelle (utile pour les tests)
  FavoritesViewModel({LocalStorage? store}) : _store = store ?? LocalStorage();

  // Getter pour accéder aux IDs favoris
  Set<int> get ids => _ids;

  // Charge les favoris depuis le stockage local
  Future<void> load() async {
    // Récupère la liste des favoris (depuis stockage)
    List liste = await LocalStorage.loadFavorites();

    // Convertit la liste en Set (supprime les doublons)
    _ids = {...liste};

    // Notifie l'UI pour rafraîchir l'affichage
    notifyListeners();
  }

  // Ajoute ou supprime un favori (toggle)
  Future<void> toggle(int id) async {
    // Si l'article est déjà en favori → on le retire
    if (_ids.contains(id)) {
      await _store.removeFavorite(id);
      _ids.remove(id);
    } else {
      // Sinon → on l'ajoute
      await _store.addFavorite(id);
      _ids.add(id);
    }

    // Met à jour l'interface
    notifyListeners();
  }

  // Vérifie si un article est en favori
  bool isFav(int id) => _ids.contains(id);
}
