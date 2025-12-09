import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A small immutable view of a sandwich in the cart and its quantity. This
/// keeps compatibility with existing code that expects `CartItem` objects.
class CartItem {
  final Sandwich sandwich;
  final int quantity;

  CartItem({required this.sandwich, required this.quantity}) : assert(quantity >= 0);

  double totalPrice(PricingRepository pricing) {
    return pricing.totalFor(quantity: quantity, isFootlong: sandwich.isFootlong);
  }
}

/// Cart backed by a Map<Sandwich,int> while exposing a few compat helpers so
/// existing UI code doesn't need to be rewritten all at once.
class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  /// Returns an unmodifiable map view of items.
  Map<Sandwich, int> get itemsMap => Map.unmodifiable(_items);

  /// Compatibility: returns a list of CartItem objects for existing UI.
  List<CartItem> get items => _items.entries
      .map((e) => CartItem(sandwich: e.key, quantity: e.value))
      .toList(growable: false);

  bool get isEmpty => _items.isEmpty;
  int get length => _items.length;

  /// Total quantity of all sandwiches in the cart.
  int get totalQuantity => _items.values.fold(0, (p, q) => p + q);

  /// Adds a sandwich by quantity (merging with existing entries).
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    _items.update(sandwich, (v) => v + quantity, ifAbsent: () => quantity);
    notifyListeners();
  }

  /// Removes up to [quantity] of the sandwich; removes key if quantity goes to 0.
  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (!_items.containsKey(sandwich)) return;
    final current = _items[sandwich]!;
    if (current > quantity) {
      _items[sandwich] = current - quantity;
    } else {
      _items.remove(sandwich);
    }
    notifyListeners();
  }

  /// Sets the absolute quantity for a sandwich (compat for updateQuantity).
  void updateQuantity(Sandwich sandwich, int newQuantity) {
    if (newQuantity <= 0) {
      _items.remove(sandwich);
    } else {
      _items[sandwich] = newQuantity;
    }
    notifyListeners();
  }

  /// Clears the cart.
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Compatibility getter: total price using a provided PricingRepository.
  double totalPriceUsing(PricingRepository pricing) {
    double total = 0.0;
    _items.forEach((sandwich, qty) {
      total += pricing.totalFor(quantity: qty, isFootlong: sandwich.isFootlong);
    });
    return total;
  }

  /// Calculates total price using the supplied [pricing] repository.
  double totalPrice(PricingRepository pricing) {
    double total = 0.0;
    _items.forEach((sandwich, qty) {
      total += pricing.totalFor(quantity: qty, isFootlong: sandwich.isFootlong);
    });
    return total;
  }

  /// Number of distinct sandwich types in cart.
  int get distinctItemCount => _items.length;

  /// Total number of individual sandwiches (sum of quantities).
  int get countOfItems => totalQuantity;

  /// Get quantity for a specific sandwich.
  int getQuantity(Sandwich sandwich) => _items[sandwich] ?? 0;
}
