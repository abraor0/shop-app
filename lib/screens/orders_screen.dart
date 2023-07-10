import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/main_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your orders'),
        ),
        drawer: MainDrawer(),
        body: ListView.builder(
          itemBuilder: (context, index) =>
              OrderItem(order: orderData.orders[index]),
          itemCount: orderData.orders.length,
        ));
  }
}
