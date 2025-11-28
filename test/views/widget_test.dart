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

    // Find the size Switch widget by key and toggle it
    final Finder switchFinder = find.byKey(const Key('size_switch'));
    expect(switchFinder, findsOneWidget);

    // Initially it should be footlong (true)
    Switch s = tester.widget<Switch>(switchFinder);
    expect(s.value, isTrue);

    // Tap the switch to change to six-inch
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    s = tester.widget<Switch>(switchFinder);
    expect(s.value, isFalse);

    // Tap again to go back to footlong
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();
    s = tester.widget<Switch>(switchFinder);
    expect(s.value, isTrue);
  });
}
