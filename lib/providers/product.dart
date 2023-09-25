import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() async{
      final oldStatus = isFavorite;
      isFavorite = !isFavorite;
      final url = Uri.parse('https://e-commerce-app-3d863-default-rtdb.firebaseio.com/products.json');
      final response = await http.patch(url , body:  json.encode({
        "isFavorite" : isFavorite,
      }));
    isFavorite = !isFavorite;
    notifyListeners();

  }
}
