import 'package:flutter/material.dart';
import '../../core/session.dart';
import '../../domain/models.dart';
import '../../shared/ui.dart';
import '../bookings/bookings_page.dart';
import '../auth/login_page.dart';
import '../hotels/hotels_page.dart';
import '../profile/profile_page.dart';
import '../rooms/rooms_page.dart';

class ClientShell extends StatefulWidget {
  const ClientShell({super.key});

  @override
  State<ClientShell> createState() => _ClientShellState();
}

class _ClientShellState extends State<ClientShell> {
  int _index = 0;
  Hotel? _selectedHotel;

  void _openHotelRooms(Hotel hotel) {
    setState(() {
      _selectedHotel = hotel;
      _index = 1;
    });
  }

  void _openLoginPrompt(int targetIndex) {
    final label = switch (targetIndex) {
      2 => 'ver tus reservas',
      _ => 'administrar tu perfil',
    };

    showAuthPromptSheet(
      context,
      title: 'Inicia sesión para continuar',
      message: 'Puedes seguir explorando alojamientos sin cuenta. Para $label necesitamos saber quién eres.',
      onLogin: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HotelsPage(onHotelSelected: _openHotelRooms),
      RoomsPage(
        selectedHotel: _selectedHotel,
        onShowHotels: () => setState(() => _index = 0),
        onBookingCreated: (_) => setState(() => _index = 2),
      ),
      const BookingsPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: kSurface,
      body: SafeArea(bottom: false, child: pages[_index]),
      bottomNavigationBar: _FloatingBottomNav(
        selectedIndex: _index,
        onDestinationSelected: (value) {
          if (value == 2 && SessionStore.currentUser == null) {
            _openLoginPrompt(value);
            return;
          }
          setState(() {
            _index = value;
            if (value == 0) _selectedHotel = null;
          });
        },
        items: const [
          _NavItem(icon: Icons.explore_outlined, activeIcon: Icons.explore, label: 'Explora'),
          _NavItem(icon: Icons.bed_outlined, activeIcon: Icons.bed, label: 'Cuartos'),
          _NavItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month, label: 'Reservas'),
          _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Perfil'),
        ],
      ),
    );
  }
}

class _FloatingBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<_NavItem> items;

  const _FloatingBottomNav({
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 76,
        margin: const EdgeInsets.fromLTRB(18, 8, 18, 16),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(36), blurRadius: 22, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _NavButton(
                item: items[0],
                selected: selectedIndex == 0,
                onTap: () => onDestinationSelected(0),
              ),
            ),
            Expanded(
              child: _NavButton(
                item: items[1],
                selected: selectedIndex == 1,
                onTap: () => onDestinationSelected(1),
              ),
            ),
            Expanded(
              child: _CenterLogoButton(onTap: () => onDestinationSelected(0)),
            ),
            Expanded(
              child: _NavButton(
                item: items[2],
                selected: selectedIndex == 2,
                onTap: () => onDestinationSelected(2),
              ),
            ),
            Expanded(
              child: _NavButton(
                item: items[3],
                selected: selectedIndex == 3,
                onTap: () => onDestinationSelected(3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _CenterLogoButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterLogoButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: const Center(
        child: SmartLogoMark(size: 30, framed: false),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        decoration: BoxDecoration(
          color: selected ? kSecondary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? item.activeIcon : item.icon, color: selected ? Colors.white : kMuted, size: 21),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : kMuted,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
