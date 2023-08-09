import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/animated_page_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

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
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            update: (context, auth, previous) {
              if (previous != null) {
                previous.updateAuth(auth.token ?? '', auth.userId);
              }

              return previous!;
            }),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders(),
          update: (context, auth, previous) {
            if (previous != null) {
              previous.updateAuth(auth.token ?? '', auth.userId);
            }

            return previous!;
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
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
          home: auth.isLogged
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SplashScreen();
                    } else {
                      return AuthScreen();
                    }
                  },
                ),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/shop':
                return AnimatedPageRoute(page: ProductsOverviewScreen());
              case '/product-details':
                return AnimatedPageRoute(page: ProductDetailScreen());
              case '/cart':
                return AnimatedPageRoute(page: CartScreen());
              case '/orders':
                return AnimatedPageRoute(page: OrdersScreen());
              case '/products':
                return AnimatedPageRoute(page: UserProductsScreen());
              case '/edit-product':
                return AnimatedPageRoute(page: EditProductScreen());
              default:
                return AnimatedPageRoute(page: SplashScreen());
            }
          },
        ),
      ),
    );
  }
}
