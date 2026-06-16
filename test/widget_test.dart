import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_stay/core/di/dependency_injection.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/features/auth/presentation/login_page.dart';
import 'package:smart_stay/features/auth/presentation/login_view_model.dart';

void main() {
  testWidgets('SmartStay shows backend aligned login page', (WidgetTester tester) async {
    setup();

    await tester.pumpWidget(
      BlocProvider<LoginViewModel>(
        create: (context) => getIt<LoginViewModel>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const LoginPage(),
        ),
      ),
    );

    expect(find.text('SmartStay'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Registro guest'), findsOneWidget);
  });
}
