import 'package:flutter/material.dart';
import 'model/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.prix_produit!);
  }

  void add(ProductModel product) {
    _items.add(product);
    print("Produit ajouté : ${product.nom_produit}");

    notifyListeners();
  }

  void remove(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
