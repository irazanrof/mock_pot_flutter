import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/receita.dart';

class CriarReceitaView extends StatefulWidget {
  const CriarReceitaView({super.key});

  @override
  State<CriarReceitaView> createState() => _CriarReceitaViewState();
}

class _CriarReceitaViewState extends State<CriarReceitaView> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _tempo = TextEditingController(text: '30');
  final _ingredientes = TextEditingController();
  final _preparo = TextEditingController();
  String _categoria = 'Almoço';
  bool _salvando = false;

  static const _categorias = ['Café da manhã', 'Almoço', 'Sobremesa', 'Lanche'];

  @override
  void dispose() {
    _nome.dispose();
    _tempo.dispose();
    _ingredientes.dispose();
    _preparo.dispose();
    super.dispose();
  }

  Future<void> _criar() async {
    if (!_formKey.currentState!.validate() || _salvando) return;
    setState(() => _salvando = true);
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) {
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entre na sua conta para criar uma receita.')));
      return;
    }
    final receita = Receita(
      nome: _nome.text.trim(), categoria: _categoria,
      tempoMinutos: int.parse(_tempo.text.trim()), icone: Icons.restaurant,
      cor: const Color(0xFFE8EDE5),
      ingredientes: _ingredientes.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      preparo: _preparo.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
      autor: usuario.displayName ?? usuario.email ?? 'Usuário',
    );
    try {
      await ReceitasController.instancia.adicionar(receita);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar receita: $e')));
      return;
    }
    if (!mounted) return;
    setState(() => _salvando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receita criada com sucesso.')),
    );
    Navigator.pop(context);
  }

  String? _obrigatorio(String? valor) =>
      valor == null || valor.trim().isEmpty ? 'Preencha este campo.' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar receita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(controller: _nome, decoration: const InputDecoration(labelText: 'Nome da receita'), validator: _obrigatorio),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (value) => setState(() => _categoria = value ?? _categoria),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _tempo,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Tempo de preparo (minutos)'),
              validator: (value) {
                final minutos = int.tryParse(value ?? '');
                return minutos == null || minutos < 1 ? 'Informe um tempo válido.' : null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _ingredientes,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Ingredientes', helperText: 'Digite um ingrediente por linha'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Informe os ingredientes.' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _preparo,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(labelText: 'Modo de preparo', helperText: 'Digite uma etapa por linha'),
              validator: (value) => value == null || value.trim().isEmpty ? 'Informe o modo de preparo.' : null,
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: _salvando ? null : _criar,
              child: Text(_salvando ? 'Salvando...' : 'Publicar receita'),
            ),
          ],
        ),
      ),
    );
  }
}
