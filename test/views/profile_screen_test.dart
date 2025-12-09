import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('navigates to profile and shows fields', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());

    // Tap Profile button on OrderScreen
    final Finder profileButton = find.text('Profile');
    expect(profileButton, findsOneWidget);
    await tester.tap(profileButton);
    await tester.pumpAndSettle();

    // Verify fields and Save button
    expect(find.byKey(const Key('profile_name')), findsOneWidget);
    expect(find.byKey(const Key('profile_email')), findsOneWidget);
    expect(find.byKey(const Key('profile_phone')), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('saves profile and shows snackbar', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.physicalSizeTestValue = const Size(800, 1200);
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const App());

    // Open profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Enter values
    await tester.enterText(find.byKey(const Key('profile_name')), 'Alex Example');
    await tester.enterText(find.byKey(const Key('profile_email')), 'alex@example.com');
    await tester.enterText(find.byKey(const Key('profile_phone')), '0123456789');

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Expect SnackBar with success message
    expect(find.textContaining('Profile saved'), findsOneWidget);
  });
}
