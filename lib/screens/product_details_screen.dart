import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final product =
        Provider.of<Products>(context, listen: false).getProductById(id);

    return Consumer<Products>(
      builder: (context, products, child) {
        final product = products.getProductById(id);
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        )
                      ],
                    ),
                    Chip(
                      label: Text(
                        '\$${product.price}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
    ;
  }
}
