import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../client/client_shell.dart';
import '../../shared/ui.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiClient _api = ApiClient();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_username.text.trim().length < 3) {
      showSmartSnack(context, 'El usuario debe tener mínimo 3 caracteres.');
      return;
    }
    if (_password.text.length < 6) {
      showSmartSnack(context, 'La contraseña debe tener mínimo 6 caracteres.');
      return;
    }
    if (_password.text != _confirm.text) {
      showSmartSnack(context, 'Las contraseñas no coinciden.');
      return;
    }

    setState(() => _loading = true);
    try {
      await _api.signUp(_username.text.trim(), _password.text);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const ClientShell()), (_) => false);
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo registrar: $e');
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
              const Text('Crear Cuenta', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400)),
              const SizedBox(height: 32),
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
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirm,
                obscureText: _obscure,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 28),
              SmartButton(text: 'Registrarse', icon: Icons.person_add, loading: _loading, onPressed: _register),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loading ? null : () => Navigator.pop(context),
                child: const Text('¿Ya tienes cuenta? Inicia sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
