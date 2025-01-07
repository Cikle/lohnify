import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lohnify/main.dart';

void main() {
  testWidgets('ErrorWidget displays error message correctly', (WidgetTester tester) async {
    // Override the ErrorWidget.builder
    final originalOnError = FlutterError.onError;
    final originalBuilder = ErrorWidget.builder;

    // Build our app and trigger an error
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            throw Exception('Test error');
            return Container(); // This line will never be reached
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that error widget is shown
    expect(find.text('An error occurred: Exception: Test error'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Go Back'), findsOneWidget);

    // Restore the original error handlers
    FlutterError.onError = originalOnError;
    ErrorWidget.builder = originalBuilder;
  });
}
