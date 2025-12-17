import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  const ProductModel(
      {required this.id,
      required this.nom_produit,
      required this.description_produit,
      required this.prix_produit});

  final String? id;
  final String? nom_produit;
  final String? description_produit;
  final int? prix_produit;

  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      nom_produit: data['nom_produit'],
      description_produit: data['description_produit'],
      prix_produit: data['prix_produit'],
    );
  }
}
