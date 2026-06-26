import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final ApiClient _api = ApiClient();
  late Future<List<Room>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getRooms();
  }

  void _reload() {
    setState(() => _future = _api.getRooms());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Room>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(message: 'Cargando habitaciones...');
        }
        if (snapshot.hasError) {
          return EmptyState(message: snapshot.error.toString(), buttonText: 'Reintentar', onPressed: _reload);
        }
        final rooms = snapshot.data ?? const <Room>[];
        if (rooms.isEmpty) {
          return EmptyState(message: 'No hay habitaciones disponibles', buttonText: 'Actualizar', onPressed: _reload);
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: rooms.length,
            itemBuilder: (context, index) => _RoomCard(room: rooms[index]),
          ),
        );
      },
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;

  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bed, size: 40, color: kPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Room ${room.id}', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Hotel ID ${room.hotelId} • ${room.roomTypeName}', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(room.description, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                Text('S/ ${room.price.toStringAsFixed(2)}', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
                if (room.amenities.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: room.amenities.map((a) => Chip(label: Text(a))).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
