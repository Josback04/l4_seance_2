import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:l4_seance_2/api_service.dart';
import 'package:l4_seance_2/model/product_model.dart';

class HomeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final apiservice = ApiService();
  int count = 0;

  Stream<List<ProductModel>> getProducts() {
    return _db.collection('Produits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<int> importFromApi() async {
    final apiData = await apiservice.fetchProducts();

    if (apiData.isEmpty) return 0;

    for (var item in apiData) {
      final nom_produit = item['title'].toString();
      final description_produit = item['description'];

      final prix_produit = (item['price'] is int)
          ? (item['price'] as int).toDouble()
          : (item['price'] as double);

      // Ajouter les données de l'API dans la base de données

      await _db.collection('Produits').add({
        'nom_produit': nom_produit,
        'description_produit': description_produit,
        'prix_produit': prix_produit,
      });
      count++;
    }
    return count;
  }

  // Future<void> addProduct(String name, String priceStr) async {
  //   if (name.isEmpty || priceStr.isEmpty) return;

  //   int price = int.tryParse(priceStr.replaceAll(',', '.')) ?? 0;

  //   await _db.collection('Produits').add({
  //     'nom_produit': name,
  //     'prix_produit': price,
  //   });
  // }
}
