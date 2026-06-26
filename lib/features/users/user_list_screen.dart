part of '../../main.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<AppUser>> futureUsers;
  AppUser get actor => Session.user!;
  UserPermissions get permissions => UserPermissions(actor.role);

  @override
  void initState() {
    super.initState();
    futureUsers = loadUsers();
  }

  Future<List<AppUser>> loadUsers() async {
    final users = await AppApi.getUsers();
    if (actor.role == 'chain_admin') return users;
    return users.where((user) => user.hotelId == actor.hotelId).toList();
  }

  void reload() => setState(() => futureUsers = loadUsers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios', style: Theme.of(context).textTheme.headlineSmall),
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailScreen(profileId: actor.id))), icon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary)),
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileListScreen())), icon: const Icon(Icons.badge)),
          IconButton(onPressed: reload, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => goToLogin(context), icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.error)),
        ],
      ),
      floatingActionButton: permissions.canCreateUsers ? FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateUserScreen())).then((_) => reload()), child: const Icon(Icons.add)) : null,
      body: FutureBuilder<List<AppUser>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
          final users = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: () async => reload(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              itemBuilder: (context, index) => UserCard(user: users[index], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserDetailScreen(userId: users[index].id))).then((_) => reload())),
            ),
          );
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final AppUser user;
  final VoidCallback onTap;
  const UserCard({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
          title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text('${user.role}\n${user.status}', style: TextStyle(color: statusColor(user.status))),
          trailing: const Icon(Icons.chevron_right),
          isThreeLine: true,
        ),
      ),
    );
  }
}