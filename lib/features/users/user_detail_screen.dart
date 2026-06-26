part of '../../main.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  const UserDetailScreen({super.key, required this.userId});
  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<AppUser> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = AppApi.getUserById(widget.userId);
  }

  void reload() => setState(() => futureUser = AppApi.getUserById(widget.userId));

  Future<void> deactivateUserAccount(AppUser user) async {
    await AppApi.deactivateUser(user.id);
    reload();
  }

  Future<void> activateUserAccount(AppUser user) async {
    await AppApi.activateUser(user.id);
    reload();
  }

  void confirmDeactivate(AppUser user) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Desactivar usuario?'),
        content: Text('¿Estás seguro de que deseas desactivar a ${user.username}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deactivateUserAccount(user);
            },
            child: Text('Confirmar', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actor = Session.user!;
    final permissions = UserPermissions(actor.role);
    final isMe = widget.userId == actor.id;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Usuario', style: Theme.of(context).textTheme.headlineSmall),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder<AppUser>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          user.username.isEmpty ? '?' : user.username[0].toUpperCase(),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(user.username, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(user.role, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(height: 4),
                      Text(user.status, style: TextStyle(color: statusColor(user.status), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      DetailRow(label: 'ID', value: '${user.id}'),
                      DetailRow(
                        label: 'Sucursal Asignada',
                        value: user.hotelId == 1 ? 'Hotel Costa Azul (Sede Principal)' : user.hotelId?.toString() ?? 'No asignado',
                      ),
                      DetailRow(
                        label: 'Sede Organizacional',
                        value: user.role.toLowerCase() == 'chain_admin' ? 'Sede Corporativa Global' : user.chainId?.toString() ?? 'Local',
                      ),
                      DetailRow(label: 'Creado', value: user.createdAt),
                      DetailRow(label: 'Actualizado', value: user.updatedAt),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (permissions.canEditUser(user.role))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: FilledButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditUserScreen(user: user))).then((_) => reload()),
                    icon: const Icon(Icons.edit),
                    label: const Text('Editar Usuario'),
                  ),
                ),
              if (permissions.canAssignRole(user.role) && !isMe)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: FilledButton.icon(
                    onPressed: () => showAssignRoleDialog(context, user, reload),
                    icon: const Icon(Icons.manage_accounts),
                    label: const Text('Asignar Rol'),
                  ),
                ),
              if (permissions.canDeactivateUser(user.role) && !isMe)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: FilledButton.icon(
                    onPressed: () => user.status.toLowerCase() == 'inactive' ? activateUserAccount(user) : confirmDeactivate(user),
                    icon: Icon(user.status.toLowerCase() == 'inactive' ? Icons.check : Icons.block),
                    label: Text(user.status.toLowerCase() == 'inactive' ? 'Activar Usuario' : 'Desactivar Usuario'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
