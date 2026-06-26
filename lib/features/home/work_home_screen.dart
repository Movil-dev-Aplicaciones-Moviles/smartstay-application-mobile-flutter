part of '../../main.dart';

class WorkHomeScreen extends StatelessWidget {
  const WorkHomeScreen({super.key});

  AppUser get user => Session.user!;
  UserPermissions get permissions => UserPermissions(user.role);

  @override
  Widget build(BuildContext context) {
    final actions = <_MenuAction>[
      if (permissions.canManageUsers)
        _MenuAction(
          title: 'Usuarios',
          subtitle: 'Lista operativa de usuarios',
          icon: Icons.people,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserListScreen())),
        ),
      if (permissions.canCreateUsers)
        _MenuAction(
          title: 'Registrar Personal',
          subtitle: 'Crear usuarios operativos',
          icon: Icons.person_add,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen())),
        ),
      if (permissions.canManageUsers)
        _MenuAction(
          title: 'Directorio Biográfico',
          subtitle: 'Perfiles y fichas de empleados',
          icon: Icons.badge,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileListScreen())),
        ),
      _MenuAction(
        title: 'Mi Perfil',
        subtitle: 'Datos de cuenta y sesión',
        icon: Icons.account_circle,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
      ),
      _MenuAction(
        title: 'Alojamientos',
        subtitle: user.role == 'chain_admin' ? 'Todos los hoteles' : 'Hotel asignado',
        icon: Icons.hotel,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HotelListScreen())),
      ),
      _MenuAction(
        title: 'Cambiar Contraseña',
        subtitle: 'Seguridad de cuenta',
        icon: Icons.lock_reset,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
      ),
      _MenuAction(
        title: 'Cerrar Sesión',
        subtitle: 'Volver al login',
        icon: Icons.exit_to_app,
        danger: true,
        onTap: () => goToLogin(context),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('SmartStay', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountScreen())),
            icon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
          ),
          IconButton(
            onPressed: () => goToLogin(context),
            icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.error),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings, size: 42, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.username, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Rol: ${user.role}'),
                        Text('Hotel ID: ${user.hotelId?.toString() ?? 'Global / sin asignación'}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Opciones del sistema', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final action in actions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: Icon(
                    action.icon,
                    color: action.danger ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(action.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(action.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: action.onTap,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MenuAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool danger;

  const _MenuAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.danger = false,
  });
}
