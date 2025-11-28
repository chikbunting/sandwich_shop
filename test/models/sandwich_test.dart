import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns human readable names', () {
      final s1 = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white);
      expect(s1.name, 'Veggie Delight');

      final s2 = Sandwich(type: SandwichType.chickenTeriyaki, isFootlong: false, breadType: BreadType.wheat);
      expect(s2.name, 'Chicken Teriyaki');

      final s3 = Sandwich(type: SandwichType.tunaMelt, isFootlong: true, breadType: BreadType.wholemeal);
      expect(s3.name, 'Tuna Melt');

      final s4 = Sandwich(type: SandwichType.meatballMarinara, isFootlong: false, breadType: BreadType.white);
      expect(s4.name, 'Meatball Marinara');
    });

    test('image getter constructs expected asset path', () {
      final footlong = Sandwich(type: SandwichType.veggieDelight, isFootlong: true, breadType: BreadType.white);
      expect(footlong.image, 'assets/images/${SandwichType.veggieDelight.name}_footlong.png');

      final sixInch = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.wheat);
      expect(sixInch.image, 'assets/images/${SandwichType.tunaMelt.name}_six_inch.png');
    });
  });
}
