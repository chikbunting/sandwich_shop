import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;
  final PricingRepository pricing;

  const CheckoutScreen({super.key, required this.cart, required this.pricing});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final double totalAmount = widget.cart.totalPrice(widget.pricing);
    final int itemCount = widget.cart.totalQuantity;

    final Map<String, dynamic> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'itemCount': itemCount,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(CartItem item) {
    return widget.pricing.totalFor(quantity: item.quantity, isFootlong: item.sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items = widget.cart.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
                const Text('Order Summary', style: heading1),
            const SizedBox(height: 20),
            if (items.isEmpty)
              const Text('Your cart is empty', style: normalText)
            else
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final double itemPrice = _calculateItemPrice(it);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${it.quantity}x ${it.sandwich.name}', style: normalText),
                        Text('£${itemPrice.toStringAsFixed(2)}', style: normalText),
                      ],
                    );
                  },
                ),
              ),

            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    const Text('Total:', style: heading1),
                    Text('£${widget.cart.totalPrice(widget.pricing).toStringAsFixed(2)}', style: heading1),
              ],
            ),
            const SizedBox(height: 24),
            if (_isProcessing)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: widget.cart.isEmpty ? null : _processPayment,
                child: const Text('Confirm Payment', style: normalText),
              ),
          ],
        ),
      ),
    );
  }
}
