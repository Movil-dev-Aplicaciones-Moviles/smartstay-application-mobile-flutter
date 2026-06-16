import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: const [
          Text(
            'Analytics',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text(
            'Resumen de métricas principales del hotel.',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          SizedBox(height: 16),
          _ContractCard(),
          SizedBox(height: 16),
          _MetricGrid(),
          SizedBox(height: 14),
          _SistemaNote(),
        ],
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusChip(
            label: 'Desempeño mensual',
            color: AppTheme.primary,
            icon: Icons.analytics_outlined,
          ),
          SizedBox(height: 12),
          Text(
            'El resource real se llama PerformanceMetricsResource y contiene: totalRevenue, totalBookings, occupancyRate, cancelledBookings y generatedAt.',
            style: TextStyle(fontWeight: FontWeight.w700, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Total Revenue', value: 'S/ 1,250', icon: Icons.payments_outlined)),
            SizedBox(width: 12),
            Expanded(child: _MetricCard(label: 'Total Bookings', value: '12', icon: Icons.event_available_outlined)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _MetricCard(label: 'Occupancy Rate', value: '66.7%', icon: Icons.hotel_outlined)),
            SizedBox(width: 12),
            Expanded(child: _MetricCard(label: 'Cancelled', value: '2', icon: Icons.cancel_outlined)),
          ],
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class _SistemaNote extends StatelessWidget {
  const _SistemaNote();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Nota técnica',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text(
            'El reporte resume ingresos, reservas, cancelaciones y ocupación del hotel.',
            style: TextStyle(height: 1.35),
          ),
        ],
      ),
    );
  }
}
