import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/services/database_service.dart';
import 'package:sandwich_shop/models/saved_order.dart';

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
    // Use the provider-backed cart for final values to ensure consistency.
    final Cart cart = Provider.of<Cart>(context, listen: false);

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final SavedOrder savedOrder = SavedOrder(
      id: 0,
      orderId: orderId,
      totalAmount: cart.totalPrice(widget.pricing),
      itemCount: cart.countOfItems,
      orderDate: currentTime,
    );

    final DatabaseService databaseService = DatabaseService();
    await databaseService.insertOrder(savedOrder);

    final Map<String, dynamic> orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice(widget.pricing),
      'itemCount': cart.countOfItems,
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
        title: Text('Checkout', style: heading1),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
                Text('Order Summary', style: heading1),
            const SizedBox(height: 20),
            if (items.isEmpty)
              Text('Your cart is empty', style: normalText)
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
                    Text('Total:', style: heading1),
                    Text('£${widget.cart.totalPrice(widget.pricing).toStringAsFixed(2)}', style: heading1),
              ],
            ),
            const SizedBox(height: 24),
            if (_isProcessing)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: widget.cart.isEmpty ? null : _processPayment,
                child: Text('Confirm Payment', style: normalText),
              ),
          ],
        ),
      ),
    );
  }
}
