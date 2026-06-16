class User {
  final int id;
  final String username;
  final String role;
  final int? hotelId;
  final int? chainId;

  User({
    required this.id,
    required this.username,
    required this.role,
    this.hotelId,
    this.chainId,
  });

  bool get isGuest => role == 'guest';
  bool get isAdmin => role == 'admin';
  bool get isChainAdmin => role == 'chain_admin';

  bool get canManageHotel => isAdmin || isChainAdmin;
  bool get canViewAdminData => isAdmin || isChainAdmin;

  bool get isOperationalStaff =>
      role == 'staff' ||
      role == 'reception' ||
      role == 'housekeeping' ||
      role == 'maintenance';

  String get displayName {
    if (username.contains('@')) {
      return username.split('@').first;
    }

    return username;
  }
}
