import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:weekly_calendar_app/main.dart'; // ← cambia el nombre del paquete

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const WeeklyCalendarApp()); // ← tu widget raíz
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}