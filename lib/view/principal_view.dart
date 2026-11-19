import 'package:flutter/material.dart';
import '../controller/principal_controller.dart';
import '../controller/receitas_controller.dart';
import '../model/receita.dart';
import 'receitas/detalhes_receita_view.dart';

class PrincipalView extends StatelessWidget {
  const PrincipalView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PrincipalController();

    const verde = Color(0xFF718873);
    const fundo = Color(0xFFFAF9F6);

    final rotas = <String, String>{
      'Buscar receitas': 'buscar_receitas',
      'Criar receita': 'criar_receita',
      'Favoritas': 'favoritos',
    };

    final icones = <String, IconData>{
      'Buscar receitas': Icons.search,
      'Surpreenda-me': Icons.casino_outlined,
      'Criar receita': Icons.add_circle_outline,
      'Favoritas': Icons.favorite_border,
    };

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        title: Text(controller.obterTitulo()),
        backgroundColor: fundo,
        actions: [
          IconButton(
            tooltip: 'Perfil',
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, 'perfil');
            },
          ),
      
          IconButton(
            tooltip: 'Sobre',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, 'sobre');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.spa_outlined,
                  size: 36,
                  color: verde,
                ),
                SizedBox(height: 16),
                Text(
                  'O que vamos cozinhar?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Encontre inspiração para sua próxima receita.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Explore seu caderno',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...controller.obterOpcoesMenu().map((opcao) {
            return Card(
              color: Colors.white,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Color(0xFFE7E7E0)),
              ),
              child: ListTile(
                leading: Icon(icones[opcao], color: verde),
                title: Text(opcao),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final rota = rotas[opcao];

                  if (opcao == 'Surpreenda-me') {
                    _surpreender(context);
                  } else if (rota != null) {
                    Navigator.pushNamed(context, rota);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
  Future<void> _surpreender(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final resultado = await ReceitasController.instancia.streamReceitas().first;
      final docs = resultado.docs;
      if (docs.isEmpty) {
        messenger.showSnackBar(const SnackBar(content: Text('Ainda não existem receitas para sortear.')));
        return;
      }
      docs.shuffle();
      final dados = docs.first.data();
      if (!context.mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => DetalhesReceitaView(receita: Receita.fromMap(dados)),
      ));
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Não foi possível sortear uma receita: $e')));
      }
    }
  }

}
