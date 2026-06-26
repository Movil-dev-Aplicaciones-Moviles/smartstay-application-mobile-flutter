part of '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool passwordVisible = false;
  bool loading = false;

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    if (username.text.trim().length < 3 || password.text.length < 6) {
      showMessage(context, 'Completa usuario y contraseña correctamente.');
      return;
    }
    setState(() => loading = true);
    try {
      final authenticatedUser = await AppApi.signIn(username.text.trim(), password.text);
      if (!mounted) return;
      final permissions = UserPermissions(authenticatedUser.role);
      final destination = permissions.canManageUsers
          ? const UserListScreen()
          : ProfileDetailScreen(profileId: authenticatedUser.id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => destination),
      );
    } catch (e) {
      if (mounted) showMessage(context, 'Error de autenticación: $e');
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SmartStay', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 32),
                TextField(controller: username, enabled: !loading, decoration: const InputDecoration(labelText: 'Usuario', prefixIcon: Icon(Icons.email))),
                const SizedBox(height: 16),
                TextField(
                  controller: password,
                  enabled: !loading,
                  obscureText: !passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => passwordVisible = !passwordVisible),
                      icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: loading ? null : signIn,
                    child: loading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Ingresar'),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
                const SizedBox(height: 12),
                Text('API: $apiBaseUrl', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
