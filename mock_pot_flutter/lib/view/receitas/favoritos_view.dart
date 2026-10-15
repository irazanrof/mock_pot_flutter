import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';

class FavoritosView extends StatelessWidget {
  const FavoritosView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Minhas favoritas')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final favoritas = controller.favoritas;

          if (favoritas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 54,
                      color: Color(0xFF718873),
                    ),
                    SizedBox(height: 12),
                    Text('Você ainda não favoritou nenhuma receita.'),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoritas.length,
            itemBuilder: (context, index) {
              final receita = favoritas[index];

              return Card(
                color: Colors.white,
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: receita.cor,
                    child: Icon(
                      receita.icone,
                      color: const Color(0xFF718873),
                    ),
                  ),
                  title: Text(receita.nome),
                  subtitle: Text(receita.categoria),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.favorite,
                      color: Color(0xFFB66B68),
                    ),
                    onPressed: () =>
                        controller.alternarFavorito(receita),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'detalhes_receita',
                      arguments: receita,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}


