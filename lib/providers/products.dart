import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(
          'https://e-commerce-app-3d863-default-rtdb.firebaseio.com/products.json'));
      var extractedData =
          jsonDecode(response.body.toString()) as Map<String, dynamic>;
      List<Product> loadedProduct = [];
      // print(json.decode(response.body));
      if (response.statusCode == 200) {
        extractedData.forEach((prodId, prodData) {
          loadedProduct.add(Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            price: prodData["price"],
            imageUrl: prodData["imageUrl"],
            isFavorite: prodData["isFavorite"],
          ));
        });
        print('Loaded products length: ${loadedProduct.length}');
        _items = loadedProduct;
        notifyListeners();
        print(_items.length);
        print('_items length: ${_items.length}');
      } else {
        print("error occur");
      }
    } catch (error) {
      print('Error in fetchProducts: $error');
    }
    return _items;

  }


  Future<void> addProduct(Product product) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://e-commerce-app-3d863-default-rtdb.firebaseio.com/products.json'));
    try {
      request.body = json.encode({
        "title": product.title,
        "description": product.description,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "isFavorite": product.isFavorite
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final responseBody =
            await response.stream.bytesToString(); // Decode the response body
        print(responseBody);
        print("printed");
        final responseData = json.decode(responseBody); // Parse the JSON string
        final newProduct = Product(
          id: responseData['name'], // assuming the database assigns an ID
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
        );
        _items.add(newProduct);

        notifyListeners();
      } else {
        print(response.reasonPhrase);
        print("fail");
        // Handle the case where the POST request failed
        // You might want to log an error or show an error message to the user.
      }
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProducts(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://e-commerce-app-3d863-default-rtdb.firebaseio.com/products/$id.json');

      try {
        final response = await http.patch(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
            "isFavorite": newProduct.isFavorite,
          }),
        );

        if (response.statusCode == 200) {
          // Update the product in your local list
          _items[prodIndex] = newProduct;
          notifyListeners();
        } else {
          // Handle the case where the PATCH request failed
          print(
              'Failed to update product. Status code: ${response.statusCode}');
        }
      } catch (error) {
        // Handle network errors or exceptions here
        print('Error updating product: $error');
      }
    } else {
      print("Product with id $id not found.");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://e-commerce-app-3d863-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    final response = await http.delete(url).then((response) {
      // existingProduct = null; this cannot happen due to null safety a product cannot be null
      if (response.statusCode >= 400) {
        throw const HttpException("Could not delete products");
      }
    }).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
