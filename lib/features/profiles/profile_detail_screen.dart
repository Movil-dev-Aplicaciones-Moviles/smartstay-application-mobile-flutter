part of '../../main.dart';

class ProfileDetailScreen extends StatefulWidget {
  final int profileId;
  final bool isReadOnly;
  const ProfileDetailScreen({super.key, required this.profileId, this.isReadOnly = false});
  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late Future<AppProfile> futureProfile;
  @override
  void initState() { super.initState(); futureProfile = AppApi.getProfileById(widget.profileId); }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(widget.isReadOnly ? 'Ficha del Empleado' : 'Mi Perfil'), actions: [IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())), icon: const Icon(Icons.lock_reset)), IconButton(onPressed: () => goToLogin(context), icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.error))]), body: FutureBuilder<AppProfile>(future: futureProfile, builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
    if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: () => setState(() => futureProfile = AppApi.getProfileById(widget.profileId)));
    final profile = snapshot.data!;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: ListTile(leading: Icon(Icons.account_circle, size: 60, color: Theme.of(context).colorScheme.primary), title: Text(profile.fullName), subtitle: Text(profile.email))),
      const SizedBox(height: 16),
      DetailRow(label: 'Dirección', value: profile.streetAddress),
    ]);
  }));
}
