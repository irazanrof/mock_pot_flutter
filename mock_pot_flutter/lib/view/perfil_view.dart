import 'package:flutter/material.dart';
import '../controller/usuario_controller.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});
  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  final _formKey = GlobalKey<FormState>();
  final _usuario = UsuarioController();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _carregando = true;
  bool _editando = false;

  @override
  void initState() { super.initState(); _carregar(); }
  Future<void> _carregar() async {
    final dados = await _usuario.obterUsuarioAtual();
    if (!mounted) return;
    if (dados != null) {
      _nomeController.text = dados['nome'] ?? '';
      _emailController.text = dados['email'] ?? '';
      _telefoneController.text = dados['telefone'] ?? '';
    }
    setState(() { _carregando = false; });
  }
  @override
  void dispose() { _nomeController.dispose(); _emailController.dispose(); _telefoneController.dispose(); super.dispose(); }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final salvo = await _usuario.salvarPerfil(nome: _nomeController.text, telefone: _telefoneController.text);
    if (!mounted) return;
    if (salvo) {
      setState(() => _editando = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível salvar. Entre novamente na sua conta.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF718873);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu perfil'),
        actions: [
          if (!_carregando && !_editando)
            IconButton(
              tooltip: 'Editar perfil',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => setState(() => _editando = true),
            ),
        ],
      ),
      backgroundColor: const Color(0xFFFAF9F6),
      body: _carregando ? const Center(child: CircularProgressIndicator()) : _emailController.text.isEmpty
        ? const Center(child: Text('Nenhum usuário conectado. Faça login novamente.'))
        : Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 420), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const CircleAvatar(radius: 48, backgroundColor: Color(0xFFE8EDE5), child: Icon(Icons.person_outline, size: 52, color: verde)),
            const SizedBox(height: 24),
            TextFormField(controller: _nomeController, readOnly: !_editando, decoration: const InputDecoration(labelText: 'Nome', prefixIcon: Icon(Icons.person_outline)), validator: (v) => v == null || v.trim().length < 3 ? 'Informe um nome com pelo menos 3 caracteres.' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, readOnly: true, decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.email_outlined))),
            const SizedBox(height: 16),
            TextFormField(controller: _telefoneController, readOnly: !_editando, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone_outlined)), validator: (v) => v == null || v.trim().length < 8 ? 'Informe um telefone válido.' : null),
            if (_editando) ...[
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar alterações')),
              TextButton(onPressed: _carregarAndCancelar, child: const Text('Cancelar')),
            ],
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: _sair,
              icon: const Icon(Icons.logout),
              label: const Text('Sair da conta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ]))))),
    );
  }

  Future<void> _carregarAndCancelar() async {
    await _carregar();
    if (mounted) setState(() => _editando = false);
  }
  Future<void> _sair() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    await _usuario.sair();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

}
