part of '../../main.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  AppUser get user => Session.user!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
        actions: [
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle, size: 60, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.username, style: Theme.of(context).textTheme.titleLarge),
                            Text(user.role, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                            Text(user.status, style: TextStyle(color: statusColor(user.status), fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DetailRow(label: 'ID', value: '${user.id}'),
                  DetailRow(label: 'Hotel ID', value: user.hotelId?.toString() ?? 'No asignado'),
                  DetailRow(label: 'Chain ID', value: user.chainId?.toString() ?? 'No asignado'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            icon: const Icon(Icons.lock_reset),
            label: const Text('Cambiar Contraseña'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => goToLogin(context),
            icon: const Icon(Icons.exit_to_app),
            label: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
