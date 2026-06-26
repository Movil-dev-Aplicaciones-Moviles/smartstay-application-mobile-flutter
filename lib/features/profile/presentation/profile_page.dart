import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';
import 'package:smart_stay/features/auth/presentation/login_page.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  void logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          const Text(
            'Cuenta y perfil',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            'Datos básicos de la cuenta y perfil del usuario.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                      child: const Icon(Icons.person, color: AppTheme.primary, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          StatusChip(
                            label: user.role,
                            color: user.isChainAdmin
                                ? Colors.deepPurple
                                : user.isAdmin
                                    ? AppTheme.primary
                                    : Colors.blueGrey,
                            icon: Icons.verified_user_outlined,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DataRow(label: 'ID usuario', value: '${user.id}'),
                _DataRow(label: 'Hotel', value: user.hotelId?.toString() ?? 'Sin asignación'),
                _DataRow(label: 'Cadena', value: user.chainId?.toString() ?? 'Global / sin asignación'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _ProfileContractCard(),
          const SizedBox(height: 14),
          const _PasswordCard(),
          const SizedBox(height: 14),
          SizedBox(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String label;
  final String value;

  const _DataRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 95,
            child: Text(label, style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileContractCard extends StatelessWidget {
  const _ProfileContractCard();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del perfil',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Crear perfil de usuario'),
          Text('Consulta de perfiles desde administración'),
          Text('Detalle del perfil desde administración'),
          SizedBox(height: 8),
          Text(
            'Esta vista muestra los datos básicos de la cuenta y la información disponible del perfil.',
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seguridad de cuenta',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'La cuenta considera seguridad y cambio de contraseña como parte del flujo de usuario.',
            style: TextStyle(height: 1.35),
          ),
          const SizedBox(height: 10),
          StatusChip(
            label: 'Cambiar contraseña',
            color: AppTheme.primary,
            icon: Icons.lock_reset,
          ),
        ],
      ),
    );
  }
}
