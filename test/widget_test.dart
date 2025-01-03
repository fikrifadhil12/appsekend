import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tpmo4/main.dart'; // Mengimpor file utama untuk pengujian

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app dan trigger a frame.
    await tester.pumpWidget(MyApp()); // Tanpa parameter appRouter

    // Verifikasi bahwa counter dimulai dari 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Ketuk ikon '+' dan trigger frame baru.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter telah bertambah.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
