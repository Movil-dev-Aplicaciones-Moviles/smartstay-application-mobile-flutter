part of '../../main.dart';

class ProfileListScreen extends StatefulWidget {
  const ProfileListScreen({super.key});
  @override
  State<ProfileListScreen> createState() => _ProfileListScreenState();
}

class _ProfileListScreenState extends State<ProfileListScreen> {
  late Future<List<AppProfile>> futureProfiles;
  @override
  void initState() {
    super.initState();
    futureProfiles = AppApi.getProfiles();
  }

  void reload() => setState(() => futureProfiles = AppApi.getProfiles());

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Directorio Biográfico'), leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))), body: FutureBuilder<List<AppProfile>>(
    future: futureProfiles,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) return ErrorView(message: snapshot.error.toString(), onRetry: reload);
      final profiles = snapshot.data ?? [];
      return ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Fichas registradas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final profile in profiles)
          Card(child: ListTile(title: Text(profile.fullName), subtitle: Text('${profile.email}\n${profile.streetAddress}'), isThreeLine: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileDetailScreen(profileId: profile.id, isReadOnly: true))))),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateProfileScreen(email: Session.user?.username ?? ''))).then((_) => reload()), icon: const Icon(Icons.add), label: const Text('Registrar Perfil')),
      ]);
    },
  ));
}
