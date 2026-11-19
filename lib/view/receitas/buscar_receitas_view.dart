import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';
import '../../model/receita.dart';
import 'detalhes_receita_view.dart';

class BuscarReceitasView extends StatefulWidget {
  const BuscarReceitasView({super.key});

  @override
  State<BuscarReceitasView> createState() => _BuscarReceitasViewState();
}

class _BuscarReceitasViewState extends State<BuscarReceitasView> {
  final _campoBusca = TextEditingController();
  String _termo = '';

  @override
  void dispose() {
    _campoBusca.dispose();
    super.dispose();
  }

  Future<void> _alternarFavorito(String id, Map<String, dynamic> dados) async {
    final favorita = dados['favorita'] == true;
    try {
      await ReceitasController.instancia.alternarFavorito(id, dados, favorita);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(favorita ? 'Receita removida dos favoritos.' : 'Receita adicionada aos favoritos.'),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível atualizar o favorito: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Buscar receitas')),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _campoBusca,
          onChanged: (v) => setState(() => _termo = v.toLowerCase().trim()),
          decoration: const InputDecoration(
            hintText: 'Digite o nome da receita',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      Expanded(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: ReceitasController.instancia.streamReceitas(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text('Erro ao buscar receitas. Tente novamente.'));
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data?.docs.where((d) =>
              '${d.data()['nome'] ?? ''}'.toLowerCase().contains(_termo)).toList() ?? [];
            if (docs.isEmpty) return const Center(child: Text('Nenhuma receita encontrada.'));
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final doc = docs[i];
                final dados = doc.data();
                final favorita = dados['favorita'] == true;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: Text('${dados['nome'] ?? 'Receita'}'),
                    subtitle: Text('${dados['categoria'] ?? ''} • ${dados['tempoMinutos'] ?? 0} min'),
                    trailing: IconButton(
                      tooltip: favorita ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                      icon: Icon(favorita ? Icons.favorite : Icons.favorite_border, color: favorita ? Colors.red : null),
                      onPressed: () => _alternarFavorito(doc.id, dados),
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => DetalhesReceitaView(receita: Receita.fromMap(dados)),
                    )),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]),
  );
}
