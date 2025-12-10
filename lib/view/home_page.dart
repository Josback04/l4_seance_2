import 'package:flutter/material.dart';
import 'package:l4_seance_2/auth_provider.dart';
import 'package:l4_seance_2/cart_provider.dart';
import 'package:l4_seance_2/controller/home_controller.dart';
import 'package:l4_seance_2/model/product_model.dart';
import 'package:l4_seance_2/view/login_page%20copy.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nos Produits"),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Déconnexion via le Provider
                context.read<AuthProvider>().logout();

                // Retour à la page de login
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Center(
                child: Consumer<CartProvider>(
                  // Le 'builder' se redéclenche à chaque 'notifyListeners'
                  builder: (context, cart, child) {
                    return Badge(
                      // Widget natif Flutter pour les notifications
                      label: Text(
                          cart.itemCount.toString()), // Le compteur dynamique !
                      child: Icon(Icons.shopping_cart),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddDialog(context);
          },
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<List<ProductModel>>(
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
                      subtitle: Text("${product.prix_produit}"),
                      trailing: IconButton(
                        onPressed: () {
                          final productClick = products[index];
                          context.read<CartProvider>().add(productClick);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    "${productClick.nom_produit} ajouté !"),
                                duration: Duration(milliseconds: 500)),
                          );
                        },
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 16,
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              );
            }));
  }

  void _showAddDialog(BuildContext context) {
    final TextEditingController nameCtl = TextEditingController();
    final TextEditingController priceCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Nouveau Produit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: InputDecoration(labelText: "Nom du produit"),
              ),
              TextField(
                controller: priceCtl,
                decoration: InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Ferme le dialog
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.addProduct(nameCtl.text, priceCtl.text);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Produit ajouté !")),
                );
              },
              child: Text("Ajouter"),
            ),
          ],
        );
      },
    );
  }
}
