import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';

class HotelsPage extends StatefulWidget {
  const HotelsPage({super.key});

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
    setState(() => _future = _api.getHotels());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Hotel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(message: 'Cargando alojamientos...');
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: hotels.length,
            itemBuilder: (context, index) => _HotelCard(hotel: hotels[index]),
          ),
        );
      },
    );
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;

  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.apartment, size: 40, color: kPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(hotel.location, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(hotel.description, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Desde S/ ${hotel.basePrice.toStringAsFixed(2)}', style: const TextStyle(color: kPrimary, fontWeight: FontWeight.w700)),
          if (hotel.amenities.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: hotel.amenities.map((amenity) => Chip(label: Text(amenity))).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
