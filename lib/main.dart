import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import './screens/products_overview_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Shop app',
        theme: ThemeData(
          colorScheme: ThemeData.light().colorScheme.copyWith(
                primary: Colors.deepPurple,
                onSecondary: Colors.white,
                onPrimary: Colors.white,
                secondary: Colors.orange,
              ),
          brightness: Brightness.light,
          textTheme: const TextTheme(),
          iconButtonTheme: const IconButtonThemeData(
            style: ButtonStyle(
              iconColor: MaterialStatePropertyAll(Colors.white),
            ),
          ),
          useMaterial3: false,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => ProductsOverviewScreen(),
          '/product-details': (context) => ProductDetailScreen(),
          '/cart': (context) => CartScreen(),
          '/orders': (context) => OrdersScreen()
        },
      ),
    );
  }
}
