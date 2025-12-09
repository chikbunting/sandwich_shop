import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

void main() {
  testWidgets('Settings loads font size from SharedPreferences', (WidgetTester tester) async {
    // Provide mock stored preferences before building the widget.
    SharedPreferences.setMockInitialValues({'fontSize': 19.0});

    await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
    // Wait for async initState and futures to complete.
    await tester.pumpAndSettle();

    expect(find.text('Current size: 19px'), findsOneWidget);
  });
}
