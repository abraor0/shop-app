import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const domain = 'flutter-shop-9bd88-default-rtdb.firebaseio.com';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final currentFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(domain, '/products/$id.json');
    final resp =
        await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
    if (resp.statusCode >= 400) {
      isFavorite = currentFavoriteStatus;
      notifyListeners();
      throw const HttpException('Failed to modify product');
    }
  }
}
