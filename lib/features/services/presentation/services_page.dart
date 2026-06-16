import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<_HotelService> services = const [
    _HotelService(
      title: 'Room service',
      description: 'Solicita alimentos, bebidas o amenities a tu habitación.',
      icon: Icons.room_service_outlined,
      estimatedTime: '20 min',
    ),
    _HotelService(
      title: 'Limpieza adicional',
      description: 'Programa una limpieza extra durante tu estadía.',
      icon: Icons.cleaning_services_outlined,
      estimatedTime: '15 min',
    ),
    _HotelService(
      title: 'Soporte técnico',
      description: 'Reporta problemas con WiFi, TV, aire o dispositivos IoT.',
      icon: Icons.engineering_outlined,
      estimatedTime: '10 min',
    ),
    _HotelService(
      title: 'Transporte',
      description: 'Solicita traslado al aeropuerto o movilidad local.',
      icon: Icons.local_taxi_outlined,
      estimatedTime: '30 min',
    ),
  ];

  final List<_ServiceRequest> requests = [
    const _ServiceRequest(
      title: 'Toallas adicionales',
      status: 'Completado',
      time: '08:20 AM',
      icon: Icons.check_circle_outline,
    ),
    const _ServiceRequest(
      title: 'Botella de agua',
      status: 'En proceso',
      time: '09:05 AM',
      icon: Icons.pending_actions_outlined,
    ),
  ];

  Future<void> requestService(_HotelService service) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(service.title),
          content: Text(
            '¿Deseas solicitar este servicio?\n\nTiempo estimado: ${service.estimatedTime}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    setState(() {
      requests.insert(
        0,
        _ServiceRequest(
          title: service.title,
          status: 'Pendiente',
          time: 'Ahora',
          icon: Icons.schedule_outlined,
        ),
      );
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${service.title} solicitado correctamente'),
      ),
    );
  }

  Color statusColor(String status) {
    if (status == 'Completado') return Colors.green;
    if (status == 'En proceso') return Colors.orange;
    return AppTheme.primary;
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
              'Servicios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Gestiona solicitudes del hotel desde tu habitación.',
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            const _HeaderCard(),
            const SizedBox(height: 24),
            const Text(
              'Solicitar servicio',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            for (final service in services)
              _ServiceCard(
                service: service,
                onPressed: () => requestService(service),
              ),
            const SizedBox(height: 18),
            const Text(
              'Solicitudes recientes',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
                color: AppTheme.dark,
              ),
            ),
            const SizedBox(height: 12),
            for (final request in requests)
              _RequestCard(
                request: request,
                color: statusColor(request.status),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.support_agent_outlined,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atención disponible',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: AppTheme.dark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'El staff recibirá tu solicitud en tiempo real.',
                  style: TextStyle(
                    color: Colors.black54,
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

class _ServiceCard extends StatelessWidget {
  final _HotelService service;
  final VoidCallback onPressed;

  const _ServiceCard({
    required this.service,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  service.icon,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  service.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            service.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Tiempo estimado: ${service.estimatedTime}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add_task_outlined),
              label: const Text('Solicitar servicio'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final _ServiceRequest request;
  final Color color;

  const _RequestCard({
    required this.request,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(request.icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppTheme.dark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  request.time,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              request.status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelService {
  final String title;
  final String description;
  final IconData icon;
  final String estimatedTime;

  const _HotelService({
    required this.title,
    required this.description,
    required this.icon,
    required this.estimatedTime,
  });
}

class _ServiceRequest {
  final String title;
  final String status;
  final String time;
  final IconData icon;

  const _ServiceRequest({
    required this.title,
    required this.status,
    required this.time,
    required this.icon,
  });
}
