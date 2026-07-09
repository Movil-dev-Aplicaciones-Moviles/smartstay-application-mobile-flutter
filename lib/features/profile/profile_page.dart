import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../features/auth/login_page.dart';
import '../../features/client/client_shell.dart';
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

  String get _displayName {
    final username = SessionStore.currentUser?.username ?? 'Cliente';
    final base = username.contains('@') ? username.split('@').first : username;
    if (base.isEmpty) return 'Cliente';
    return base[0].toUpperCase() + base.substring(1);
  }

  bool get _isSignedIn => SessionStore.currentUser != null;

  String get _initial {
    final name = _displayName.trim();
    return name.isEmpty ? 'C' : name[0].toUpperCase();
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
      Navigator.pop(context);
      showSmartSnack(context, 'Perfil guardado correctamente.');
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo guardar el perfil: $e');
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
      Navigator.pop(context);
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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const ClientShell()), (_) => false);
  }

  void _showComingSoon(String feature) {
    showSmartSnack(context, '$feature estará disponible en una próxima versión.');
  }

  void _openProfileSheet() {
    if (!_isSignedIn) {
      _openLogin();
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _ProfileFormSheet(
        firstName: _firstName,
        lastName: _lastName,
        email: _email,
        street: _street,
        number: _number,
        city: _city,
        postalCode: _postalCode,
        country: _country,
        loading: _creatingProfile,
        onSave: _createProfile,
      ),
    );
  }

  void _openSecuritySheet() {
    if (!_isSignedIn) {
      _openLogin();
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => _SecuritySheet(
        currentPassword: _currentPassword,
        newPassword: _newPassword,
        loading: _changingPassword,
        onSave: _changePassword,
      ),
    );
  }

  void _openViewProfileSheet() {
    if (!_isSignedIn) {
      _openLogin();
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Avatar(initial: _initial, size: 92),
            const SizedBox(height: 14),
            Text(_displayName, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(SessionStore.currentUser?.username ?? 'Correo no registrado', style: const TextStyle(color: kMuted)),
            const SizedBox(height: 18),
            SmartButton(text: 'Editar información', icon: Icons.edit_outlined, onPressed: () {
              Navigator.pop(context);
              _openProfileSheet();
            }),
          ],
        ),
      ),
    );
  }

  void _openLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 112),
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Perfil', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF2F2F2)),
              child: IconButton(
                tooltip: 'Notificaciones',
                onPressed: () => _showComingSoon('Notificaciones'),
                icon: const Icon(Icons.notifications_none_outlined, color: kSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        if (_isSignedIn)
          _ProfileHeroCard(name: _displayName, initial: _initial, email: SessionStore.currentUser?.username ?? '')
        else
          _SignedOutCard(onLogin: _openLogin),
        const SizedBox(height: 18),
        _ProfileShortcutGrid(
          onProfile: _openProfileSheet,
          onSecurity: _openSecuritySheet,
          onBookings: () => _showComingSoon('Acceso rápido a reservas'),
        ),
        const SizedBox(height: 24),
        Text('Cuenta', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        _ProfileMenuItem(icon: Icons.settings_outlined, title: 'Configuración de la cuenta', onTap: _openProfileSheet),
        _ProfileMenuItem(icon: Icons.person_outline, title: 'Ver perfil', onTap: _openViewProfileSheet),
        _ProfileMenuItem(icon: Icons.privacy_tip_outlined, title: 'Privacidad y seguridad', onTap: _openSecuritySheet),
        const Divider(height: 34),
        _ProfileMenuItem(icon: Icons.help_outline, title: 'Centro de ayuda', onTap: () => _showComingSoon('Centro de ayuda')),
        if (_isSignedIn)
          _ProfileMenuItem(icon: Icons.logout, title: 'Cerrar sesión', showChevron: false, onTap: _logout)
        else
          _ProfileMenuItem(icon: Icons.login, title: 'Iniciar sesión', showChevron: false, onTap: _openLogin),
      ],
    );
  }
}

class _SignedOutCard extends StatelessWidget {
  final VoidCallback onLogin;

