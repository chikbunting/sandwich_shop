import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A simple cart item that pairs a Sandwich with a quantity.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, this.quantity = 1}) : assert(quantity >= 0);

  double totalPrice(PricingRepository pricing) {
    return pricing.totalFor(quantity: quantity, isFootlong: sandwich.isFootlong);
  }
}

/// Cart holds multiple CartItem entries and provides operations a user would
/// expect when managing a food-order cart: add, remove, update quantity, and
/// computing totals using the PricingRepository.
class Cart {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;
  int get distinctItemCount => _items.length;
  int get totalQuantity => _items.fold(0, (p, e) => p + e.quantity);

  /// Adds [quantity] of [sandwich] to the cart. If an equivalent sandwich
  /// already exists (same type, size, bread), the quantities are merged.
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final existing = _findItem(sandwich);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Remove an item completely from the cart (regardless of quantity).
  void remove(Sandwich sandwich) {
    _items.removeWhere((it) => _sameSandwich(it.sandwich, sandwich));
  }

  /// Update the quantity for a sandwich. If newQuantity <= 0 the item is removed.
  void updateQuantity(Sandwich sandwich, int newQuantity) {
    final existing = _findItem(sandwich);
    if (existing == null) return;
    if (newQuantity <= 0) {
      remove(sandwich);
    } else {
      existing.quantity = newQuantity;
    }
  }

  /// Returns the quantity for a given sandwich (0 if not present).
  int quantityFor(Sandwich sandwich) {
    final existing = _findItem(sandwich);
    return existing?.quantity ?? 0;
  }

  /// Clears all items from the cart.
  void clear() => _items.clear();

  /// Calculates the total price for all items using [pricing]
  double totalPrice(PricingRepository pricing) {
    double total = 0.0;
    for (final it in _items) {
      total += it.totalPrice(pricing);
    }
    return total;
  }

  CartItem? _findItem(Sandwich sandwich) {
    for (final it in _items) {
      if (_sameSandwich(it.sandwich, sandwich)) return it;
    }
    return null;
  }

  bool _sameSandwich(Sandwich a, Sandwich b) {
    return a.type == b.type && a.isFootlong == b.isFootlong && a.breadType == b.breadType;
  }
}
