import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final ApiClient _api = ApiClient();
  final TextEditingController _roomId = TextEditingController(text: '1');
  final TextEditingController _guestName = TextEditingController(text: 'Jaredt Montes');
  final TextEditingController _guestEmail = TextEditingController();
  final TextEditingController _checkIn = TextEditingController(text: '2026-06-20');
  final TextEditingController _checkOut = TextEditingController(text: '2026-06-22');
  bool _loading = false;
  Booking? _created;

  @override
  void initState() {
    super.initState();
    _guestEmail.text = SessionStore.currentUser?.username ?? '';
  }

  @override
  void dispose() {
    _roomId.dispose();
    _guestName.dispose();
    _guestEmail.dispose();
    _checkIn.dispose();
    _checkOut.dispose();
    super.dispose();
  }

  Future<void> _createBooking() async {
    final roomId = int.tryParse(_roomId.text.trim());
    if (roomId == null || roomId <= 0) {
      showSmartSnack(context, 'Ingresa un Room ID válido.');
      return;
    }
    if (_guestName.text.trim().isEmpty || _guestEmail.text.trim().isEmpty) {
      showSmartSnack(context, 'Completa nombre y correo del huésped.');
      return;
    }

    setState(() => _loading = true);
    try {
      final booking = await _api.createBooking(
        roomId: roomId,
        guestName: _guestName.text.trim(),
        guestEmail: _guestEmail.text.trim(),
        checkInDate: _checkIn.text.trim(),
        checkOutDate: _checkOut.text.trim(),
      );
      if (!mounted) return;
      setState(() => _created = booking);
      showSmartSnack(context, 'Reserva creada correctamente. ID: ${booking.id}');
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo crear la reserva: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        SmartCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Crear reserva', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _roomId,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Room ID', prefixIcon: Icon(Icons.meeting_room), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _guestName,
                decoration: const InputDecoration(labelText: 'Nombre del huésped', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _guestEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: _checkIn, decoration: const InputDecoration(labelText: 'Check-in', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _checkOut, decoration: const InputDecoration(labelText: 'Check-out', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 18),
              SmartButton(text: 'Crear reserva', icon: Icons.add_circle, loading: _loading, onPressed: _createBooking),
            ],
          ),
        ),
        if (_created != null)
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reserva creada', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('ID: ${_created!.id}'),
                Text('Room ID: ${_created!.roomId}'),
                Text('Huésped: ${_created!.guestName}'),
                Text('Correo: ${_created!.guestEmail}'),
                Text('Estado: ${_created!.status}'),
                Text('Fechas: ${_created!.checkInDate} → ${_created!.checkOutDate}'),
              ],
            ),
          ),
        const SmartCard(
          child: Text('Nota: el cliente puede crear reservas. La consulta global, confirmación y cancelación son funciones administrativas del backend.'),
        ),
      ],
    );
  }
}
