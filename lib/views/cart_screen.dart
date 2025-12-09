import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/main.dart';

class CartScreen extends StatefulWidget {
  final Cart cart;
  final PricingRepository pricing;

  const CartScreen({super.key, required this.cart, required this.pricing});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increment(int index) {
    final item = widget.cart.items[index];
    widget.cart.updateQuantity(item.sandwich, item.quantity + 1);
    setState(() {});
  }

  void _decrement(int index) {
    final item = widget.cart.items[index];
    final newQty = item.quantity - 1;
    widget.cart.updateQuantity(item.sandwich, newQty);
    setState(() {});
  }

  void _remove(int index) {
    final item = widget.cart.items[index];
    widget.cart.remove(item.sandwich);
    setState(() {});
  }

  Future<void> _navigateToCheckout() async {
    if (widget.cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your cart is empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute<Map<String, dynamic>>(
        builder: (context) => CheckoutScreen(cart: widget.cart, pricing: widget.pricing),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        widget.cart.clear();
      });

      final String orderId = result['orderId'] as String? ?? 'Unknown';
      final String estimatedTime = result['estimatedTime'] as String? ?? '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order $orderId confirmed! Estimated time: $estimatedTime'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cart.items;
    final subtotal = widget.cart.totalPrice(widget.pricing);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (items.isEmpty)
              const Expanded(
                child: Center(child: Text('Your cart is empty', style: normalText)),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final id = it.sandwich.id;
                    final sizeText = it.sandwich.isFootlong ? 'footlong' : 'six-inch';
                    final lineTotal = widget.pricing.totalFor(quantity: it.quantity, isFootlong: it.sandwich.isFootlong);
                    return ListTile(
                      key: ValueKey('cart_item_$id'),
                      title: Text('${it.sandwich.name} (${it.sandwich.breadType.name}, $sizeText)', style: normalText),
                      subtitle: Text('£${lineTotal.toStringAsFixed(2)}', style: normalText),
                      trailing: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(
                            key: Key('dec_$id'),
                            onPressed: it.quantity > 0 ? () => _decrement(index) : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${it.quantity}', style: normalText),
                          IconButton(
                            key: Key('inc_$id'),
                            onPressed: () => _increment(index),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            key: Key('remove_$id'),
                            onPressed: () => _remove(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: heading1),
                Text('£${subtotal.toStringAsFixed(2)}', style: heading1),
              ],
            ),
            const SizedBox(height: 12),
            const SizedBox(height: 20),
            Builder(
              builder: (BuildContext context) {
                final bool cartHasItems = widget.cart.items.isNotEmpty;
                if (cartHasItems) {
                  return StyledButton(
                    onPressed: _navigateToCheckout,
                    icon: Icons.payment,
                    label: 'Checkout',
                    backgroundColor: Colors.orange,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Continue Shopping'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
