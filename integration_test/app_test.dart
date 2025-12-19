import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end tests', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Basic sanity checks on the order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);

      // Add the default sandwich to the cart
      final addToCartButton = find.widgetWithText(app.StyledButton, 'Add to Cart');
      expect(addToCartButton, findsOneWidget);
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Open the cart
      final viewCartButton = find.widgetWithText(app.StyledButton, 'View Cart');
      expect(viewCartButton, findsOneWidget);
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify cart screen and that the sandwich appears
      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      expect(sandwichDropdown, findsOneWidget);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      // Select Chicken Teriyaki from the menu
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(app.StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(app.StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Increase quantity twice to reach 3
      final addButtons = find.byIcon(Icons.add);
      expect(addButtons, findsWidgets);
      final quantityAddButton = addButtons.first;
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      // Quantity label should show 3
      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(app.StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Cart summary on the order screen includes total items and price
      expect(find.textContaining('Cart:'), findsWidgets);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(app.StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(app.StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(app.StyledButton, 'Checkout');
      expect(checkoutButton, findsOneWidget);
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // We're now on the checkout screen
      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsWidgets);

      // Confirm payment button exists and tap it
      final confirmPaymentButton = find.text('Confirm Payment');
      if (confirmPaymentButton.evaluate().isNotEmpty) {
        await tester.tap(confirmPaymentButton);
        await tester.pumpAndSettle();
        // Wait a short moment for any processing
        await tester.pump(const Duration(seconds: 2));
      }

      // After successful checkout we should be back on the order screen
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });
}
