import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  void directToDetails(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(
      '/product-details',
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final scaffoldMessengerContext = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.title, product.price, product.id);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: const Text('Added item to cart!'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () => cart.deleteSingleItem(product.id),
                    )),
              );
            },
          ),
          leading: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: product.isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_outline),
              onPressed: () async {
                try {
                  await product.toggleFavorite();
                } catch (error) {
                  if (error is HttpException) {
                    scaffoldMessengerContext.showSnackBar(SnackBar(
                      content: Text('Failed to modify product'),
                      action: SnackBarAction(
                          label: 'DISMISS',
                          onPressed: () =>
                              scaffoldMessengerContext.hideCurrentSnackBar()),
                    ));
                  }
                }
              }),
          title: Text(
            product.title,
          ),
          backgroundColor: Colors.black87,
        ),
        child: GestureDetector(
          onTap: () => directToDetails(context, product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
