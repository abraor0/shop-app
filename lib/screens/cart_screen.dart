import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final totalAmount = cart.totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Chip(
                    label: Text(
                      '\$${totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addOrder(cart.items.values.toList(), totalAmount);
                      cart.clear();
                    },
                    child: const Text('Order now'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final cartItem = cart.items.values.toList()[index];
                final productId = cart.items.keys.toList()[index];

                return CartItem(
                  id: cartItem.id,
                  productId: productId,
                  title: cartItem.title,
                  quantity: cartItem.quantity,
                  price: cartItem.price,
                );
              },
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
