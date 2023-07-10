import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/product_item.dart';

import '../widgets/products_grid.dart';

enum FilterOptions { all, favorites }

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  FilterOptions _currentFilter = FilterOptions.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                _currentFilter = value;
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FilterOptions.all,
                  child: Text('Show all'),
                ),
                const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Show favorites'),
                )
              ];
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => CustomBadge(
              value: cart.itemCount.toString(),
              color: Colors.red,
              child: child!,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/cart');
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ProductsGrid(_currentFilter),
    );
  }
}
