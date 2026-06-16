import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/section_title.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/check_in/presentation/check_in_view_model.dart';

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CheckInViewModel>();
    final state = viewModel.state;

    return Scaffold(
      body: PageWrapper(
        padding: EdgeInsets.zero,
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.checkIn == null
                ? const Center(child: Text('No se encontró una reserva activa'))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
                    children: [
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Check-in digital',
                              style: TextStyle(
                                color: AppTheme.dark,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _CheckInHero(
                        roomNumber: state.checkIn!.roomNumber,
                        hotelName: state.checkIn!.hotelName,
                        completed: state.checkIn!.checkInCompleted,
                      ),
                      const SizedBox(height: 22),
                      const SectionTitle(title: 'Resumen de reserva'),
                      const SizedBox(height: 12),
                      SmartCard(
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline,
                              title: 'Huésped',
                              value: state.checkIn!.guestName,
                            ),
                            const _DividerLine(),
                            _InfoRow(
                              icon: Icons.confirmation_number_outlined,
                              title: 'Reserva',
                              value: state.checkIn!.bookingCode,
                            ),
                            const _DividerLine(),
                            _InfoRow(
                              icon: Icons.calendar_month_outlined,
                              title: 'Entrada',
                              value: state.checkIn!.checkInDate,
                            ),
                            const _DividerLine(),
                            _InfoRow(
                              icon: Icons.event_available_outlined,
                              title: 'Salida',
                              value: state.checkIn!.checkOutDate,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      const SectionTitle(title: 'Validaciones'),
                      const SizedBox(height: 12),
                      SmartCard(
                        child: Column(
                          children: [
                            _CheckItem(
                              title: 'Confirmo que mis datos personales son correctos',
                              subtitle: 'DNI, reserva y fechas de estadía',
                              value: state.documentAccepted,
                              onChanged: (value) {
                                viewModel.toggleDocumentAccepted(value ?? false);
                              },
                            ),
                            const SizedBox(height: 10),
                            _CheckItem(
                              title: 'Acepto las condiciones del hotel',
                              subtitle: 'Horario de salida, uso de llave digital y políticas internas',
                              value: state.policiesAccepted,
                              onChanged: (value) {
                                viewModel.togglePoliciesAccepted(value ?? false);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (state.checkIn!.checkInCompleted)
                        _AccessCodeCard(accessCode: state.checkIn!.accessCode)
                      else
                        SizedBox(
                          height: 54,
                          child: FilledButton.icon(
                            onPressed: state.canConfirm && !state.isConfirming
                                ? () async {
                                    await viewModel.confirmCheckIn();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Check-in confirmado correctamente'),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            icon: state.isConfirming
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.verified_outlined),
                            label: Text(
                              state.isConfirming
                                  ? 'Confirmando...'
                                  : 'Confirmar check-in',
                            ),
                          ),
                        ),
                      if (state.errorMessage != null) ...[
                        const SizedBox(height: 14),
                        Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
      ),
    );
  }
}

class _CheckInHero extends StatelessWidget {
  final String roomNumber;
  final String hotelName;
  final bool completed;

  const _CheckInHero({
    required this.roomNumber,
    required this.hotelName,
    required this.completed,
  });

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
          colors: [Color(0xFF0F172A), Color(0xFF176B87)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.24),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(
            label: completed ? 'Confirmado' : 'Pendiente',
            color: completed ? AppTheme.success : AppTheme.warning,
            icon: completed ? Icons.check_circle_outline : Icons.pending_actions,
          ),
          const SizedBox(height: 22),
          const Text(
            'Completa tu llegada sin pasar por recepción.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hotelName,
            style: const TextStyle(color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(Icons.hotel, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Habitación asignada',
                    style: TextStyle(color: Colors.white60),
                  ),
                  Text(
                    roomNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.10),
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
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: value
            ? AppTheme.success.withValues(alpha: 0.08)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: value
              ? AppTheme.success.withValues(alpha: 0.35)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccessCodeCard extends StatelessWidget {
  final String accessCode;

  const _AccessCodeCard({required this.accessCode});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.key, color: AppTheme.success),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Llave digital activada',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              StatusChip(label: 'Listo', color: AppTheme.success),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.dark,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                const Text(
                  'Código de acceso',
                  style: TextStyle(color: Colors.white60),
                ),
                const SizedBox(height: 8),
                Text(
                  accessCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Usa este código para ingresar a tu habitación. También queda habilitado el control de luces, clima y servicios desde SmartStay.',
            style: TextStyle(color: Color(0xFF64748B), height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: Color(0xFFE2E8F0)),
    );
  }
}
