import 'package:flutter/material.dart';
import 'package:l4_seance_2/controller/home_controller.dart';
import 'package:l4_seance_2/model/product_model.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nos Produits"),
        ),
        body: StreamBuilder(
            stream: _controller.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Erreur de chargement !!'),
                );
              }

              List<ProductModel> products = snapshot.data!;

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(product.nom_produit![0]),
                        backgroundColor: Colors.blueAccent,
                      ),
                      title: Text(product.nom_produit!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              );
            }));
  }
}
