import 'package:flutter/material.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class BookingsPage extends StatefulWidget {
  final User user;

  const BookingsPage({super.key, required this.user});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  final List<_Booking> bookings = [
    _Booking(
      id: 1,
      roomId: 101,
      guestName: 'Jaredt Montes',
      guestEmail: 'guest@smartstay.com',
      checkInDate: '2026-06-20',
      checkOutDate: '2026-06-22',
      status: 'Pending',
    ),
  ];

  void createBooking() {
    setState(() {
      bookings.insert(
        0,
        _Booking(
          id: bookings.length + 1,
          roomId: 102,
          guestName: 'Jaredt Montes',
          guestEmail: widget.user.username,
          checkInDate: '2026-06-25',
          checkOutDate: '2026-06-27',
          status: 'Pending',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reserva creada correctamente')),
    );
  }

  void updateStatus(_Booking booking, String status) {
    setState(() {
      booking.status = status;
    });

    final action = status == 'Confirmed' ? 'Reserva confirmada' : 'Reserva cancelada';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(action)),
    );
  }

  Color statusColor(String status) {
    if (status == 'Confirmed') return Colors.green;
    if (status == 'Cancelled') return Colors.red;
    if (status == 'Completed') return Colors.blueGrey;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          const Text(
            'Reservas',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            widget.user.canViewAdminData
                ? 'Admin puede listar, confirmar y cancelar reservas.'
                : 'Guest puede crear reservas y consultar su proceso de estadía.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          const _ContractCard(),
          const SizedBox(height: 14),
          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: createBooking,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Crear reserva'),
            ),
          ),
          const SizedBox(height: 18),
          for (final booking in bookings)
            _BookingCard(
              booking: booking,
              canManage: widget.user.canViewAdminData,
              color: statusColor(booking.status),
              onConfirm: () => updateStatus(booking, 'Confirmed'),
              onCancel: () => updateStatus(booking, 'Cancelled'),
            ),
          const SizedBox(height: 12),
          const _CheckInNotice(),
        ],
      ),
    );
  }
}

class _ContractCard extends StatelessWidget {
  const _ContractCard();

  @override
  Widget build(BuildContext context) {
    return const SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información de reservas',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Crear reserva'),
          Text('Listar reservas para administración'),
          Text('Confirmar reserva'),
          Text('Cancelar reserva'),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final _Booking booking;
  final bool canManage;
  final Color color;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _BookingCard({
    required this.booking,
    required this.canManage,
    required this.color,
    required this.onConfirm,
    required this.onCancel,
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
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.event_available_outlined, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reserva #${booking.id}',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                      Text('Room ${booking.roomId} • ${booking.guestName}'),
                    ],
                  ),
                ),
                StatusChip(label: booking.status, color: color, icon: Icons.circle),
              ],
            ),
            const SizedBox(height: 12),
            Text('Email: ${booking.guestEmail}'),
            Text('Check-in date: ${booking.checkInDate}'),
            Text('Check-out date: ${booking.checkOutDate}'),
            if (canManage) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined),
                      label: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onConfirm,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Confirmar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CheckInNotice extends StatelessWidget {
  const _CheckInNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
      ),
      child: const Text(
        'Las reservas manejan estados como Pending, Confirmed, Cancelled y Completed.',
        style: TextStyle(fontWeight: FontWeight.w700, height: 1.35),
      ),
    );
  }
}

class _Booking {
  final int id;
  final int roomId;
  final String guestName;
  final String guestEmail;
  final String checkInDate;
  final String checkOutDate;
  String status;

  _Booking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.guestEmail,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
  });
}
