import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../features/auth/login_page.dart';
import '../../shared/ui.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ApiClient _api = ApiClient();
  bool _creatingProfile = false;
  bool _changingPassword = false;

  final TextEditingController _firstName = TextEditingController(text: 'Jaredt');
  final TextEditingController _lastName = TextEditingController(text: 'Montes');
  final TextEditingController _email = TextEditingController();
  final TextEditingController _street = TextEditingController(text: 'Av. Principal');
  final TextEditingController _number = TextEditingController(text: '123');
  final TextEditingController _city = TextEditingController(text: 'Lima');
  final TextEditingController _postalCode = TextEditingController(text: '15001');
  final TextEditingController _country = TextEditingController(text: 'Perú');

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = SessionStore.currentUser?.username ?? '';
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _street.dispose();
    _number.dispose();
    _city.dispose();
    _postalCode.dispose();
    _country.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (_firstName.text.trim().isEmpty || _lastName.text.trim().isEmpty || _email.text.trim().isEmpty) {
      showSmartSnack(context, 'Completa nombre, apellido y correo.');
      return;
    }

    setState(() => _creatingProfile = true);
    try {
      await _api.createProfile(
        firstName: _firstName.text.trim(),
        lastName: _lastName.text.trim(),
        email: _email.text.trim(),
        street: _street.text.trim(),
        number: _number.text.trim(),
        city: _city.text.trim(),
        postalCode: _postalCode.text.trim(),
        country: _country.text.trim(),
      );
      if (!mounted) return;
      showSmartSnack(context, 'Perfil creado correctamente.');
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo crear el perfil: $e');
    } finally {
      if (mounted) setState(() => _creatingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    if (_currentPassword.text.length < 6 || _newPassword.text.length < 6) {
      showSmartSnack(context, 'Las contraseñas deben tener mínimo 6 caracteres.');
      return;
    }
    setState(() => _changingPassword = true);
    try {
      await _api.changePassword(_currentPassword.text, _newPassword.text);
      if (!mounted) return;
      _currentPassword.clear();
      _newPassword.clear();
      showSmartSnack(context, 'Contraseña actualizada.');
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo cambiar la contraseña: $e');
    } finally {
      if (mounted) setState(() => _changingPassword = false);
    }
  }

  Future<void> _logout() async {
    await SessionStore.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionStore.currentUser;
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SmartCard(
          child: Row(
            children: [
              const Icon(Icons.account_circle, size: 58, color: kPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.username ?? 'Cliente', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Rol: ${user?.role ?? 'guest'}'),
                    Text('User ID: ${user?.id ?? '-'}'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear perfil de cliente', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: TextField(controller: _firstName, decoration: const InputDecoration(labelText: 'Nombre', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _lastName, decoration: const InputDecoration(labelText: 'Apellido', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: _email, decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _street, decoration: const InputDecoration(labelText: 'Calle', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: _number, decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _postalCode, decoration: const InputDecoration(labelText: 'Código postal', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: _city, decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _country, decoration: const InputDecoration(labelText: 'País', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 18),
              SmartButton(text: 'Guardar perfil', icon: Icons.save, loading: _creatingProfile, onPressed: _createProfile),
            ],
          ),
        ),
        SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cambiar contraseña', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: _currentPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña actual', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _newPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva contraseña', prefixIcon: Icon(Icons.lock_reset), border: OutlineInputBorder())),
              const SizedBox(height: 18),
              SmartButton(text: 'Cambiar contraseña', icon: Icons.password, loading: _changingPassword, onPressed: _changePassword),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: kError),
            label: const Text('Cerrar sesión', style: TextStyle(color: kError)),
          ),
        ),
      ],
    );
  }
}
