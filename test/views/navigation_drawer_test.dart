import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('opens drawer and navigates to about', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

  // Open the drawer by dragging from the left edge (we use a custom AppBar
  // leading so the automatic menu button may not be present).
  await tester.dragFrom(const Offset(0, 300), const Offset(300, 0));
  await tester.pumpAndSettle();

    // Tap the About item
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    // Expect About screen content
    expect(find.textContaining('Welcome to Sandwich Shop!'), findsOneWidget);
  });
}
