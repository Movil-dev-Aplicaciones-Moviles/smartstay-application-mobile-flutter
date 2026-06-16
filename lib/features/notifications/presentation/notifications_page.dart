import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_SmartAlert> alerts = [
    _SmartAlert(
      title: 'Check-in digital confirmado',
      description: 'Tu habitación A-204 ya está activa. Puedes usar el código A8-42 para ingresar.',
      time: 'Hace 5 min',
      category: 'Check-in',
      icon: Icons.meeting_room_outlined,
      color: AppTheme.primary,
      read: false,
    ),
    _SmartAlert(
      title: 'Room service en proceso',
      description: 'Tu solicitud fue recibida por el staff. Tiempo estimado de atención: 20 minutos.',
      time: 'Hace 12 min',
      category: 'Servicios',
      icon: Icons.room_service_outlined,
      color: Colors.orange,
      read: false,
    ),
    _SmartAlert(
      title: 'Código de acceso activo',
      description: 'La llave digital de tu habitación se encuentra habilitada durante tu estadía.',
      time: 'Hace 25 min',
      category: 'Acceso',
      icon: Icons.key_outlined,
      color: Colors.indigo,
      read: false,
    ),
    _SmartAlert(
      title: 'Habitación en modo confort',
      description: 'Temperatura y luces configuradas según tu preferencia de descanso.',
      time: 'Hoy',
      category: 'Room smart',
      icon: Icons.thermostat_outlined,
      color: Colors.teal,
      read: true,
    ),
    _SmartAlert(
      title: 'Check-out disponible',
      description: 'Ya puedes revisar tus consumos y confirmar tu salida desde la app.',
      time: 'Ayer',
      category: 'Check-out',
      icon: Icons.logout_outlined,
      color: Colors.green,
      read: true,
    ),
  ];

  int selectedFilter = 0;

  List<String> get filters => const ['Todas', 'Nuevas', 'Servicios'];

  List<_SmartAlert> get visibleAlerts {
    if (selectedFilter == 1) {
      return alerts.where((alert) => !alert.read).toList();
    }

    if (selectedFilter == 2) {
      return alerts.where((alert) => alert.category == 'Servicios').toList();
    }

    return alerts;
  }

  int get unreadCount => alerts.where((alert) => !alert.read).length;

  void markAllAsRead() {
    setState(() {
      for (final alert in alerts) {
        alert.read = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todas las alertas fueron marcadas como leídas')),
    );
  }

  void openAlert(_SmartAlert alert) {
    setState(() {
      alert.read = true;
    });

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alert.title),
          content: Text(alert.description),
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

  void addDemoAlert() {
    setState(() {
      alerts.insert(
        0,
        _SmartAlert(
          title: 'Nueva solicitud registrada',
          description: 'El staff recibió una solicitud de servicio desde la habitación A-204.',
          time: 'Ahora',
          category: 'Servicios',
          icon: Icons.add_alert_outlined,
          color: AppTheme.primary,
          read: false,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alertas',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.dark,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Seguimiento de tu estadía en SmartStay.',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                _CounterBadge(count: unreadCount),
              ],
            ),
            const SizedBox(height: 18),
            _SummaryCard(
              unreadCount: unreadCount,
              onMarkAllRead: markAllAsRead,
            ),
            const SizedBox(height: 18),
            _FilterBar(
              filters: filters,
              selectedIndex: selectedFilter,
              onChanged: (index) {
                setState(() {
                  selectedFilter = index;
                });
              },
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: addDemoAlert,
                icon: const Icon(Icons.notification_add_outlined),
                label: const Text('Simular nueva alerta'),
              ),
            ),
            const SizedBox(height: 18),
            if (visibleAlerts.isEmpty)
              const _EmptyAlerts()
            else
              for (final alert in visibleAlerts)
                _AlertCard(
                  alert: alert,
                  onTap: () => openAlert(alert),
                ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAllRead;

  const _SummaryCard({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF176B87), Color(0xFF0F172A)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unreadCount == 0 ? 'Todo al día' : '$unreadCount alertas pendientes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Aquí verás check-in, servicios, room smart y check-out.',
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              onPressed: unreadCount == 0 ? null : onMarkAllRead,
              icon: const Icon(Icons.done_all_outlined),
              label: const Text('Marcar todo como leído'),
            ),
          ),
        ],
      ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int index = 0; index < filters.length; index++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(filters[index]),
                selected: selectedIndex == index,
                selectedColor: AppTheme.secondary.withValues(alpha: 0.22),
                onSelected: (_) => onChanged(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final _SmartAlert alert;
  final VoidCallback onTap;

  const _AlertCard({
    required this.alert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: alert.read ? const Color(0xFFE2E8F0) : alert.color.withValues(alpha: 0.4),
          ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: alert.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    alert.icon,
                    color: alert.color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.dark,
                              ),
                            ),
                          ),
                          if (!alert.read)
                            Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                color: alert.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert.time,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              alert.description,
              style: const TextStyle(
                color: Color(0xFF64748B),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MiniBadge(
                  label: alert.category,
                  color: alert.color,
                ),
                _MiniBadge(
                  label: alert.read ? 'Leído' : 'Nuevo',
                  color: alert.read ? Colors.grey : AppTheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MiniBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CounterBadge extends StatelessWidget {
  final int count;

  const _CounterBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: count == 0 ? Colors.green.withValues(alpha: 0.12) : AppTheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        '$count nuevas',
        style: TextStyle(
          color: count == 0 ? Colors.green : AppTheme.primary,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _EmptyAlerts extends StatelessWidget {
  const _EmptyAlerts();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            color: AppTheme.primary,
            size: 38,
          ),
          SizedBox(height: 10),
          Text(
            'No hay alertas para este filtro',
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

class _SmartAlert {
  final String title;
  final String description;
  final String time;
  final String category;
  final IconData icon;
  final Color color;
  bool read;

  _SmartAlert({
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    required this.icon,
    required this.color,
    required this.read,
  });
}
