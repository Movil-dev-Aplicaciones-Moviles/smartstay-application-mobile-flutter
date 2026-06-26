part of '../main.dart';

class RoleHierarchy {
  static const Map<String, int> hierarchy = {
    'chain_admin': 3,
    'admin': 2,
    'reception': 1,
    'staff': 1,
    'housekeeping': 1,
    'maintenance': 1,
    'guest': 0,
  };

  static List<String> getAssignableRoles(String actorRole, String targetCurrentRole) {
    final actorLevel = hierarchy[actorRole] ?? -1;
    final entries = hierarchy.entries.where((entry) {
      return entry.value < actorLevel && entry.key != targetCurrentRole;
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.map((entry) => entry.key).toList();
  }
}

class UserPermissions {
  final String role;
  const UserPermissions(this.role);

  int get level => RoleHierarchy.hierarchy[role] ?? -1;

  bool get canCreateUsers => role == 'chain_admin';
  bool get canManageUsers => role == 'chain_admin' || role == 'admin';
  bool get canViewAllUsers => canManageUsers;

  bool canEditUser(String targetRole) {
    if (role == 'chain_admin') return true;
    if (role == 'admin') {
      final targetLevel = RoleHierarchy.hierarchy[targetRole] ?? -1;
      return targetLevel < level;
    }
    return false;
  }

  bool canAssignRole(String targetCurrentRole) => canEditUser(targetCurrentRole);
  bool canDeactivateUser(String targetRole) => canEditUser(targetRole);
}