  const _SignedOutCard({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.person_outline, color: kPrimary, size: 48),
          const SizedBox(height: 16),
          Text('Explora alojamientos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('Inicia sesión cuando quieras reservar, ver tus reservas o administrar tu información.', style: TextStyle(color: kMuted)),
          const SizedBox(height: 18),
          SmartButton(text: 'Iniciar sesión', icon: Icons.login, onPressed: onLogin),
        ],
      ),
    );
  }
}

class _ProfileHeroCard extends StatelessWidget {
  final String name;
  final String initial;
  final String email;

  const _ProfileHeroCard({required this.name, required this.initial, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(12), blurRadius: 28, offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          _Avatar(initial: initial, size: 108),
          const SizedBox(height: 18),
          Text(name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Huésped', style: TextStyle(color: kMuted, fontSize: 16)),
          if (email.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(99)),
              child: Text(email, style: const TextStyle(color: kMuted, fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}


class _ProfileShortcutGrid extends StatelessWidget {
  final VoidCallback onProfile;
  final VoidCallback onSecurity;
  final VoidCallback onBookings;

  const _ProfileShortcutGrid({
    required this.onProfile,
    required this.onSecurity,
    required this.onBookings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ShortcutCard(
            icon: Icons.badge_outlined,
            title: 'Datos',
            subtitle: 'Perfil',
            onTap: onProfile,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ShortcutCard(
            icon: Icons.shield_outlined,
            title: 'Seguridad',
            subtitle: 'Contraseña',
            onTap: onSecurity,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ShortcutCard(
            icon: Icons.calendar_month_outlined,
            title: 'Reservas',
            subtitle: 'Estado',
            onTap: onBookings,
          ),
        ),
      ],
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: kLine),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: kSoftBlue),
              child: Icon(icon, color: kPrimaryDark, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: kMuted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initial;
  final double size;

  const _Avatar({required this.initial, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDDF4E4)),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: const Color(0xFF007A3D),
            fontSize: size * 0.42,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool showChevron;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 44,
      leading: Icon(icon, color: kSecondary, size: 29),
      title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      trailing: showChevron ? const Icon(Icons.chevron_right, color: kMuted) : null,
      onTap: onTap,
    );
  }
}

class _ProfileFormSheet extends StatelessWidget {
  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController email;
  final TextEditingController street;
  final TextEditingController number;
  final TextEditingController city;
  final TextEditingController postalCode;
  final TextEditingController country;
  final bool loading;
  final VoidCallback onSave;

  const _ProfileFormSheet({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.street,
    required this.number,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.loading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configuración de la cuenta', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: TextField(controller: firstName, decoration: const InputDecoration(labelText: 'Nombre'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: lastName, decoration: const InputDecoration(labelText: 'Apellido'))),
              ],
            ),
            const SizedBox(height: 12),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 12),
            TextField(controller: street, decoration: const InputDecoration(labelText: 'Dirección')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: number, decoration: const InputDecoration(labelText: 'Número'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: postalCode, decoration: const InputDecoration(labelText: 'Código postal'))),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: TextField(controller: city, decoration: const InputDecoration(labelText: 'Ciudad'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: country, decoration: const InputDecoration(labelText: 'País'))),
              ],
            ),
            const SizedBox(height: 18),
            SmartButton(text: 'Guardar cambios', icon: Icons.save_outlined, loading: loading, onPressed: onSave),
          ],
        ),
      ),
    );
  }
}

class _SecuritySheet extends StatelessWidget {
  final TextEditingController currentPassword;
  final TextEditingController newPassword;
  final bool loading;
  final VoidCallback onSave;

  const _SecuritySheet({
    required this.currentPassword,
    required this.newPassword,
    required this.loading,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Privacidad y seguridad', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          TextField(controller: currentPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña actual', prefixIcon: Icon(Icons.lock_outline))),
          const SizedBox(height: 12),
          TextField(controller: newPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva contraseña', prefixIcon: Icon(Icons.lock_reset))),
          const SizedBox(height: 18),
          SmartButton(text: 'Actualizar contraseña', icon: Icons.shield_outlined, loading: loading, onPressed: onSave),
        ],
      ),
    );
  }
}
