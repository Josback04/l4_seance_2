import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:l4_seance_2/api_service.dart';
import 'package:l4_seance_2/model/product_model.dart';

class HomeController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ApiService _apiService = ApiService();

  Stream<List<ProductModel>> getProducts() {
    return _db.collection('Produits').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<int> importFromApi() async {
    final apiData = await _apiService.fetchProducts();

    if (apiData.isEmpty) return 0;

    int count = 0;

    for (var item in apiData) {
      final name = item['title'].toString();

      final price = (item['price'] is int)
          ? (item['price'] as int).toDouble()
          : (item['price'] as double).toDouble();

      final image = item['image'];

      final description = item['description'];

      await _db.collection('Produits').add({
        'nom_produit': name,
        'prix_produit': price,
        'image_produit': image,
        'description_produit': description,
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
