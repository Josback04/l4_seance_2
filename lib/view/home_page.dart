import 'package:flutter/material.dart';
import 'package:l4_seance_2/auth_provider.dart';
import 'package:l4_seance_2/cart_provider.dart';
import 'package:l4_seance_2/controller/home_controller.dart';
import 'package:l4_seance_2/model/product_model.dart';
import 'package:l4_seance_2/view/cart_page.dart';
import 'package:l4_seance_2/view/login_page%20copy.dart';
import 'package:l4_seance_2/view/product_details_page.dart';
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
                onPressed: () async => _showImportDialog(context),
                icon: Icon(Icons.cloud_download)),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Déconnexion via le Provider
                context.read<AuthProviderr>().logout();

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
                  builder: (context, cart, child) {
                    return Badge(
                      label: Text(cart.itemCount.toString()),
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage())),
                      ),
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
                  child: Text('Erreur de chargement : ${snapshot.error}'),
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
                        foregroundImage: product.image_produit != null &&
                                product.image_produit!.isNotEmpty
                            ? NetworkImage(product.image_produit!)
                            : null,
                        child: product.image_produit == null ||
                                product.image_produit!.isEmpty
                            ? Icon(Icons.image)
                            : null,
                      ),
                      title: Text(product.nom_produit!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${product.prix_produit} \$"),
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
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                      product: product,
                                    )));
                      },
                    ),
                  );
                },
              );
            }));
  }

  void _showImportDialog(BuildContext context) async {
    final confirm = await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Importer le catalogue via API ? "),
                  content: Text(
                      "Ceci va télécharger tous les produits depuis L'API et les ajouter au catalogue"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Annuler')),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Importer'))
                  ],
                )) ??
        false;

    if (!confirm) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Import en cours...")),
    );

    final addedCount = await _controller.importFromApi();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Import terminé ! $addedCount produits ajoutés"),
        backgroundColor: Colors.green,
      ),
    );
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
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                // _controller.addProduct(nameCtl.text, priceCtl.text);

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
