import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../lib/screens/crop_management_screen.dart'; // Corrected path

void main() {
  group('CropManagementScreen Tests', () {
    testWidgets('Initial state shows no plots message and FAB', (WidgetTester tester) async {
      // Pump the widget
      await tester.pumpWidget(MaterialApp(home: CropManagementScreen()));

      // Assert that the text "No crop plots added yet." is found
      expect(find.text('No crop plots added yet.'), findsOneWidget);

      // Assert that the FloatingActionButton is found by its type
      expect(find.byType(FloatingActionButton), findsOneWidget);
      
      // Optionally, also check by Icon if the FAB has a specific icon
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
