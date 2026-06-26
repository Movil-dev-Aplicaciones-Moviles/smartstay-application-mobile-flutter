part of '../../main.dart';

class EditUserScreen extends StatefulWidget {
  final AppUser user;
  const EditUserScreen({super.key, required this.user});
  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController username;
  late TextEditingController hotelId;
  late TextEditingController chainId;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    username = TextEditingController(text: widget.user.username);
    hotelId = TextEditingController(text: widget.user.hotelId?.toString() ?? '');
    chainId = TextEditingController(text: widget.user.chainId?.toString() ?? '');
  }

  Future<void> save() async {
    setState(() => loading = true);
    try {
      await AppApi.updateUser(id: widget.user.id, username: username.text.trim(), hotelId: int.tryParse(hotelId.text), chainId: int.tryParse(chainId.text));
      if (!mounted) return;
      showMessage(context, 'Usuario actualizado correctamente');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo actualizar: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Editar Usuario')), body: ListView(padding: const EdgeInsets.all(16), children: [
    TextField(controller: username, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person))),
    const SizedBox(height: 16),
    TextField(controller: hotelId, decoration: const InputDecoration(labelText: 'Hotel ID', prefixIcon: Icon(Icons.hotel))),
    const SizedBox(height: 16),
    TextField(controller: chainId, decoration: const InputDecoration(labelText: 'Chain ID', prefixIcon: Icon(Icons.business))),
    const SizedBox(height: 16),
    Card(color: Theme.of(context).colorScheme.secondaryContainer, child: const Padding(padding: EdgeInsets.all(16), child: Text('Los cambios se envían al backend.'))),
    const SizedBox(height: 24),
    FilledButton(onPressed: loading ? null : save, child: loading ? const CircularProgressIndicator() : const Text('Guardar Cambios')),
  ]));
}
