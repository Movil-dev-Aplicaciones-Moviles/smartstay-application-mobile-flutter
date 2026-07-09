import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';

class HotelsPage extends StatefulWidget {
  final ValueChanged<Hotel>? onHotelSelected;

  const HotelsPage({super.key, this.onHotelSelected});

  @override
  State<HotelsPage> createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  final ApiClient _api = ApiClient();
  late Future<List<Hotel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.getHotels();
  }

  void _reload() {
    setState(() {
      _future = _api.getHotels();
    });
  }

  Future<void> _openRoute(Hotel hotel) async {
    return showRoutePreviewSheet(
      context,
      title: 'Ruta hacia ${hotel.name}',
      subtitle: 'Vista previa desde tu ubicación actual hasta el alojamiento.',
      destination: hotel.mapsQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hotel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(message: 'Buscando hoteles disponibles...');
        }
        if (snapshot.hasError) {
          return EmptyState(message: snapshot.error.toString(), buttonText: 'Reintentar', onPressed: _reload);
        }
        final hotels = snapshot.data ?? const <Hotel>[];
        if (hotels.isEmpty) {
          return EmptyState(message: 'No hay alojamientos disponibles', buttonText: 'Actualizar', onPressed: _reload);
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 112),
            itemCount: hotels.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const _DiscoverHero();
              }
              final hotel = hotels[index - 1];
              return _HotelCard(
                hotel: hotel,
                onTap: () => widget.onHotelSelected?.call(hotel),
                onOpenRoute: () => _openRoute(hotel),
              );
            },
          ),
        );
      },
    );
  }
}

class _DiscoverHero extends StatelessWidget {
  const _DiscoverHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kSecondary,
        borderRadius: BorderRadius.circular(28),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80'),
          fit: BoxFit.cover,
          opacity: 0.45,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 34),
          Text(
            '¿Dónde te quieres quedar?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(240),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: kSecondary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hoteles disponibles • Fechas • Habitaciones',
                    style: TextStyle(color: kMuted, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;
  final VoidCallback onOpenRoute;

  const _HotelCard({
    required this.hotel,
    required this.onOpenRoute,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage(url: hotel.imageUrl, height: 190, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(hotel.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 17, color: kMuted),
                              const SizedBox(width: 4),
                              Expanded(child: Text(hotel.location, style: const TextStyle(color: kMuted))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: kSoftPink),
                      child: const Icon(Icons.favorite_border, color: kPrimary, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(hotel.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(hotel.type), avatar: const Icon(Icons.apartment, size: 16)),
                    ...hotel.amenities.take(3).map((amenity) => Chip(label: Text(amenity))),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'S/ ${hotel.basePrice.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                            const TextSpan(text: ' noche'),
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: onOpenRoute,
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Ruta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
