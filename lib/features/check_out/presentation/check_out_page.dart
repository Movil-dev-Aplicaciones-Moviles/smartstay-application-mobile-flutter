import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  bool roomReviewed = false;
  bool chargesAccepted = false;
  bool checkOutCompleted = false;

  final List<_ChargeItem> charges = const [
    _ChargeItem(title: 'Room service', detail: 'Cena ligera y bebida', amount: 58.00),
    _ChargeItem(title: 'Transporte', detail: 'Traslado local programado', amount: 35.00),
    _ChargeItem(title: 'Amenities', detail: 'Kit adicional de habitación', amount: 22.00),
  ];

  double get totalMonto {
    double total = 0;
    for (final charge in charges) {
      total += charge.amount;
    }
    return total;
  }

  void confirmCheckOut() {
    if (!roomReviewed || !chargesAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa las validaciones antes de confirmar la salida'),
        ),
      );
      return;
    }

    setState(() {
      checkOutCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Check-out digital completado correctamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFBFC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
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
                    'Check-out digital',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.dark,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _HeroCard(completed: checkOutCompleted),
            const SizedBox(height: 20),
            const Text(
              'Resumen de salida',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            const _StaySummaryCard(),
            const SizedBox(height: 20),
            const Text(
              'Consumos registrados',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            for (final charge in charges) _ChargeCard(charge: charge),
            _TotalCard(totalMonto: totalMonto),
            const SizedBox(height: 20),
            const Text(
              'Validaciones',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            _CheckOption(
              value: roomReviewed,
              title: 'Habitación revisada',
              description: 'Confirmo que no tengo objetos pendientes en la habitación.',
              onChanged: (value) {
                setState(() {
                  roomReviewed = value ?? false;
                });
              },
            ),
            const SizedBox(height: 10),
            _CheckOption(
              value: chargesAccepted,
              title: 'Consumos aceptados',
              description: 'Confirmo que el resumen de consumos es correcto.',
              onChanged: (value) {
                setState(() {
                  chargesAccepted = value ?? false;
                });
              },
            ),
            const SizedBox(height: 22),
            if (!checkOutCompleted)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: confirmCheckOut,
                  icon: const Icon(Icons.logout_outlined),
                  label: const Text('Confirmar check-out'),
                ),
              )
            else
              const _CompletedCard(),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final bool completed;

  const _HeroCard({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
          _MiniChip(
            text: completed ? 'Salida confirmada' : 'Salida pendiente',
            icon: completed ? Icons.check_circle_outline : Icons.schedule_outlined,
          ),
          const SizedBox(height: 20),
          Text(
            completed
                ? 'Tu check-out fue registrado correctamente.'
                : 'Completa tu salida sin pasar por recepción.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Revisa tus consumos, confirma las validaciones y libera la habitación desde SmartStay.',
            style: TextStyle(color: Colors.white70, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _MiniChip({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.secondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaySummaryCard extends StatelessWidget {
  const _StaySummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Column(
        children: [
          _SummaryRow(label: 'Huésped', value: 'Jaredt Montes'),
          _SummaryRow(label: 'Habitación', value: 'A-204'),
          _SummaryRow(label: 'Hotel', value: 'SmartStay Boutique Lima'),
          _SummaryRow(label: 'Salida programada', value: 'Hoy, 12:00 p.m.'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppTheme.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeCard extends StatelessWidget {
  final _ChargeItem charge;

  const _ChargeCard({required this.charge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.receipt_long_outlined, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  charge.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  charge.detail,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'S/ ${charge.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: AppTheme.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double totalMonto;

  const _TotalCard({required this.totalMonto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Total a confirmar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            'S/ ${totalMonto.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckOption extends StatelessWidget {
  final bool value;
  final String title;
  final String description;
  final ValueChanged<bool?> onChanged;

  const _CheckOption({
    required this.value,
    required this.title,
    required this.description,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Checkbox(value: value, onChanged: onChanged),
          const SizedBox(width: 8),
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
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.25,
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

class _CompletedCard extends StatelessWidget {
  const _CompletedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 10),
              Text(
                'Check-out completado',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'La habitación A-204 fue liberada. El comprobante será enviado al correo registrado.',
            style: TextStyle(color: AppTheme.dark, height: 1.35),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: const Color(0xFFE2E8F0)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

class _ChargeItem {
  final String title;
  final String detail;
  final double amount;

  const _ChargeItem({
    required this.title,
    required this.detail,
    required this.amount,
  });
}
