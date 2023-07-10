import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final currentFilter;

  const ProductsGrid(this.currentFilter, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Products>(
      builder: (context, products, child) {
        final productsList = currentFilter == FilterOptions.all
            ? products.items
            : products.favoriteItems;

        return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20),
            itemCount: productsList.length,
            itemBuilder: (_, index) {
              return ChangeNotifierProvider.value(
                value: productsList[index],
                child: ProductItem(),
              );
            });
      },
    );
  }
}
