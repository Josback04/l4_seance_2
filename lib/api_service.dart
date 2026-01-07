import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://fakestoreapi.com/";

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("${baseUrl}products"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Erreur lors de la récupération des produits");
      }
    } catch (e) {
      print("Voci l'exception : $e");
      return [];
    }
  }
}
