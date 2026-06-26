import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/features/auth/domain/user.dart';
import 'package:smart_stay/features/auth/presentation/login_state.dart';
import 'package:smart_stay/features/auth/presentation/login_view_model.dart';
import 'package:smart_stay/features/auth/presentation/register_page.dart';
import 'package:smart_stay/features/main/presentation/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController username = TextEditingController(
    text: 'guest@smartstay.com',
  );

  final TextEditingController password = TextEditingController(
    text: '123456',
  );

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  void goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  void goToMainPage(User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginViewModel, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }

          if (state is LoginSuccess) {
            goToMainPage(state.user);
          }
        },
        child: PageWrapper(
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const _BrandHeader(),
                const SizedBox(height: 26),
                SmartCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Acceso SmartStay',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.dark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Demo académica con roles, hoteles, habitaciones, reservas, pagos, perfiles y reportes.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      TextField(
                        controller: username,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Username / email',
                          hintText: 'guest@smartstay.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Mínimo 6 caracteres',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: BlocBuilder<LoginViewModel, LoginState>(
                          builder: (context, state) {
                            return FilledButton.icon(
                              onPressed: state is LoginLoading
                                  ? null
                                  : () {
                                      context.read<LoginViewModel>().login(
                                            email: username.text.trim(),
                                            password: password.text,
                                          );
                                    },
                              icon: state is LoginLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.login),
                              label: const Text('Iniciar sesión'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: goToRegisterPage,
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Registro guest'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _DemoRolesCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF176B87),
            Color(0xFF64CCC5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.hotel,
                  color: AppTheme.primary,
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SmartStay',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Demo académica',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'Gestión hotelera móvil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DemoRolesCard extends StatelessWidget {
  const _DemoRolesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.80),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Usuarios demo según roles del sistema',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('guest@smartstay.com / 123456  → guest'),
          Text('admin@smartstay.com / 123456  → admin'),
          Text('chain@smartstay.com / 123456  → chain_admin'),
          Text('staff@smartstay.com / 123456  → staff limitado'),
        ],
      ),
    );
  }
}
