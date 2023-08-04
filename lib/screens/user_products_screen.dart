import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false)
        .fetchProducts(filterByUser: true)
        .then((value) => setState(
              () {
                _isLoading = false;
              },
            ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

    return Scaffold(
      appBar: AppBar(title: const Text('Your products'), actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-product');
            },
            icon: const Icon(Icons.add)),
      ]),
      drawer: const MainDrawer(),
      body: _isLoading
          ? const LinearProgressIndicator()
          : RefreshIndicator(
              onRefresh: () => Provider.of<Products>(context, listen: false)
                  .fetchProducts(filterByUser: true),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: [
                      UserProductItem(
                          id: products[index].id,
                          title: products[index].title,
                          imageUrl: products[index].imageUrl),
                      if (index != products.length - 1) const Divider(),
                    ],
                  ),
                  itemCount: products.length,
                ),
              ),
            ),
    );
  }
}
