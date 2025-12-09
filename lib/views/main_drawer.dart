import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A reusable Drawer used across the app. Keep navigation logic here so it's
/// easy to update in one place.
class MainDrawer extends StatelessWidget {
  final Cart? cart;
  final PricingRepository? pricing;

  const MainDrawer({super.key, this.cart, this.pricing});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text('Sandwich Shop', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Order'),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.pop(context);
              if (cart != null && pricing != null) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(cart: cart!, pricing: pricing!)));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(cart: Cart(), pricing: PricingRepository(sixInchPrice: 7.0, footlongPrice: 11.0))));
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
    );
  }
}
