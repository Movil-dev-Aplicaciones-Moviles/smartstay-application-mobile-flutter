import 'package:flutter/material.dart';
import 'package:smart_stay/core/widgets/page_wrapper.dart';
import 'package:smart_stay/core/widgets/smart_card.dart';
import 'package:smart_stay/core/widgets/status_chip.dart';
import 'package:smart_stay/features/auth/domain/user.dart';

class PaymentsPage extends StatefulWidget {
  final User user;

  const PaymentsPage({super.key, required this.user});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final TextEditingController bookingId = TextEditingController(text: '1');
  final TextEditingController amount = TextEditingController(text: '150.00');
  final TextEditingController card = TextEditingController(text: '4111111111111111');

  String? result;
  bool success = true;

  @override
  void dispose() {
    bookingId.dispose();
    amount.dispose();
    card.dispose();
    super.dispose();
  }

  void processPayment() {
    final value = double.tryParse(amount.text.trim());
    final isDeclined = card.text.trim().endsWith('0000') || value == null || value <= 0;

    setState(() {
      success = !isDeclined;
      result = isDeclined
          ? 'Payment Failed: el pago fue rechazado por la validación simulada.'
          : 'Payment Completed: el pago fue procesado correctamente.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      child: ListView(
        children: [
          const Text(
            'Pagos',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            widget.user.canViewAdminData
                ? 'Puedes procesar pagos y consultar pagos por booking.'
                : 'Como guest puedes procesar el pago de una reserva.',
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
          const SizedBox(height: 16),
          const _ContractCard(),
          const SizedBox(height: 16),
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Procesar pago',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: bookingId,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Booking ID',
                    prefixIcon: Icon(Icons.confirmation_number_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: card,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Card number',
                    helperText: 'Prueba rechazo usando una tarjeta terminada en 0000',
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: processPayment,
                    icon: const Icon(Icons.lock_outline),
                    label: const Text('Procesar pago'),
                  ),
                ),
                if (result != null) ...[
                  const SizedBox(height: 14),
                  StatusChip(
                    label: success ? 'Completed' : 'Failed',
                    color: success ? Colors.green : Colors.red,
                    icon: success ? Icons.check_circle_outline : Icons.error_outline,
                  ),
                  const SizedBox(height: 8),
                  Text(result!, style: const TextStyle(height: 1.35)),
                ],
              ],
            ),
          ),
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
            'Información de pagos',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 8),
          Text('Procesar pago'),
          Text('Consultar pago por reserva'),
          SizedBox(height: 8),
          Text(
            'El sistema registra transacción, monto, estado, tarjeta enmascarada y fecha de pago.',
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}
