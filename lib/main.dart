import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_stay/core/di/dependency_injection.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/features/auth/presentation/login_page.dart';
import 'package:smart_stay/features/auth/presentation/login_view_model.dart';

void main() {
  setup();
  runApp(
    BlocProvider<LoginViewModel>(
      create: (context) => getIt<LoginViewModel>(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
