import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class AdminPage extends StatelessWidget {
  final User user;

  const AdminPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          const Text(
            'Admin Panel',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            user.canViewAdminData
                ? 'Panel para gestionar usuarios, hoteles, habitaciones y reservas.'
                : 'Tu rol tiene acceso limitado en esta demo.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          if (!user.canViewAdminData) const _LimitedAccessCard(),
          if (user.canViewAdminData) ...[
            const _RoleCard(),
            const SizedBox(height: 14),
            const _AdminModuleCard(
              title: 'Gestión de usuarios',
              icon: Icons.manage_accounts_outlined,
              items: [
                'Listar usuarios',
                'Crear usuario',
                'Editar usuario',
                'Crear usuario/{id}/assign-role',
                'Desactivar usuario',
              ],
            ),
            const _AdminModuleCard(
              title: 'Gestión de hoteles',
              icon: Icons.apartment_outlined,
              items: [
                'Crear hotel',
                'Editar hotel',
                'Eliminar hotel',
              ],
            ),
            const _AdminModuleCard(
              title: 'Gestión de habitaciones',
              icon: Icons.king_bed_outlined,
              items: [
                'Crear habitación',
                'Editar habitación',
                'Eliminar habitación',
                'Crear tipo de habitación',
              ],
            ),
            const _AdminModuleCard(
              title: 'Gestión de reservas',
              icon: Icons.event_available_outlined,
              items: [
                'Listar reservas',
                'Listar reservas/{bookingId}',
                'Confirmar reserva',
                'Cancelar reserva',
              ],
            ),
            if (user.isChainAdmin)
              const _AdminModuleCard(
                title: 'Catálogo global Chain Admin',
                icon: Icons.hub_outlined,
                items: [
                  'Crear categoría',
                  'Crear amenity',
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _LimitedAccessCard extends StatelessWidget {
  const _LimitedAccessCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          StatusChip(label: 'Acceso limitado', color: Colors.orange, icon: Icons.lock_outline),
          SizedBox(height: 12),
          Text(
            'La demo reconoce roles operativos, pero solo muestra funciones disponibles dentro del alcance actual.',
            style: TextStyle(fontWeight: FontWeight.w700, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Roles del sistema',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              StatusChip(label: 'guest', color: Colors.blueGrey, icon: Icons.person_outline),
              StatusChip(label: 'staff', color: Colors.blueGrey, icon: Icons.badge_outlined),
              StatusChip(label: 'reception', color: Colors.blueGrey, icon: Icons.support_agent_outlined),
              StatusChip(label: 'housekeeping', color: Colors.blueGrey, icon: Icons.cleaning_services_outlined),
              StatusChip(label: 'maintenance', color: Colors.blueGrey, icon: Icons.engineering_outlined),
              StatusChip(label: 'admin', color: AppTheme.primary, icon: Icons.admin_panel_settings_outlined),
              StatusChip(label: 'chain_admin', color: Colors.deepPurple, icon: Icons.hub_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;

  const _AdminModuleCard({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SmartCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  for (final item in items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(item, style: const TextStyle(fontSize: 13)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
