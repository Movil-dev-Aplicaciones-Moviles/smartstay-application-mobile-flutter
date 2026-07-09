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
      showSmartSnack(context, 'No se pudo iniciar sesión: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canClose = Navigator.canPop(context);
    return Scaffold(
      backgroundColor: kSurface,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kSoftBlue, Colors.white, kSurface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: canClose
                            ? IconButton.filledTonal(
                                tooltip: 'Cerrar',
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.close),
                              )
                            : const SizedBox(height: 48),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        height: 188,
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: kSecondary,
                          borderRadius: BorderRadius.circular(34),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(22), blurRadius: 28, offset: const Offset(0, 14))],
                          image: const DecorationImage(
                            image: NetworkImage('https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?auto=format&fit=crop&w=1000&q=80'),
                            fit: BoxFit.cover,
                            opacity: 0.58,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SmartLogoMark(size: 58, framed: true),
                              const SizedBox(height: 10),
                              const Text('Tu próxima estadía, más cerca.', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 24, offset: const Offset(0, 12))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bienvenido de nuevo', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            const Text('Inicia sesión solo cuando quieras reservar o ver tus datos.', style: TextStyle(color: kMuted)),
                            const SizedBox(height: 22),
                            TextField(
                              controller: _username,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(labelText: 'Usuario o correo', prefixIcon: Icon(Icons.mail_outline)),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: _password,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                              onSubmitted: (_) => _login(),
                            ),
                            const SizedBox(height: 20),
                            SmartButton(text: 'Iniciar sesión', icon: Icons.login, loading: _loading, dark: true, onPressed: _login),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton(
                                onPressed: _loading
                                    ? null
                                    : () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                                      },
                                child: const Text('Crear una cuenta nueva'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const ClientShell()),
                          (_) => false,
                        ),
                        child: const Text('Seguir explorando sin iniciar sesión'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
