// Basic Flutter widget smoke test for the main app.
// Uses the real package name (ox_chat_project) and MainApp entry point.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ox_chat_project/main.dart';

void main() {
  testWidgets('App loads and builds MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(MainApp('/', scaleFactor: 1.0));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
