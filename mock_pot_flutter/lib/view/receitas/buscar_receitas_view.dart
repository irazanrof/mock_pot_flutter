import 'package:flutter/material.dart';
import '../../controller/receitas_controller.dart';

class BuscarReceitasView extends StatefulWidget {
  const BuscarReceitasView({super.key});

  @override
  State<BuscarReceitasView> createState() => _BuscarReceitasViewState();
}

class _BuscarReceitasViewState extends State<BuscarReceitasView> {
  final TextEditingController _campoBusca = TextEditingController();
  String _termo = '';
  String _categoria = 'Todas as categorias';
  static const _categorias = ['Todas as categorias', 'Café da manhã', 'Almoço', 'Sobremesa', 'Lanche'];

  @override
  void dispose() {
    _campoBusca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ReceitasController.instancia;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar receitas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _campoBusca,
              onChanged: (valor) => setState(() => _termo = valor),
              decoration: const InputDecoration(
                hintText: 'Digite o nome da receita',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(labelText: 'Filtrar por categoria', prefixIcon: Icon(Icons.category_outlined)),
              items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (valor) => setState(() => _categoria = valor ?? 'Todas as categorias'),
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final resultados = controller.pesquisar(_termo).where((r) => _categoria == 'Todas as categorias' || r.categoria == _categoria).toList();

                if (resultados.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma receita encontrada.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: resultados.length,
                  itemBuilder: (context, index) {
                    final receita = resultados[index];

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
                        trailing: const Icon(Icons.chevron_right),
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
          ),
        ],
      ),
    );
  }
}
