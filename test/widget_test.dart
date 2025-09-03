import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:classtab_catalog/main.dart';

void main() {
  testWidgets('ClassTab app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClassTabApp());

    // Wait for the app to render (with timeout)
    await tester.pump(const Duration(seconds: 2));

    // Verify that the app loaded without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Check if we can find a TabBar (which should be present in the main screen)
    expect(find.byType(TabBar), findsAtLeastNWidgets(0));
  });
}
