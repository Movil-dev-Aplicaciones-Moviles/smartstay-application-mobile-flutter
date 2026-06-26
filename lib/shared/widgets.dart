part of '../main.dart';

class DetailRow extends StatelessWidget { final String label; final String value; const DetailRow({super.key, required this.label, required this.value}); @override Widget build(BuildContext context)=> Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(children: [SizedBox(width: 105, child: Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))), Expanded(child: Text(value))])); }
class ErrorView extends StatelessWidget { final String message; final VoidCallback onRetry; const ErrorView({super.key, required this.message, required this.onRetry}); @override Widget build(BuildContext context)=> Center(child: Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisAlignment: MainAxisAlignment.center, children:[Text(message, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error)), const SizedBox(height: 16), TextButton(onPressed: onRetry, child: const Text('Reintentar'))]))); }

void showAssignRoleDialog(BuildContext context, AppUser user, VoidCallback onChanged) {
  final actorRole = Session.user?.role ?? '';
  final roles = RoleHierarchy.getAssignableRoles(actorRole, user.role);

  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Asignar Rol'),
      content: roles.isEmpty
          ? const Text('No hay roles disponibles para asignar.')
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: roles
                  .map(
                    (role) => ListTile(
                      title: Text(role),
                      onTap: () async {
                        Navigator.pop(context);
                        try {
                          await AppApi.assignRole(user.id, role);
                          onChanged();
                        } catch (e) {
                          if (context.mounted) showMessage(context, 'No se pudo asignar rol: $e');
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar'))],
    ),
  );
}

Color statusColor(String status) { if (status.toLowerCase() == 'active') return Colors.green; if (status.toLowerCase() == 'inactive') return Colors.red; return Colors.orange; }
void showMessage(BuildContext context, String message) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message))); }
