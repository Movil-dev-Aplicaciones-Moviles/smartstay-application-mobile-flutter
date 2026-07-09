import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay/main.dart';

void main() {
  testWidgets('SmartStay client app loads', (tester) async {
    await tester.pumpWidget(const SmartStayApp());
    await tester.pump();
    expect(find.byType(SmartStayApp), findsOneWidget);
  });
}
