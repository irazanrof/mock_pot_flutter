import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';

class CategoriasReceitasView extends StatelessWidget {
  const CategoriasReceitasView({super.key});

  static const List<String> categorias = [
    'Café da manhã',
    'Almoço',
    'Sobremesa',
    'Lanche',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categorias.length,
        itemBuilder: (context, index) {
          final categoria = categorias[index];

          return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8EDE6),
                child: Icon(
                  Icons.restaurant_menu,
                  color: Color(0xFF718873),
                ),
              ),
              title: Text(categoria),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                final receitas = controller.porCategoria(categoria);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => _ResultadoCategoria(
                      categoria: categoria,
                      receitas: receitas,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ResultadoCategoria extends StatelessWidget {
  final String categoria;
  final List<dynamic> receitas;

  const _ResultadoCategoria({
    required this.categoria,
    required this.receitas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoria)),
      body: receitas.isEmpty
          ? const Center(child: Text('Nenhuma receita nesta categoria.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: receitas.length,
              itemBuilder: (context, index) {
                final receita = receitas[index];

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
                    subtitle: Text('${receita.tempoMinutos} minutos'),
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
            ),
    );
  }
}
