import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

const domain = 'flutter-shop-9bd88-default-rtdb.firebaseio.com';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    final url = Uri.https(domain, '/products.json');
    final data =
        json.decode((await http.get(url)).body) as Map<String, dynamic>;
    final List<Product> products = [];
    data.forEach((key, value) {
      products.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price']));
    });
    _items = products;
    notifyListeners();
  }

  Future<void> addProduct(
      String title, String description, double price, String imageUrl) async {
    final url = Uri.https(domain, '/products.json');

    final resp = await http.post(
      url,
      body: json.encode({
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': false,
      }),
    );
    _items.add(Product(
      id: json.decode(resp.body)['name'],
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: false,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final itemIndex = _items.indexWhere(
      (element) => element.id == product.id,
    );
    if (itemIndex >= 0) {
      final url = Uri.https(domain, '/products/${product.id}.json');

      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[itemIndex] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    final product = _items[productIndex];
    if (productIndex >= 0) {
      _items.removeAt(productIndex);
      notifyListeners();

      final url = Uri.https(domain, '/products/$id.json');
      final resp = await http.delete(url);
      if (resp.statusCode >= 400) {
        _items.insert(productIndex, product);
        notifyListeners();
        throw const HttpException('Failed to delete product');
      }
    }
  }
}
