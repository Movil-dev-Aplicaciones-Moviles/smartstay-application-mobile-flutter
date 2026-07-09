import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';
import '../auth/login_page.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final ApiClient _api = ApiClient();
  late Future<_BookingsData> _future;
  int? _updatingBookingId;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_BookingsData> _load() async {
    final bookings = await _api.getMyBookings();
    final rooms = await _api.getRooms();
    final hotels = await _api.getHotels();
    return _BookingsData(bookings: bookings, rooms: rooms, hotels: hotels);
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  void _openLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  Future<void> _cancelBooking(Booking booking) async {
    setState(() => _updatingBookingId = booking.id);
    try {
      await _api.cancelMyBooking(booking.id);
      if (!mounted) return;
      showSmartSnack(context, 'Reserva cancelada correctamente.');
      _reload();
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo cancelar la reserva: $e');
    } finally {
      if (mounted) setState(() => _updatingBookingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (SessionStore.currentUser == null) {
      return AuthRequiredCard(
        title: 'Tus reservas aparecerán aquí',
        message: 'Explora hoteles sin cuenta. Cuando quieras reservar o revisar tus reservas, inicia sesión.',
        onLogin: _openLogin,
      );
    }

    return FutureBuilder<_BookingsData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(message: 'Cargando tus reservas...');
        }
        if (snapshot.hasError) {
          return EmptyState(message: snapshot.error.toString(), buttonText: 'Reintentar', onPressed: _reload);
        }

        final data = snapshot.data ?? const _BookingsData(bookings: [], rooms: [], hotels: []);
        if (data.bookings.isEmpty) {
          return EmptyState(
            message: 'Todavía no tienes reservas. Elige un hotel, entra a una habitación y reserva desde ahí.',
            buttonText: 'Actualizar',
            onPressed: _reload,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 112),
            itemCount: data.bookings.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SectionHeader(
                  title: 'Mis reservas',
                  subtitle: 'Revisa el estado de tus habitaciones reservadas.',
                );
              }

              final booking = data.bookings[index - 1];
              final room = data.roomFor(booking.roomId);
              final hotel = room == null ? null : data.hotelFor(room.hotelId);
              return _BookingCard(
                booking: booking,
                room: room,
                hotel: hotel,
                loading: _updatingBookingId == booking.id,
                onCancel: booking.status.toLowerCase() == 'cancelled' ? null : () => _cancelBooking(booking),
              );
            },
          ),
        );
      },
    );
  }
}

class _BookingsData {
  final List<Booking> bookings;
  final List<Room> rooms;
  final List<Hotel> hotels;

  const _BookingsData({required this.bookings, required this.rooms, required this.hotels});

  Room? roomFor(int roomId) {
    for (final room in rooms) {
      if (room.id == roomId) return room;
    }
    return null;
  }

  Hotel? hotelFor(int hotelId) {
    for (final hotel in hotels) {
      if (hotel.id == hotelId) return hotel;
    }
    return null;
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final Room? room;
  final Hotel? hotel;
  final bool loading;
  final VoidCallback? onCancel;

  const _BookingCard({
    required this.booking,
    required this.room,
    required this.hotel,
    required this.loading,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final status = booking.status.toLowerCase();
    final isConfirmed = status == 'confirmed';
    final isCancelled = status == 'cancelled' || status == 'canceled';
    final statusColor = isConfirmed
        ? const Color(0xFFE8F5E9)
        : isCancelled
            ? const Color(0xFFFFEBEE)
            : const Color(0xFFFFF8E1);
    final statusLabel = isConfirmed
        ? 'Aceptada'
        : isCancelled
            ? 'Cancelada'
            : 'Pendiente';

    return SmartCard(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.king_bed_outlined, color: kPrimary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hotel?.name ?? 'Hotel no identificado',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(room?.roomTypeName ?? 'Habitación reservada',
                        style: const TextStyle(color: kMuted)),
                  ],
                ),
              ),
              Chip(label: Text(statusLabel), backgroundColor: statusColor),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, size: 18, color: kMuted),
              const SizedBox(width: 6),
              Expanded(child: Text('${booking.checkInDate.split('T').first} al ${booking.checkOutDate.split('T').first}')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 18, color: kMuted),
              const SizedBox(width: 6),
              Expanded(child: Text(booking.guestName)),
            ],
          ),
          if (!isCancelled) ...[
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: loading ? null : onCancel,
              icon: loading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.cancel_outlined),
              label: const Text('Cancelar reserva'),
            ),
          ],
        ],
      ),
    );
  }
}
