import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    final repo = PricingRepository(sixInchPrice: 7.0, footlongPrice: 11.0);

    test('unit prices return correct values', () {
      expect(repo.unitPrice(isFootlong: false), 7.0);
      expect(repo.unitPrice(isFootlong: true), 11.0);
    });

    test('totalFor returns 0.0 for zero quantity', () {
      expect(repo.totalFor(quantity: 0, isFootlong: true), 0.0);
      expect(repo.totalFor(quantity: 0, isFootlong: false), 0.0);
    });

    test('totalFor multiplies unit price by quantity', () {
      expect(repo.totalFor(quantity: 3, isFootlong: false), 21.0);
      expect(repo.totalFor(quantity: 2, isFootlong: true), 22.0);
    });
  });
}
