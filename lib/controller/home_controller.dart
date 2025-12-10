import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:l4_seance_2/model/product_model.dart';

class HomeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProducts() {
    return _db.collection('Produits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addProduct(String name, String priceStr) async {
    if (name.isEmpty || priceStr.isEmpty) return;

    int price = int.tryParse(priceStr.replaceAll(',', '.')) ?? 0;

    await _db.collection('Produits').add({
      'name': name,
      'price': price,
    });
  }
}
