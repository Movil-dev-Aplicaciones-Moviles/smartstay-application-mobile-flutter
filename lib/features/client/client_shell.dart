import 'package:flutter/material.dart';
import '../../core/session.dart';
import '../../shared/ui.dart';
import '../auth/login_page.dart';
import '../bookings/bookings_page.dart';
import '../hotels/hotels_page.dart';
import '../payments/payments_page.dart';
import '../profile/profile_page.dart';
import '../rooms/rooms_page.dart';

class ClientShell extends StatefulWidget {
  const ClientShell({super.key});

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HotelsPage(),
    RoomsPage(),
    BookingsPage(),
    PaymentsPage(),
    ProfilePage(),
  ];

  Future<void> _logout() async {
    await SessionStore.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        title: const Text('SmartStay Cliente', style: TextStyle(fontSize: 22)),
        backgroundColor: kSurface,
        surfaceTintColor: kSurface,
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: kError),
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.apartment), label: 'Hoteles'),
          NavigationDestination(icon: Icon(Icons.bed), label: 'Rooms'),
          NavigationDestination(icon: Icon(Icons.event_available), label: 'Reservas'),
          NavigationDestination(icon: Icon(Icons.payments), label: 'Pagos'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
