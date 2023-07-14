import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:http/http.dart' as http;

const domain = 'flutter-shop-9bd88-default-rtdb.firebaseio.com';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.https(domain, '/orders.json');
    final data =
        json.decode((await http.get(url)).body) as Map<String, dynamic>?;
    if (data == null) return;
    final List<OrderItem> orders = [];
    data.forEach((key, value) {
      final products = (value['products'] as List<dynamic>)
          .map((e) => CartItem(
              id: e['id'],
              price: e['price'],
              title: e['title'],
              quantity: e['quantity']))
          .toList();
      orders.add(OrderItem(
          key,
          value['amount'],
          products,
          DateTime.fromMillisecondsSinceEpoch(
            value['dateTime'],
          )));
    });
    _orders = orders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.https(domain, '/orders.json');
    final dateTime = DateTime.now();
    final resp = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.millisecondsSinceEpoch,
          'products': products.map((e) => e.toMap()).toList()
        }));
    _orders.insert(0,
        OrderItem(json.decode(resp.body)['name'], total, products, dateTime));
    notifyListeners();
  }
}
