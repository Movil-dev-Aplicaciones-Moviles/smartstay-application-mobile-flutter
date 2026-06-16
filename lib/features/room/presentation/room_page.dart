import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class RoomPage extends StatelessWidget {
  final User user;

  const RoomPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          const Text(
            'Habitaciones',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            user.canManageHotel
                ? 'Puedes visualizar y administrar habitaciones según tu rol.'
                : 'Como huésped puedes visualizar habitaciones y elegir una para reserva.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          const _ApiNotice(),
          const SizedBox(height: 16),
          if (user.canManageHotel) const _AdminRoomActions(),
          const _RoomCard(
            id: 101,
            hotelId: 1,
            roomType: 'Single Standard',
            price: 'S/ 85.00',
            description: 'Habitación 101 con vista estándar.',
            amenities: ['Wifi', 'TV'],
          ),
          const _RoomCard(
            id: 102,
            hotelId: 1,
            roomType: 'Double Deluxe',
            price: 'S/ 150.00',
            description: 'Habitación 102 con vista a la plaza y balcón.',
            amenities: ['Wifi', 'TV', 'Minibar'],
          ),
          const _RoomCard(
            id: 201,
            hotelId: 2,
            roomType: 'Presidential Suite',
            price: 'S/ 320.00',
            description: 'Suite 201 con vista panorámica a la montaña.',
            amenities: ['Jacuzzi', 'Wifi', 'Desayuno', 'Chimenea'],
          ),
          const SizedBox(height: 12),
          const _RemovedFeatureCard(),
        ],
      ),
    );
  }
}

class _ApiNotice extends StatelessWidget {
  const _ApiNotice();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información de habitaciones',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Listado de habitaciones'),
          Text('Ver detalle de habitación'),
          Text('Filtrar habitaciones por tipo'),
          Text('Tipos de habitación'),
        ],
      ),
    );
  }
}

class _AdminRoomActions extends StatelessWidget {
  const _AdminRoomActions();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SmartCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones admin soportadas',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                StatusChip(label: 'POST rooms', color: AppTheme.primary, icon: Icons.add),
                StatusChip(label: 'PUT rooms/{id}', color: Colors.orange, icon: Icons.edit),
                StatusChip(label: 'DELETE rooms/{id}', color: Colors.red, icon: Icons.delete_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final int id;
  final int hotelId;
  final String roomType;
  final String price;
  final String description;
  final List<String> amenities;

  const _RoomCard({
    required this.id,
    required this.hotelId,
    required this.roomType,
    required this.price,
    required this.description,
    required this.amenities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SmartCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.king_bed_outlined, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Room $id',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                      Text('Hotel $hotelId • $roomType'),
                    ],
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(height: 1.35)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amenities
                  .map((item) => Chip(label: Text(item), visualDensity: VisualDensity.compact))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemovedFeatureCard extends StatelessWidget {
  const _RemovedFeatureCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'La app muestra habitaciones, tipos, precios y amenities disponibles para reservar.',
              style: TextStyle(fontWeight: FontWeight.w700, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
