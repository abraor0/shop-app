import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final totalAmount = cart.totalAmount;
    final scaffoldMessengerContext = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          if (_isLoading)
            LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.secondary,
              semanticsLabel: 'Fecthing products from server',
            ),
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            try {
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                      cart.items.values.toList(), totalAmount);
                              scaffoldMessengerContext.showSnackBar(SnackBar(
                                content:
                                    const Text('Order placed successfully!'),
                                action: SnackBarAction(
                                  label: 'DISMISS',
                                  onPressed: () => scaffoldMessengerContext
                                      .hideCurrentSnackBar(),
                                ),
                              ));
                              cart.clear();
                            } catch (error) {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('An error ocurred'),
                                  content: const Text(
                                      'Something went wrong while registering your order.'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Ok'),
                                    )
                                  ],
                                ),
                              );
                            }
                            setState(() {
                              _isLoading = false;
                            });
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
