import 'package:flutter/material.dart';
import 'core/session.dart';
import 'features/auth/login_page.dart';
import 'features/client/client_shell.dart';
import 'shared/ui.dart';

void main() {
  runApp(const SmartStayApp());
}

class SmartStayApp extends StatelessWidget {
  const SmartStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimary),
        useMaterial3: true,
        scaffoldBackgroundColor: kSurface,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(backgroundColor: kPrimary),
        ),
      ),
      home: const StartupGate(),
    );
  }
}

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  late final Future<bool> _future;

  @override
  void initState() {
    super.initState();
    _future = _restore();
  }

  Future<bool> _restore() async {
    final user = await SessionStore.restore();
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: LoadingView(message: 'Iniciando SmartStay...'));
        }
        if (snapshot.data == true) return const ClientShell();
        return const LoginPage();
      },
    );
  }
}
