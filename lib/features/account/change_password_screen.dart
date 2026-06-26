part of '../../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final current = TextEditingController();
  final next = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;
  Future<void> change() async {
    if (next.text != confirm.text) return showMessage(context, 'Las contraseñas no coinciden');
    setState(() => loading = true);
    try {
      await AppApi.changePassword(current.text, next.text);
      if (!mounted) return;
      showMessage(context, 'Contraseña actualizada correctamente');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) showMessage(context, 'No se pudo cambiar contraseña: $e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Cambiar Contraseña')), body: ListView(padding: const EdgeInsets.all(16), children: [
    TextField(controller: current, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña actual', prefixIcon: Icon(Icons.lock))),
    const SizedBox(height: 16),
    TextField(controller: next, obscureText: true, decoration: const InputDecoration(labelText: 'Nueva contraseña', prefixIcon: Icon(Icons.lock))),
    const SizedBox(height: 16),
    TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña', prefixIcon: Icon(Icons.lock))),
    const SizedBox(height: 24),
    FilledButton(onPressed: loading ? null : change, child: loading ? const CircularProgressIndicator() : const Text('Cambiar Contraseña')),
  ]));
}
