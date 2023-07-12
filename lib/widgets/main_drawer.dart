import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: Center(
            child: Text(
              'SHOP APP',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text('Shop'),
          leading: Icon(Icons.shop),
          onTap: () => Navigator.of(context).pushReplacementNamed('/'),
        ),
        ListTile(
          title: Text('Orders'),
          leading: Icon(Icons.payment),
          onTap: () => Navigator.of(context).pushReplacementNamed('/orders'),
        ),
        ListTile(
          title: Text('Manage Products'),
          leading: Icon(Icons.edit),
          onTap: () => Navigator.of(context).pushReplacementNamed('/products'),
        ),
      ],
    ));
  }
}
