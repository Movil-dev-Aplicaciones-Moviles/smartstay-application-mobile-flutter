import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';
import '../auth/login_page.dart';

class RoomsPage extends StatefulWidget {
  final Hotel? selectedHotel;
  final ValueChanged<Booking>? onBookingCreated;
  final VoidCallback? onShowHotels;

  const RoomsPage({
    super.key,
    this.selectedHotel,
    this.onBookingCreated,
    this.onShowHotels,
  });

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final ApiClient _api = ApiClient();
  late Future<_RoomsData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant RoomsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedHotel?.id != widget.selectedHotel?.id) {
      _reload();
    }
  }

  Future<_RoomsData> _load() async {
    final hotels = await _api.getHotels();
    final rooms = widget.selectedHotel == null ? await _api.getRooms() : await _api.getRoomsByHotel(widget.selectedHotel!.id);
    return _RoomsData(hotels: hotels, rooms: rooms);
  }

  void _reload() {
    setState(() => _future = _load());
  }

  Future<void> _openBookingSheet(Room room, Hotel? hotel) async {
    if (SessionStore.currentUser == null) {
      _showLoginRequired();
      return;
    }

    final booking = await showModalBottomSheet<Booking>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingSheet(api: _api, room: room, hotel: hotel),
    );

    if (booking == null || !mounted) return;
    showSmartSnack(context, 'Reserva creada. Estado: ${booking.status}');
    widget.onBookingCreated?.call(booking);
  }

  void _showLoginRequired() {
    showAuthPromptSheet(
      context,
      title: '¡Hola! Inicia sesión para reservar',
      message: 'Puedes cerrar este aviso y seguir explorando. Para confirmar una habitación necesitamos tu cuenta.',
      onLogin: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RoomsData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView(message: 'Cargando habitaciones disponibles...');
        }
        if (snapshot.hasError) {
          return EmptyState(message: snapshot.error.toString(), buttonText: 'Reintentar', onPressed: _reload);
        }

        final data = snapshot.data ?? const _RoomsData(hotels: [], rooms: []);
        if (data.rooms.isEmpty) {
          return EmptyState(
            message: widget.selectedHotel == null
                ? 'No hay habitaciones disponibles'
                : 'Este hotel todavía no tiene habitaciones disponibles',
            buttonText: widget.selectedHotel == null ? 'Actualizar' : 'Volver a hoteles',
            onPressed: widget.selectedHotel == null ? _reload : widget.onShowHotels ?? _reload,
          );
        }

        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 112),
            itemCount: data.rooms.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _RoomsHeader(hotel: widget.selectedHotel, onShowHotels: widget.onShowHotels);
              }
              final room = data.rooms[index - 1];
              final hotel = data.hotelFor(room.hotelId) ?? widget.selectedHotel;
              final hotelName = hotel?.name ?? 'Hotel no identificado';
              return _RoomCard(
                room: room,
                hotelName: hotelName,
                onBook: () => _openBookingSheet(room, hotel),
              );
            },
          ),
        );
      },
    );
  }
}

class _RoomsData {
  final List<Hotel> hotels;
  final List<Room> rooms;

  const _RoomsData({required this.hotels, required this.rooms});

  Hotel? hotelFor(int hotelId) {
    for (final hotel in hotels) {
      if (hotel.id == hotelId) return hotel;
    }
    return null;
  }
}

class _RoomsHeader extends StatelessWidget {
  final Hotel? hotel;
  final VoidCallback? onShowHotels;

