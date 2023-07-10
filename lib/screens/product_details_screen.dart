import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    return Consumer<Products>(
      builder: (context, products, child) {
        final product = products.getProductById(id);
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.shopping_cart))
            ],
          ),
          body: const Text('Hello World'),
        );
      },
    );
    ;
  }
}
