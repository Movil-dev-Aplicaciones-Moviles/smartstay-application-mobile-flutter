<<<<<<< HEAD
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

part 'core/session.dart';
part 'core/api_service.dart';
part 'domain/models.dart';
part 'core/permissions.dart';
part 'core/navigation.dart';
part 'features/home/work_home_screen.dart';
part 'features/profile/account_screen.dart';
part 'features/auth/login_screen.dart';
part 'features/auth/sign_up_screen.dart';
part 'features/users/user_list_screen.dart';
part 'features/users/create_user_screen.dart';
part 'features/users/user_detail_screen.dart';
part 'features/users/edit_user_screen.dart';
part 'features/account/change_password_screen.dart';
part 'features/profiles/profile_list_screen.dart';
part 'features/profiles/create_profile_screen.dart';
part 'features/profiles/profile_detail_screen.dart';
part 'features/hotels/hotel_list_screen.dart';
part 'shared/widgets.dart';


const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://application-mobile-backend.onrender.com/api/v1',
);

void main() {
  runApp(const SmartStayApp());
}

class SmartStayApp extends StatelessWidget {
  const SmartStayApp({super.key});
=======
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

class MainApp extends void StatelessWidget {
  const MainApp({super.key});
>>>>>>> 153201114b5d913f3fcd999f4ec3d29f6d5b532b

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      title: 'SmartStay',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6650A4),
          primary: const Color(0xFF6650A4),
          secondary: const Color(0xFF625B71),
          tertiary: const Color(0xFF7D5260),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFBFE),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(0xFFFFFBFE),
          foregroundColor: Color(0xFF1C1B1F),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      home: const LoginScreen(),
=======
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
>>>>>>> 153201114b5d913f3fcd999f4ec3d29f6d5b532b
    );
  }
}
