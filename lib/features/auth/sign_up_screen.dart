part of '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (password.text != confirmPassword.text) {
      showMessage(context, 'Las contraseñas no coinciden.');
      return;
    }
    setState(() => loading = true);
    try {
      await AppApi.signUp(username.text.trim(), password.text);
      if (!mounted) return;
      showMessage(context, 'Cuenta creada correctamente');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo registrar: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Crear Cuenta', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 32),
                TextField(controller: username, decoration: const InputDecoration(labelText: 'Usuario', prefixIcon: Icon(Icons.person))),
                const SizedBox(height: 16),
                TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock))),
                const SizedBox(height: 16),
                TextField(controller: confirmPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar contraseña', prefixIcon: Icon(Icons.lock))),
                const SizedBox(height: 24),
                FilledButton(onPressed: loading ? null : register, child: loading ? const CircularProgressIndicator() : const Text('Registrarse')),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('¿Ya tienes cuenta? Inicia sesión')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
