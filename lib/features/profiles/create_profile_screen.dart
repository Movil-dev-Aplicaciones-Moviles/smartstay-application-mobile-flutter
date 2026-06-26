part of '../../main.dart';

class CreateProfileScreen extends StatefulWidget {
  final String email;
  const CreateProfileScreen({super.key, required this.email});
  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  late final TextEditingController email;
  final street = TextEditingController(text: 'Av. Principal');
  final number = TextEditingController(text: '123');
  final city = TextEditingController(text: 'Lima');
  final postalCode = TextEditingController(text: '15001');
  final country = TextEditingController(text: 'Perú');
  bool loading = false;
  @override
  void initState() { super.initState(); email = TextEditingController(text: widget.email); }
  Future<void> save() async {
    setState(() => loading = true);
    try {
      await AppApi.createProfile(firstName: firstName.text, lastName: lastName.text, email: email.text, street: street.text, number: number.text, city: city.text, postalCode: postalCode.text, country: country.text);
      if (!mounted) return;
      showMessage(context, 'Ficha biográfica registrada');
      Navigator.pop(context);
    } catch (e) { if (mounted) showMessage(context, 'No se pudo crear perfil: $e'); } finally { if (mounted) setState(() => loading = false); }
  }
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Registrar Perfil')), body: ListView(padding: const EdgeInsets.all(16), children: [
    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ficha del empleado', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 6), const Text('Completa la información biográfica asociada al usuario operativo.')] ))),
    const SizedBox(height: 16),
    TextField(controller: firstName, decoration: const InputDecoration(labelText: 'Nombre')),
    const SizedBox(height: 16),
    TextField(controller: lastName, decoration: const InputDecoration(labelText: 'Apellidos')),
    const SizedBox(height: 16),
    TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
    const SizedBox(height: 16),
    TextField(controller: street, decoration: const InputDecoration(labelText: 'Calle')),
    const SizedBox(height: 16),
    TextField(controller: number, decoration: const InputDecoration(labelText: 'Número')),
    const SizedBox(height: 16),
    TextField(controller: city, decoration: const InputDecoration(labelText: 'Ciudad')),
    const SizedBox(height: 16),
    TextField(controller: postalCode, decoration: const InputDecoration(labelText: 'Código postal')),
    const SizedBox(height: 16),
    TextField(controller: country, decoration: const InputDecoration(labelText: 'País')),
    const SizedBox(height: 24),
    FilledButton(onPressed: loading ? null : save, child: loading ? const CircularProgressIndicator() : const Text('Guardar Ficha Biográfica')),
  ]));
}
