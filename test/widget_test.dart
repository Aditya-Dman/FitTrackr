// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:projfittrackr/main.dart';

void main() {
  testWidgets('FitTrackr app loads and shows dashboard', (WidgetTester tester) async {
    // Build the FitTrackr app and trigger a frame.
    await tester.pumpWidget(const FitTrackrApp());

    // Verify that the dashboard loads and shows expected text.
    expect(find.text('FitTrackr Dashboard'), findsOneWidget);
    expect(find.text('Add Food / Calories'), findsOneWidget);
    expect(find.text('Profile & Settings'), findsOneWidget);
  });
}
