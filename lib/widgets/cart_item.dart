import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    super.key,
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.all(15),
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to remove the item from the cart?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('No')),
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Yes')),
          ],
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.all(15),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text('\$${(quantity * price).toStringAsFixed(2)}'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('\$$price'),
          trailing: Text(
            '$quantity x',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
