import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:classtab_catalog/main.dart';

void main() {
  testWidgets('ClassTab app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClassTabApp());
    
    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that we have some basic UI elements
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Cerca'), findsOneWidget);
    expect(find.text('Preferiti'), findsOneWidget);
    expect(find.text('Compositori'), findsOneWidget);
    
    // Verify that we can find the sync button or similar UI element
    expect(find.byIcon(Icons.sync), findsWidgets);
  });
}