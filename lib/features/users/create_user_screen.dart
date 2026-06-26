part of '../../main.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});
  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final username = TextEditingController();
  final password = TextEditingController(text: '123456');
  final hotelId = TextEditingController(text: '1');
  final chainId = TextEditingController(text: '1');
  String role = 'staff';
  bool loading = false;

  Future<void> create() async {
    setState(() => loading = true);
    try {
      await AppApi.createUser(username: username.text.trim(), password: password.text, role: role, hotelId: int.tryParse(hotelId.text), chainId: int.tryParse(chainId.text));
      if (!mounted) return;
      showMessage(context, 'Usuario registrado correctamente');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo crear usuario: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrar Personal', style: Theme.of(context).textTheme.headlineSmall), leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        TextField(controller: username, decoration: const InputDecoration(labelText: 'Nombre de Usuario / Email', prefixIcon: Icon(Icons.person))),
        const SizedBox(height: 16),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña Inicial', prefixIcon: Icon(Icons.lock))),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(initialValue: role, decoration: const InputDecoration(labelText: 'Rol del Trabajador', prefixIcon: Icon(Icons.badge)), items: const ['staff', 'reception', 'housekeeping', 'maintenance', 'admin', 'chain_admin'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(), onChanged: (value) => setState(() => role = value ?? 'staff')),
        const SizedBox(height: 16),
        TextField(controller: hotelId, decoration: const InputDecoration(labelText: 'Hotel ID (Opcional)', prefixIcon: Icon(Icons.hotel))),
        const SizedBox(height: 16),
        TextField(controller: chainId, decoration: const InputDecoration(labelText: 'Chain ID (Opcional)', prefixIcon: Icon(Icons.business))),
        const SizedBox(height: 24),
        FilledButton(onPressed: loading ? null : create, child: loading ? const CircularProgressIndicator() : const Text('Registrar e Implementar')),
      ]),
    );
  }
}
