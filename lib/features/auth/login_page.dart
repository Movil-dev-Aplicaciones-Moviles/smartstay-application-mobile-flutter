import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../client/client_shell.dart';
import '../../shared/ui.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiClient _api = ApiClient();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_username.text.trim().length < 3 || _password.text.length < 6) {
      showSmartSnack(context, 'Ingresa usuario y contraseña válidos.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _api.signIn(_username.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ClientShell()));
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'Error de autenticación: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('SmartStay', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w400)),
              const SizedBox(height: 40),
              TextField(
                controller: _username,
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                onSubmitted: (_) => _login(),
              ),
              const SizedBox(height: 28),
              SmartButton(text: 'Ingresar', icon: Icons.login, loading: _loading, onPressed: _login),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loading
                    ? null
                    : () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                      },
                child: const Text('¿No tienes cuenta? Regístrate'),
              ),
              const SizedBox(height: 12),
              const Text('API: ${ApiClient.baseUrl}', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
