import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('toggles sandwich size Switch between six-inch and footlong',
      (WidgetTester tester) async {
    // Increase the test binding surface size to avoid RenderFlex overflow in
    // the default (small) test surface.
    final binding = TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding;
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());

    // Initially the UI should show 'footlong' (default)
    expect(find.textContaining('footlong sandwich'), findsOneWidget);

    // Find the Switch widget and toggle it
    final Finder switchFinder = find.byType(Switch);
    expect(switchFinder, findsOneWidget);

    // Tap the switch to change to six-inch
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    expect(find.textContaining('six-inch sandwich'), findsOneWidget);

    // Tap again to go back to footlong
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    expect(find.textContaining('footlong sandwich'), findsOneWidget);
  });
}
