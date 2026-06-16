import 'package:flutter/material.dart';
import 'package:smart_stay/core/theme/app_theme.dart';
import 'package:smart_stay/features/about/presentation/about_page.dart';
import 'package:smart_stay/features/admin/presentation/admin_page.dart';
import 'package:smart_stay/features/auth/domain/user.dart';
import 'package:smart_stay/features/bookings/presentation/bookings_page.dart';
import 'package:smart_stay/features/dashboard/presentation/dashboard_page.dart';
import 'package:smart_stay/features/home/presentation/home_page.dart';
import 'package:smart_stay/features/payments/presentation/payments_page.dart';
import 'package:smart_stay/features/profile/presentation/profile_page.dart';
import 'package:smart_stay/features/room/presentation/room_page.dart';

class MainPage extends StatefulWidget {
  final User user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  List<_NavItem> get items {
    if (widget.user.canViewAdminData) {
      return [
        _NavItem(
          label: 'Hoteles',
          icon: Icons.apartment_outlined,
          selectedIcon: Icons.apartment,
          page: HomePage(user: widget.user),
        ),
        _NavItem(
          label: 'Rooms',
          icon: Icons.king_bed_outlined,
          selectedIcon: Icons.king_bed,
          page: RoomPage(user: widget.user),
        ),
        _NavItem(
          label: 'Reservas',
          icon: Icons.event_available_outlined,
          selectedIcon: Icons.event_available,
          page: BookingsPage(user: widget.user),
        ),
        _NavItem(
          label: 'Admin',
          icon: Icons.admin_panel_settings_outlined,
          selectedIcon: Icons.admin_panel_settings,
          page: AdminPage(user: widget.user),
        ),
        const _NavItem(
          label: 'Reporte',
          icon: Icons.analytics_outlined,
          selectedIcon: Icons.analytics,
          page: DashboardPage(),
        ),
      ];
    }

    if (widget.user.isOperationalStaff) {
      return [
        _NavItem(
          label: 'Hoteles',
          icon: Icons.apartment_outlined,
          selectedIcon: Icons.apartment,
          page: HomePage(user: widget.user),
        ),
        _NavItem(
          label: 'Rooms',
          icon: Icons.king_bed_outlined,
          selectedIcon: Icons.king_bed,
          page: RoomPage(user: widget.user),
        ),
        _NavItem(
          label: 'Estado',
          icon: Icons.lock_outline,
          selectedIcon: Icons.lock,
          page: AdminPage(user: widget.user),
        ),
        _NavItem(
          label: 'Perfil',
          icon: Icons.person_outline,
          selectedIcon: Icons.person,
          page: ProfilePage(user: widget.user),
        ),
        const _NavItem(
          label: 'Info',
          icon: Icons.info_outline,
          selectedIcon: Icons.info,
          page: AboutPage(),
        ),
      ];
    }

    return [
      _NavItem(
        label: 'Hoteles',
        icon: Icons.apartment_outlined,
        selectedIcon: Icons.apartment,
        page: HomePage(user: widget.user),
      ),
      _NavItem(
        label: 'Rooms',
        icon: Icons.king_bed_outlined,
        selectedIcon: Icons.king_bed,
        page: RoomPage(user: widget.user),
      ),
      _NavItem(
        label: 'Reservas',
        icon: Icons.event_available_outlined,
        selectedIcon: Icons.event_available,
        page: BookingsPage(user: widget.user),
      ),
      _NavItem(
        label: 'Pagos',
        icon: Icons.payments_outlined,
        selectedIcon: Icons.payments,
        page: PaymentsPage(user: widget.user),
      ),
      _NavItem(
        label: 'Perfil',
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        page: ProfilePage(user: widget.user),
      ),
    ];
  }

  void changePage(int value) {
    setState(() {
      selectedIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navItems = items;

    if (selectedIndex >= navItems.length) {
      selectedIndex = 0;
    }

    return Scaffold(
      extendBody: true,
      body: navItems[selectedIndex].page,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              selectedIndex: selectedIndex,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: changePage,
              destinations: navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon, color: AppTheme.primary),
                      label: item.label,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}
