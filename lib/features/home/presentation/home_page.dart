import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class HomePage extends StatelessWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          _Header(user: user),
          const SizedBox(height: 18),
          const _SistemaNotice(),
          const SizedBox(height: 22),
          const Text(
            'Hoteles disponibles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          const _HotelCard(
            name: 'Grand Hotel Bolivar',
            location: 'Lima, Perú',
            type: 'Hotel',
            basePrice: 'Desde S/ 85.00',
            amenities: ['Wifi', 'Restaurante', 'Bar'],
            moduleLabel: 'Hotel disponible para reserva',
          ),
          const _HotelCard(
            name: 'Cusco Andean Lodge',
            location: 'Cusco, Perú',
            type: 'Lodge',
            basePrice: 'Desde S/ 320.00',
            amenities: ['Desayuno', 'Wifi', 'Gimnasio'],
            moduleLabel: 'Hotel disponible para reserva',
          ),
          const SizedBox(height: 12),
          const _ContractCard(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final User user;

  const _Header({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF176B87), Color(0xFF64CCC5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.hotel, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hola, ${user.displayName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Rol: ${user.role}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'SmartStay para gestión hotelera móvil',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Consulta hoteles, habitaciones, reservas, pagos, perfiles y reportes desde una app simple y ordenada.',
            style: TextStyle(color: Colors.white, height: 1.35),
          ),
        ],
      ),
    );
  }
}

class _SistemaNotice extends StatelessWidget {
  const _SistemaNotice();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Row(
        children: [
          Icon(Icons.api_outlined, color: AppTheme.primary),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Explora hoteles, habitaciones, categorías y amenities disponibles para el huésped.',
              style: TextStyle(fontWeight: FontWeight.w700, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final String name;
  final String location;
  final String type;
  final String basePrice;
  final List<String> amenities;
  final String moduleLabel;

  const _HotelCard({
    required this.name,
    required this.location,
    required this.type,
    required this.basePrice,
    required this.amenities,
    required this.moduleLabel,
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
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.apartment, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(location, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                StatusChip(label: type, color: AppTheme.primary, icon: Icons.category_outlined),
                const SizedBox(width: 8),
                StatusChip(label: basePrice, color: Colors.green, icon: Icons.payments_outlined),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: amenities
                  .map((amenity) => Chip(
                        label: Text(amenity),
                        visualDensity: VisualDensity.compact,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              moduleLabel,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard();

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Opciones disponibles',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Listado de hoteles'),
          Text('Ver detalle del alojamiento'),
          Text('Categorías de alojamiento'),
          Text('Amenities disponibles'),
        ],
      ),
    );
  }
}
