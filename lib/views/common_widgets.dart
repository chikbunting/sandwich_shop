import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
// main_drawer is intentionally not imported here to avoid circular imports. If
// a screen needs the Drawer, keep using `drawer: const MainDrawer()` in that
// screen's Scaffold.
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// Returns a standardized AppBar used across the app. Pass an optional
/// [pricing] repository if you want the cart indicator to show a total price.
PreferredAppBar(BuildContext context, String title,
    {PricingRepository? pricing}) {
  return AppBar(
    leading: SizedBox(
      height: 100,
      width: 56,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    ),
    title: Text(title, style: heading1),
    // Keep the drawer (hamburger) behaviour consistent by leaving the drawer
    // in the Scaffold; we only provide a cart action here.
    actions: [CartIndicator(pricing: pricing)],
  );
}

class CartIndicator extends StatelessWidget {
  final PricingRepository? pricing;

  const CartIndicator({super.key, this.pricing});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final PricingRepository repo = pricing ?? PricingRepository(sixInchPrice: 7.0, footlongPrice: 11.0);
    final int qty = cart.totalQuantity;
    final double total = cart.totalPrice(repo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text('£${total.toStringAsFixed(2)}', style: AppStyles.normalText),
          IconButton(
            icon: Stack(
              alignment: Alignment.topRight,
              children: [
                const Icon(Icons.shopping_cart),
                if (qty > 0)
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('$qty', style: TextStyle(fontSize: 10, color: Colors.white)),
                  ),
              ],
            ),
            onPressed: () {
              final cartObj = Provider.of<Cart>(context, listen: false);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => CartScreen(cart: cartObj, pricing: repo)));
            },
          ),
        ],
      ),
    );
  }
}
