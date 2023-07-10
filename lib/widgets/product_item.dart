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

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.title, product.price, product.id);
            },
          ),
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: product.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_outline),
            onPressed: product.toggleFavorite,
          ),
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
