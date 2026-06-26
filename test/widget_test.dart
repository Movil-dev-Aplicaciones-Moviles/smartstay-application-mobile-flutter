import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay/main.dart';

void main() {
  testWidgets('SmartStay connected Kotlin UI shows login', (tester) async {
    await tester.pumpWidget(const SmartStayApp());
    expect(find.text('SmartStay'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });
}
