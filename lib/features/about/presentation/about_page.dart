import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: const [
          Text(
            'Info SmartStay',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'Resumen final ajustado al alcance real del proyecto.',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          SizedBox(height: 16),
          _PitchCard(),
          SizedBox(height: 14),
          _SupportedCard(),
          SizedBox(height: 14),
          _FutureCard(),
          SizedBox(height: 14),
          _TechCard(),
        ],
      ),
    );
  }
}

class _PitchCard extends StatelessWidget {
  const _PitchCard();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(label: 'Movildev • SmartStay', color: AppTheme.primary, icon: Icons.hotel),
          SizedBox(height: 14),
          Text(
            'Pitch corto',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            'SmartStay es una aplicación móvil desarrollada en Flutter que permite a los huéspedes consultar hoteles y habitaciones, realizar reservas y procesar pagos; mientras que los administradores gestionan usuarios, hoteles, habitaciones, reservas y métricas operativas.',
            style: TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _SupportedCard extends StatelessWidget {
  const _SupportedCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Funciones principales del sistema',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              StatusChip(label: 'IAM/Auth', color: AppTheme.primary, icon: Icons.login),
              StatusChip(label: 'Roles', color: AppTheme.primary, icon: Icons.verified_user_outlined),
              StatusChip(label: 'Hotels', color: AppTheme.primary, icon: Icons.apartment),
              StatusChip(label: 'Rooms', color: AppTheme.primary, icon: Icons.king_bed_outlined),
              StatusChip(label: 'Bookings', color: AppTheme.primary, icon: Icons.event_available_outlined),
              StatusChip(label: 'Payments', color: AppTheme.primary, icon: Icons.payments_outlined),
              StatusChip(label: 'Profiles', color: AppTheme.primary, icon: Icons.person_outline),
              StatusChip(label: 'Analytics', color: AppTheme.primary, icon: Icons.analytics_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _FutureCard extends StatelessWidget {
  const _FutureCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Funciones para una próxima versión',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('• IoT real: luces, temperatura, cortinas'),
          Text('• Service requests reales: room service, limpieza, soporte técnico'),
          Text('• Notificaciones persistentes'),
          Text('• Check-in/check-out digital como flujo propio'),
          Text('• Tareas reales para housekeeping, reception y maintenance'),
          SizedBox(height: 8),
          Text(
            'Estos módulos se pueden presentar como evolución futura, pero no como funcionalidad implementada actualmente.',
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _TechCard extends StatelessWidget {
  const _TechCard();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tecnologías',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Frontend: Flutter + arquitectura por features'),
          Text('API: ASP.NET Core .NET 9 + EF Core + MySQL'),
          Text('Auth: JWT + roles'),
          Text('Persistencia: Entity Framework Core'),
        ],
      ),
    );
  }
}
