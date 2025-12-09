import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  testWidgets('CartScreen increments and updates subtotal', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());

    // Add item to cart
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // Open cart
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    final id = SandwichType.veggieDelight.name; // 'veggieDelight'

    // Item should be present
    expect(find.byKey(ValueKey('cart_item_$id')), findsOneWidget);

  // Subtotal should be £11.00 initially (match the price within the Subtotal row)
  final subtotalRow = find.widgetWithText(Row, 'Subtotal');
  expect(find.descendant(of: subtotalRow, matching: find.textContaining('£11.00')), findsOneWidget);

    // Tap increment
    final incKey = Key('inc_$id');
    await tester.tap(find.byKey(incKey));
    await tester.pumpAndSettle();

  // Now subtotal should be £22.00 (match inside Subtotal row)
  expect(find.descendant(of: subtotalRow, matching: find.textContaining('£22.00')), findsOneWidget);
  });

  testWidgets('CartScreen decrement removes item at zero and remove button works', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());

    // Add item to cart
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // Open cart
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    final id = SandwichType.veggieDelight.name;

    // Decrement once (quantity goes from 1 to 0 -> removed)
    final decKey = Key('dec_$id');
    await tester.tap(find.byKey(decKey));
    await tester.pumpAndSettle();

    // Item should be removed
    expect(find.byKey(ValueKey('cart_item_$id')), findsNothing);

    // Add again and test remove button
    await tester.tap(find.text('Continue Shopping'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Cart'));
    await tester.pumpAndSettle();

    // Now tap remove button
    final removeKey = Key('remove_$id');
    await tester.tap(find.byKey(removeKey));
    await tester.pumpAndSettle();
    expect(find.byKey(ValueKey('cart_item_$id')), findsNothing);
  });
}
