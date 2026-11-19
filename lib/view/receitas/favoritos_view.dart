import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';
import '../../model/receita.dart';
import 'detalhes_receita_view.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas favoritas')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamFavoritos(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Erro ao carregar favoritos. Verifique sua conexão e tente novamente.'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('Você ainda não favoritou nenhuma receita.'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final dados = doc.data();
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.favorite, color: Color(0xFFB66B68)),
                  title: Text('${dados['nome'] ?? 'Receita'}'),
                  subtitle: Text('${dados['categoria'] ?? ''} • ${dados['tempoMinutos'] ?? 0} min'),
                  trailing: IconButton(
                    tooltip: 'Remover dos favoritos',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      try {
                        await controller.alternarFavorito(doc.id, dados, true);
                      } catch (e) {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao remover favorito: $e')));
                      }
                    },
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
    );
  }
}