  const _RoomsHeader({required this.hotel, this.onShowHotels});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hotel != null)
            TextButton.icon(
              onPressed: onShowHotels,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Cambiar hotel'),
            ),
          SectionHeader(
            title: hotel == null ? 'Habitaciones disponibles' : 'Habitaciones en ${hotel!.name}',
            subtitle: hotel == null ? 'Reserva desde el cuarto que prefieras.' : hotel!.location,
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  final String hotelName;
  final VoidCallback onBook;

  const _RoomCard({
    required this.room,
    required this.hotelName,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final canBook = room.isAvailable;
    final imageUrl = _roomImageUrl(room.id);
    return SmartCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                url: imageUrl,
                height: 210,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                fallbackIcon: Icons.king_bed_outlined,
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(230),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: kSecondary, size: 21),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(canBook ? Icons.check_circle : Icons.info_outline, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        canBook ? 'Disponible ahora' : room.status,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
                          Text('Habitación ${room.id}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 4),
                          Text('$hotelName • ${room.roomTypeName}', style: const TextStyle(color: kMuted)),
                        ],
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: kSecondary, size: 17),
                        SizedBox(width: 4),
                        Text('4.9', style: TextStyle(fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(room.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: room.amenities.take(4).map((a) => Chip(label: Text(a))).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'S/ ${room.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                            ),
                            const TextSpan(text: ' noche'),
                          ],
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: canBook ? onBook : null,
                      icon: const Icon(Icons.event_available),
                      label: const Text('Reservar'),
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

  String _roomImageUrl(int id) {
    final images = [
      'https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1590490360182-c33d57733427?auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1000&q=80',
    ];
    return images[id.abs() % images.length];
  }
}

class _BookingSheet extends StatefulWidget {
  final ApiClient api;
  final Room room;
  final Hotel? hotel;

  const _BookingSheet({
    required this.api,
    required this.room,
    required this.hotel,
  });

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  late final TextEditingController _guestName;
  late final TextEditingController _guestEmail;
  late final TextEditingController _checkIn;
  late final TextEditingController _checkOut;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  bool _loading = false;

  String get _hotelName => widget.hotel?.name ?? 'SmartStay';
  String get _hotelDestination => widget.hotel?.mapsQuery ?? _hotelName;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _checkInDate = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    _checkOutDate = _checkInDate.add(const Duration(days: 2));
    _guestName = TextEditingController(text: SessionStore.currentUser?.username.split('@').first ?? 'Cliente');
    _guestEmail = TextEditingController(text: SessionStore.currentUser?.username ?? '');
    _checkIn = TextEditingController(text: _formatDate(_checkInDate));
    _checkOut = TextEditingController(text: _formatDate(_checkOutDate));
  }

  @override
  void dispose() {
    _guestName.dispose();
    _guestEmail.dispose();
    _checkIn.dispose();
    _checkOut.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final firstDate = isCheckIn ? today : _checkInDate.add(const Duration(days: 1));
    final initialDate = isCheckIn ? _checkInDate : _checkOutDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: firstDate.add(const Duration(days: 365)),
      helpText: isCheckIn ? 'Selecciona check-in' : 'Selecciona check-out',
      cancelText: 'Cancelar',
      confirmText: 'Elegir',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: kPrimary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: kSecondary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        _checkInDate = picked;
        _checkIn.text = _formatDate(picked);
        if (!_checkOutDate.isAfter(_checkInDate)) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
          _checkOut.text = _formatDate(_checkOutDate);
        }
      } else {
        _checkOutDate = picked;
        _checkOut.text = _formatDate(picked);
      }
    });
  }

  Future<void> _createBooking() async {
    if (_guestName.text.trim().isEmpty || _guestEmail.text.trim().isEmpty) {
      showSmartSnack(context, 'Completa nombre y correo.');
      return;
    }
    if (!_checkOutDate.isAfter(_checkInDate)) {
      showSmartSnack(context, 'El check-out debe ser posterior al check-in.');
      return;
    }

    setState(() => _loading = true);
    try {
      final booking = await widget.api.createBooking(
        roomId: widget.room.id,
        guestName: _guestName.text.trim(),
        guestEmail: _guestEmail.text.trim(),
        checkInDate: _checkIn.text.trim(),
        checkOutDate: _checkOut.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, booking);
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo crear la reserva: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final nights = _checkOutDate.difference(_checkInDate).inDays.clamp(1, 365);
    final total = widget.room.price * nights;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 560),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(99)),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: _loading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reserva tu estadía', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: kSoftBlue),
                        child: const Icon(Icons.king_bed_outlined, color: kPrimaryDark, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: kLine),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _PriceMini(label: 'Precio', value: 'S/ ${widget.room.price.toStringAsFixed(0)} noche'),
                        ),
                        Container(width: 1, height: 44, color: kLine),
                        Expanded(
                          child: _PriceMini(label: 'Total aprox.', value: 'S/ ${total.toStringAsFixed(0)}'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text('A dónde irás', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  RoutePreviewCard(destination: _hotelDestination, height: 210, showDetails: false),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _guestName,
                    decoration: const InputDecoration(labelText: 'Nombre del huésped', prefixIcon: Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _guestEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.mail_outline)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _checkIn,
                          readOnly: true,
                          onTap: () => _pickDate(isCheckIn: true),
                          decoration: const InputDecoration(
                            labelText: 'Llegada',
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _checkOut,
                          readOnly: true,
                          onTap: () => _pickDate(isCheckIn: false),
                          decoration: const InputDecoration(
                            labelText: 'Salida',
                            prefixIcon: Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FA),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: kPrimaryDark),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tu reserva quedará pendiente hasta que el alojamiento la confirme.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: kMuted, height: 1.25),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SmartButton(text: 'Confirmar reserva', icon: Icons.check_circle, loading: _loading, dark: true, onPressed: _createBooking),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceMini extends StatelessWidget {
  final String label;
  final String value;

  const _PriceMini({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: kMuted, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
