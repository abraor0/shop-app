import 'package:flutter/material.dart';
import 'package:shop_app/models/product_model.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {super.key});

  void directToDetails(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      '/product-details',
      arguments: product.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.favorite),
            onPressed: () {},
          ),
          title: Text(
            product.title,
          ),
          backgroundColor: Colors.black87,
        ),
        child: GestureDetector(
          onTap: () => directToDetails(context),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
