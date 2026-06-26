import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  final List<_StaffRequest> requests = [
    _StaffRequest(
      room: 'A-204',
      guest: 'Jaredt Montes',
      title: 'Room service',
      detail: 'Botella de agua y snack ligero.',
      status: 'Pendiente',
      priority: 'Media',
      time: 'Ahora',
      icon: Icons.room_service_outlined,
      color: Colors.orange,
    ),
    _StaffRequest(
      room: 'B-118',
      guest: 'María Ramos',
      title: 'Soporte técnico',
      detail: 'Problema con WiFi de habitación.',
      status: 'En proceso',
      priority: 'Alta',
      time: '09:15 AM',
      icon: Icons.engineering_outlined,
      color: Colors.redAccent,
    ),
    _StaffRequest(
      room: 'C-302',
      guest: 'Luis Salazar',
      title: 'Limpieza adicional',
      detail: 'Solicita limpieza antes de las 12:00 PM.',
      status: 'Completado',
      priority: 'Baja',
      time: '08:40 AM',
      icon: Icons.cleaning_services_outlined,
      color: Colors.green,
    ),
  ];

  int selectedFilter = 0;

  List<String> get filters => const ['Todas', 'Pendiente', 'En proceso'];

  List<_StaffRequest> get visibleRequests {
    if (selectedFilter == 1) {
      return requests.where((request) => request.status == 'Pendiente').toList();
    }

    if (selectedFilter == 2) {
      return requests.where((request) => request.status == 'En proceso').toList();
    }

    return requests;
  }

  int get pendingCount => requests.where((request) => request.status == 'Pendiente').length;

  int get processCount => requests.where((request) => request.status == 'En proceso').length;

  int get completedCount => requests.where((request) => request.status == 'Completado').length;

  void changeStatus(_StaffRequest request, String newStatus) {
    setState(() {
      request.status = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${request.title} actualizado a $newStatus'),
      ),
    );
  }

  void openRequestDetail(_StaffRequest request) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(request.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Habitación: ${request.room}'),
              const SizedBox(height: 6),
              Text('Huésped: ${request.guest}'),
              const SizedBox(height: 6),
              Text('Detalle: ${request.detail}'),
              const SizedBox(height: 6),
              Text('Prioridad: ${request.priority}'),
              const SizedBox(height: 6),
              Text('Estado: ${request.status}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void addDemoRequest() {
    setState(() {
      requests.insert(
        0,
        _StaffRequest(
          room: 'A-204',
          guest: 'Jaredt Montes',
          title: 'Toallas adicionales',
          detail: 'El huésped solicita dos toallas extra.',
          status: 'Pendiente',
          priority: 'Media',
          time: 'Ahora',
          icon: Icons.local_laundry_service_outlined,
          color: AppTheme.primary,
        ),
      );
      selectedFilter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFEFFBFC),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          children: [
            const Text(
              'Panel Staff',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Control operativo de solicitudes, habitaciones y check-outs.',
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            _OperationalHero(
              pending: pendingCount,
              process: processCount,
              completed: completedCount,
            ),
            const SizedBox(height: 20),
            _MetricGrid(
              pending: pendingCount,
              process: processCount,
              completed: completedCount,
            ),
            const SizedBox(height: 22),
            const Text(
              'Operación del hotel',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            const _RoomOperationCard(),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Solicitudes de huéspedes',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.dark,
                    ),
                  ),
                ),
                _SmallBadge(text: '$pendingCount pendientes', color: Colors.orange),
              ],
            ),
            const SizedBox(height: 12),
            _FilterBar(
              filters: filters,
              selectedIndex: selectedFilter,
              onChanged: (index) {
                setState(() {
                  selectedFilter = index;
                });
              },
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: addDemoRequest,
                icon: const Icon(Icons.add_alert_outlined),
                label: const Text('Simular solicitud nueva'),
              ),
            ),
            const SizedBox(height: 14),
            if (visibleRequests.isEmpty)
              const _EmptyPanel()
            else
              for (final request in visibleRequests)
                _StaffRequestCard(
                  request: request,
                  onTap: () => openRequestDetail(request),
                  onStart: () => changeStatus(request, 'En proceso'),
                  onComplete: () => changeStatus(request, 'Completado'),
                ),
          ],
        ),
      ),
    );
  }
}

class _OperationalHero extends StatelessWidget {
  final int pending;
  final int process;
  final int completed;

  const _OperationalHero({
    required this.pending,
    required this.process,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final total = pending + process + completed;
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.dashboard_customize_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen operativo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Turno mañana - Front desk',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.secondary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completed de $total solicitudes completadas',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final int pending;
  final int process;
  final int completed;

  const _MetricGrid({
    required this.pending,
    required this.process,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        _MetricCard(
          title: 'Pendientes',
          value: '$pending',
          icon: Icons.schedule_outlined,
          color: Colors.orange,
        ),
        _MetricCard(
          title: 'En proceso',
          value: '$process',
          icon: Icons.pending_actions_outlined,
          color: AppTheme.primary,
        ),
        _MetricCard(
          title: 'Completadas',
          value: '$completed',
          icon: Icons.check_circle_outline,
          color: Colors.green,
        ),
        const _MetricCard(
          title: 'Ocupación',
          value: '82%',
          icon: Icons.hotel_outlined,
          color: Colors.indigo,
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.dark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomOperationCard extends StatelessWidget {
  const _RoomOperationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          _OperationRow(
            title: 'Check-ins pendientes',
            value: '6',
            icon: Icons.login_outlined,
            color: AppTheme.primary,
          ),
          SizedBox(height: 14),
          _OperationRow(
            title: 'Check-outs del día',
            value: '9',
            icon: Icons.logout_outlined,
            color: Colors.green,
          ),
          SizedBox(height: 14),
          _OperationRow(
            title: 'Habitaciones por limpiar',
            value: '4',
            icon: Icons.cleaning_services_outlined,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _OperationRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _OperationRow({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.dark,
            ),
          ),
        ),
        _SmallBadge(text: value, color: color),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<String> filters;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _FilterBar({
    required this.filters,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? AppTheme.primary : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.dark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StaffRequestCard extends StatelessWidget {
  final _StaffRequest request;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onComplete;

  const _StaffRequestCard({
    required this.request,
    required this.onTap,
    required this.onStart,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(request.status);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: request.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(request.icon, color: request.color),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.dark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${request.room} · ${request.guest}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _SmallBadge(text: request.priority, color: request.color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            request.detail,
            style: TextStyle(color: Colors.grey.shade700, height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SmallBadge(text: request.status, color: statusColor),
              const SizedBox(width: 8),
              Text(
                request.time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onTap,
                  child: const Text('Detalle'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: request.status == 'Completado' ? null : onStart,
                  child: const Text('Atender'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: request.status == 'Completado' ? null : onComplete,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Marcar como completado'),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'Completado') return Colors.green;
    if (status == 'En proceso') return AppTheme.primary;
    return Colors.orange;
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _SmallBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, color: AppTheme.primary, size: 36),
          SizedBox(height: 10),
          Text(
            'No hay solicitudes para este filtro',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppTheme.dark,
            ),
          ),
        ],
      ),
    );
  }
}

class _StaffRequest {
  final String room;
  final String guest;
  final String title;
  final String detail;
  String status;
  final String priority;
  final String time;
  final IconData icon;
  final Color color;

  _StaffRequest({
    required this.room,
    required this.guest,
    required this.title,
    required this.detail,
    required this.status,
    required this.priority,
    required this.time,
    required this.icon,
    required this.color,
  });
}
