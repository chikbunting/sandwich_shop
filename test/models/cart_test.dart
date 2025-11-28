import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('Cart model', () {
    late PricingRepository pricing;

    setUp(() {
      pricing = PricingRepository(sixInchPrice: 7.0, footlongPrice: 11.0);
    });

    test('adds and merges quantities for the same sandwich', () {
      final cart = Cart();
      final s = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.white);

      cart.add(s);
      expect(cart.distinctItemCount, 1);
      expect(cart.quantityFor(s), 1);

      cart.add(s, quantity: 2);
      expect(cart.distinctItemCount, 1);
      expect(cart.quantityFor(s), 3);
    });

    test('adds distinct sandwiches separately', () {
      final cart = Cart();
      final a = Sandwich(type: SandwichType.veggieDelight, isFootlong: false, breadType: BreadType.white);
      final b = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white);

      cart.add(a);
      cart.add(b);

      expect(cart.distinctItemCount, 2);
      expect(cart.totalQuantity, 2);
    });

    test('updateQuantity and remove behave correctly', () {
      final cart = Cart();
      final s = Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: false, breadType: BreadType.wheat);

      cart.add(s, quantity: 3);
      expect(cart.quantityFor(s), 3);

      cart.updateQuantity(s, 1);
      expect(cart.quantityFor(s), 1);

      cart.updateQuantity(s, 0);
      expect(cart.quantityFor(s), 0);
      expect(cart.isEmpty, true);
    });

    test('totalPrice uses PricingRepository for calculation', () {
      final cart = Cart();
      final sixInch = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.wholemeal);
      final footlong = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.wholemeal);

      cart.add(sixInch, quantity: 2); // 2 * 7.0 = 14.0
      cart.add(footlong, quantity: 1); // 1 * 11.0 = 11.0

      final total = cart.totalPrice(pricing);
      expect(total, 25.0);
    });
  });
}
