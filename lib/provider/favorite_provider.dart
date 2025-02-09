import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteids = [];
  List<String> get favorites => _favoriteids;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FavoriteProvider() {
    loadFavorites();
  }
  void toggleFavorite(DocumentSnapshot product) async {
    String productId = product.id;
    if (_favoriteids.contains(productId)) {
      _favoriteids.remove(productId);
      await _removeFavoriteId(productId);
    } else {
      _favoriteids.add(productId);
      await _addFavoriteId(productId);
    }
    notifyListeners();
  }

  bool isExist(DocumentSnapshot product) {
    return _favoriteids.contains(product.id);
  }

  Future<void> _addFavoriteId(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).set({
        'isFavorite': true,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _removeFavoriteId(String productId) async {
    try {
      await _firestore.collection("userFavorite").doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadFavorites() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection("userFavorite").get();
      _favoriteids = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
