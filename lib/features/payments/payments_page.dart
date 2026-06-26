import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final ApiClient _api = ApiClient();
  final TextEditingController _bookingId = TextEditingController(text: '1');
  final TextEditingController _amount = TextEditingController(text: '150.00');
  final TextEditingController _method = TextEditingController(text: 'credit_card');
  final TextEditingController _cardNumber = TextEditingController(text: '4111111111111111');
  final TextEditingController _cardHolder = TextEditingController(text: 'Jaredt Montes');
  final TextEditingController _expiration = TextEditingController(text: '12/28');
  final TextEditingController _cvv = TextEditingController(text: '123');
  bool _loading = false;
  Payment? _payment;

  @override
  void dispose() {
    _bookingId.dispose();
    _amount.dispose();
    _method.dispose();
    _cardNumber.dispose();
    _cardHolder.dispose();
    _expiration.dispose();
    _cvv.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    final bookingId = int.tryParse(_bookingId.text.trim());
    final amount = double.tryParse(_amount.text.trim());
    if (bookingId == null || bookingId <= 0 || amount == null || amount <= 0) {
      showSmartSnack(context, 'Ingresa Booking ID y monto válidos.');
      return;
    }

    setState(() => _loading = true);
    try {
      final payment = await _api.processPayment(
        bookingId: bookingId,
        amount: amount,
        paymentMethod: _method.text.trim(),
        cardNumber: _cardNumber.text.trim(),
        cardHolderName: _cardHolder.text.trim(),
        expirationDate: _expiration.text.trim(),
        cvv: _cvv.text.trim(),
      );
      if (!mounted) return;
      setState(() => _payment = payment);
      showSmartSnack(context, 'Pago procesado correctamente.');
    } catch (e) {
      if (!mounted) return;
      showSmartSnack(context, 'No se pudo procesar el pago: $e');
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
              Text('Procesar pago', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(controller: _bookingId, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Booking ID', prefixIcon: Icon(Icons.confirmation_number), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount', prefixIcon: Icon(Icons.payments), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _method, decoration: const InputDecoration(labelText: 'Payment method', prefixIcon: Icon(Icons.credit_card), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _cardNumber, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Card number', prefixIcon: Icon(Icons.credit_card), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _cardHolder, decoration: const InputDecoration(labelText: 'Card holder', prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: _expiration, decoration: const InputDecoration(labelText: 'Expiration', border: OutlineInputBorder()))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: _cvv, obscureText: true, decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 18),
              SmartButton(text: 'Procesar pago', icon: Icons.lock, loading: _loading, onPressed: _processPayment),
            ],
          ),
        ),
        if (_payment != null)
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pago registrado', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('ID: ${_payment!.id}'),
                Text('Booking ID: ${_payment!.bookingId}'),
                Text('Transacción: ${_payment!.transactionId}'),
                Text('Monto: S/ ${_payment!.amount.toStringAsFixed(2)}'),
                Text('Estado: ${_payment!.status}'),
                Text('Tarjeta: ${_payment!.cardNumberMasked}'),
              ],
            ),
          ),
      ],
    );
  }
}
